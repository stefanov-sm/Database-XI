select case when qty < 0 then 0 else qty end as qty
from 
(
 select $RAINFALL-(select sum(reading_rainfall) from meteo_readings where reading_time >= current_date - 3) as qty
 where (select reading_temp from meteo_readings order by reading_time desc limit 1) between $MIN_TEMP and $MAX_TEMP
   and (select reading_illumination from meteo_readings order by reading_time desc limit 1) < $MAX_ILLUMINATION
) as t;
