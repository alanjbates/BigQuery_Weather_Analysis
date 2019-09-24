/*
This view returns the final result of weather location day.
*/
SELECT
--Location and Date
driver.location
,driver.cal_date 

--Temp Info
,COALESCE(l1.temp, l2.temp, l3.temp) AS AverageTemp
,COALESCE(l1.max, l2.max, l3.max) AS MaxTemp
,COALESCE(l1.min, l2.min, l3.min) AS MinTemp
,COALESCE(l1.count_temp, l2.count_temp, l3.count_temp) AS NumberofTempObservations

---Dewpoint Info
,COALESCE(l1.dewp, l2.dewp, l3.dewp) AS AverageDewpoint
,COALESCE(l1.count_dewp, l2.count_dewp, l3.count_dewp) AS NumberofDewpointObservations

--Pressure Info
,COALESCE(l1.slp, l2.slp, l3.slp) AS AverageSeaLevelPressure
,COALESCE(l1.count_slp, l2.count_slp, l3.count_slp) AS NumberofSeaLevelPressureObservations
,COALESCE(l1.stp, l2.stp, l3.stp) AS AverageStationPressure
,COALESCE(l1.count_stp, l2.count_stp, l3.count_stp) AS NumberofStationPressureObservations


--Wind Info
,COALESCE(l1.wdsp, l2.wdsp, l3.wdsp) AS AverageWindspeedKnots
,COALESCE(l1.mxpsd, l2.mxpsd, l3.mxpsd) AS MaxSustainedWindspeedKnots
,COALESCE(l1.gust, l2.gust, l3.gust) AS MaxGustWindspeedKnots
,COALESCE(l1.count_wdsp, l2.count_wdsp, l3.count_wdsp) AS NumberofWindspeedObservations

--Precipitation Info 
,COALESCE(l1.flag_prcp, l2.flag_prcp, l3.flag_prcp) AS PrecipitationLengthLookup
,COALESCE(l1.prcp, l2.prcp, l3.prcp) AS TotalRainFallAndSnowMelt
,COALESCE(l1.sndp, l2.sndp, l3.sndp) AS SnowDepth
,COALESCE(l1.visib, l2.visib, l3.visib) AS AverageVisibilityDistance
,COALESCE(l1.count_visib, l2.count_visib, l3.count_visib) AS NumberofVisibilityObservations
,COALESCE(l1.fog, l2.fog, l3.fog) AS FogBoolean
,COALESCE(l1.rain_drizzle, l2.rain_drizzle, l3.rain_drizzle) AS RainBoolean
,COALESCE(l1.snow_ice_pellets, l2.snow_ice_pellets, l3.snow_ice_pellets) AS SnowIceBoolean
,COALESCE(l1.hail, l2.hail, l3.hail) AS HailBoolean
,COALESCE(l1.thunder, l2.thunder, l3.thunder) AS ThunderBoolean
,COALESCE(l1.tornado_funnel_cloud, l2.tornado_funnel_cloud, l3.tornado_funnel_cloud) AS TornadoFunnelCloudBoolean

FROM `abates-dsc.weather_analysis.vw_location_date_driver` driver

    LEFT OUTER JOIN (
                    SELECT w.*, l1.usaf AS l_usaf, l1.wban AS l_wban, l1.location, l1.ROW_RANK
                    FROM `abates-dsc.weather_analysis.vw_location_weather_station` l1
                    INNER JOIN `bigquery-public-data.noaa_gsod.gsod20*` w
                        ON concat(l1.usaf,l1.wban) = concat(w.stn,w.wban)
                    ) l1
            ON CAST(CONCAT(l1.year,'-', l1.mo, '-',l1.da) AS DATE) = driver.cal_date 
            AND l1.location = driver.location
            AND l1.ROW_RANK = 1
                    
    LEFT OUTER JOIN (
                    SELECT w.*, l2.usaf AS l_usaf, l2.wban AS l_wban, l2.location, l2.ROW_RANK
                    FROM `abates-dsc.weather_analysis.vw_location_weather_station` l2
                    INNER JOIN `bigquery-public-data.noaa_gsod.gsod20*` w
                        ON concat(l2.usaf,l2.wban) = concat(w.stn,w.wban)
                    ) l2
            ON CAST(CONCAT(l2.year,'-', l2.mo, '-',l2.da) AS DATE) = driver.cal_date 
            AND l2.location = driver.location
            AND l2.ROW_RANK = 2
            
    LEFT OUTER JOIN (
                    SELECT w.*, l3.usaf AS l_usaf, l3.wban AS l_wban, l3.location, l3.ROW_RANK
                    FROM `abates-dsc.weather_analysis.vw_location_weather_station` l3
                    INNER JOIN `bigquery-public-data.noaa_gsod.gsod20*` w
                        ON concat(l3.usaf,l3.wban) = concat(w.stn,w.wban)
                    ) l3
            ON CAST(CONCAT(l3.year,'-', l3.mo, '-',l3.da) AS DATE) = driver.cal_date 
            AND l3.location = driver.location
            AND l3.ROW_RANK = 3
            
--WHERE driver.location = 'Columbus, Ohio' --testing
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27
ORDER BY driver.cal_date DESC