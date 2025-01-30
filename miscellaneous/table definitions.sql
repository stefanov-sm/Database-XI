create table meteo_readings
(
reading_time timestamp not null default now(), 
reading_temp numeric, 
reading_humidity numeric, 
reading_rainfall numeric, 
reading_windspeed numeric, 
reading_illumination numeric,
reading_wind_angle numeric,
reading_pressure numeric
);

INSERT INTO meteo_readings (reading_time, reading_rainfall, reading_temp, reading_illumination, reading_windspeed)
VALUES
('2025-01-27 06:00:00', 0.0,  18, 300, 5),
('2025-01-27 14:00:00', 0.0,  22, 800, 7),
('2025-01-27 22:00:00', 0.0,  20, 400, 6),
('2025-01-28 06:00:00', 5.0,  17, 250, 10),
('2025-01-28 14:00:00', 0.0,  23, 850, 12),
('2025-01-28 22:00:00', 0.0,  19, 350, 9),
('2025-01-29 06:00:00', 0.0,  16, 200, 8),
('2025-01-29 14:00:00', 10.0, 24, 900, 15),
('2025-01-29 22:00:00', 0.0,  21, 450, 11),
('2025-01-30 06:00:00', 0.0,  19, 220, 7),
('2025-01-30 14:00:00', 0.0,  25, 950, 14),
('2025-01-30 22:00:00', 0.0,  22, 500, 10),
('2025-01-30 06:00:00', 7.5,  21, 220, 7),
('2025-01-30 14:00:00', 0.0,  26, 950, 14),
('2025-01-30 22:00:00', 2.1,  24, 500, 10);

create or replace function pg_temp.randomstring(nchars integer)
returns text language sql as
$$
 select lpad((random() * (10^nchars))::integer::text, nchars, '0');
$$;
