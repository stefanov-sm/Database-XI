create extention if not exists pgcrypto;

create or replace function decode_jwt(jwt text, secret text)
returns table (pos integer, contents text, valid_signature boolean) language sql immutable as
$$
with parts as (
  select * from regexp_split_to_table(jwt, '\.') with ordinality as t(x, pos)
), decoded_parts AS (
  select pos,
         case when pos = 3 then x
           else convert_from(decode(rpad(translate(x, '-_', '+/'), 4 * ((length(x) + 3) / 4), '='), 'base64'), 'utf-8')
         end as contents
  from parts
), signature_check as (
  select
    (select string_agg(x, '.') from parts where pos in (1,2)) as signing_input, -- Header + Payload
    decode(rpad(translate((select contents from decoded_parts where pos = 3), '-_', '+/'), 4 * ((length((select contents from decoded_parts where pos = 3)) + 3) / 4), '='), 'base64') as signature, -- base64url -> base64 -> binary
    (select contents::jsonb ->> 'alg' from decoded_parts where pos = 1) as algorithm -- read `alg` from header
)
SELECT d.pos, d.contents,
       case 
         when d.pos = 3 and algorithm = 'HS256' then 
           encode(hmac(signing_input, secret, 'sha256'), 'base64') = encode(signature, 'base64')
         when d.pos = 3 and algorithm = 'HS384' then 
           encode(hmac(signing_input, secret, 'sha384'), 'base64') = encode(signature, 'base64')
         when d.pos = 3 and algorithm = 'HS512' then 
           encode(hmac(signing_input, secret, 'sha512'), 'base64') = encode(signature, 'base64')
         else null
       end as valid_signature
from decoded_parts d
left join signature_check sc on true
order by d.pos;
$$;





--hs256
select * from decode_jwt(
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30', 
  'a-string-secret-at-least-256-bits-long'
);



--hs384
select * from decode_jwt(
  'eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.owv7q9nVbW5tqUezF_G2nHTra-ANW3HqW9epyVwh08Y-Z-FKsnG8eBIpC4GTfTVU', 
  'a-valid-string-secret-that-is-at-least-384-bits-long'
);


--hs512
select * from decode_jwt(
  'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.ANCf_8p1AE4ZQs7QuqGAyyfTEgYrKSjKWkhBk5cIn1_2QVr2jEjmM-1tu7EgnyOf_fAsvdFXva8Sv05iTGzETg', 
  'a-valid-string-secret-that-is-at-least-512-bits-long-which-is-very-long'
);

