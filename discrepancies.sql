-- drop table if exists discrepancies;
create table discrepancies
(
  id integer,
  "A.A.11" integer, "B.B.32" integer, "C.C.17" integer, "D.D.59" integer, "E.E.76" integer, 
  "A.F.11" integer, "B.G.32" integer, "C.H.17" integer, "D.I.59" integer, "E.J.76" integer,
  "A.K.11" text,    "B.L.32" text,    "C.M.17" text,    "D.N.59" text,    
  "E.O.11" text,    "F.P.32" text,    "G.Q.17" text,    "H.R.59" text,
  "A.S.11" text,    "B.T.32" text,    "C.U.17" text,    "D.V.59" text,
  "E.W.11" text,    "F.X.32" text,    "G.Y.17" text,    "H.Z.59" text,
  tablename text 
);

insert into discrepancies values
(1, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 'X101', 'X102', 'X103', 'X104', 'X105', 'X106', 'X107', 'X108', 'X109', 'X110', 'Y101', 'Y102', 'Y103', 'Y104', 'Y105', 'Y106', 'table_A'),
(1, 101, 102, 103, 104, 115, 106, 107, 108, 109, 110, 'X101', 'X102', 'X103', 'X104', 'X115', 'X106', 'X107', 'X108', 'X109', 'X110', 'Y101', 'Y102', 'Y103', 'Y104', 'Y105', 'Y106', 'table_B'),
(2, 201, 202, 203, 204, 205, 226, 207, 208, 209, 210, 'X201', 'X202', 'X203', 'X204', 'X205', 'X206', 'X207', 'X208', 'X209', 'X210', 'Y201', 'Y202', 'Y203', 'Y204', 'Y205', 'Y206', 'table_A'),
(2, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 'X201', 'X202', 'X203', 'X204', 'X205', 'X226', 'X207', 'X208', 'X209', 'X210', 'Y201', 'Y202', 'Y203', 'Y204', 'Y205', 'Y206', 'table_B'),
(3, 301, 302, 303, 304, 305, 306, 337, 308, 309, 310, 'X301', 'X302', 'X303', 'X304', 'X305', 'X306', 'X307', 'X308', 'X309', 'X310', 'Y301', 'Y302', 'Y303', 'Y304', 'Y305', 'Y306', 'table_A'),
(3, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 'X301', 'X302', 'X303', 'X304', 'X305', 'X306', 'X307', 'X308', 'X309', 'X310', 'Y301', 'Y302', 'Y303', 'Y304', 'Y305', 'Y336', 'table_B'),
(4, 401, 402, 403, 404, 405, 406, 407, 448, 409, 410, 'X401', 'X402', 'X403', 'X404', 'X405', 'X406', 'X407', 'X408', 'X409', 'X410', 'Y401', 'Y402', 'Y403', 'Y404', 'Y405', 'Y406', 'table_A'),
(4, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 'X401', 'X402', 'X403', 'X404', 'X405', 'X406', 'X407', 'X408', 'X409', 'X410', 'Y411', 'Y402', 'Y403', 'Y404', 'Y405', 'Y406', 'table_B'),
(5, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 'X511', 'X502', 'X503', 'X504', 'X505', 'X506', 'X507', 'X508', 'X509', 'X510', 'Y501', 'Y502', 'Y503', 'Y504', 'Y505', 'Y506', 'table_A'),
(5, 501, 502, 503, 504, 505, 506, 507, 508, 559, 510, 'X501', 'X502', 'X503', 'X504', 'X505', 'X506', 'X507', 'X508', 'X509', 'X510', 'Y501', 'Y502', 'Y503', 'Y504', 'Y505', 'Y506', 'table_B');


with t as
(
 select	id,
		to_jsonb(nth_value(dt, 1) over w) fv, 
		to_jsonb(nth_value(dt, 2) over w) lv
 from discrepancies dt
 window w as (
 		partition by id order by tablename 
	 	rows between unbounded preceding and current row)
)
select t.id as "Row ID", lat.*
from t
cross join lateral
(
 select a.column_name as "Column", 
 		a.value as "Value A",
 		b.value as "Value B"
 from jsonb_each(fv) as a(column_name, value) 
 join jsonb_each(lv) as b(column_name, value)
   on a.column_name = b.column_name
 where a.value <> b.value -- and a.column_name <> 'tablename'
) as lat
where lv is not null;
