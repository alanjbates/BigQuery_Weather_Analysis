/*
Find the closest 3 weather stations to each state capital
*/

SELECT *
FROM (
  	SELECT
  	ROW_NUMBER() OVER(PARTITION BY location ORDER BY Distance ASC) AS ROW_RANK --Rank the weather stations by capital closest to farthest
  	,subq,*
  	FROM (
        	SELECT
        	ST_DISTANCE(
                    	ST_GEOGPOINT(capitals.longitude, capitals.latitude),
                    	ST_GEOGPOINT( stations.lon , stations.lat )
                    	)
                    	* 0.00062137 AS Distance --convert meters to miles
        	,CONCAT(capitals.city, ', ', capitals.state) AS location
        	,stations.usaf
          ,stations.wban
        	FROM `abates-dsc.weather_analysis.us_state_capitals` capitals
            	CROSS JOIN `bigquery-public-data.noaa_gsod.stations` AS stations --EXPLODE and calc distance between each possible combination of weather station and your locations
        	WHERE stations.lat<50 AND stations.lat>15 AND stations.lon<-60 AND stations.lon>-130 --FILTER Weather Stations to USA region only
        	AND capitals.longitude IS NOT NULL AND capitals.latitude IS NOT NULL
      	) subq
  	) subq2
WHERE ROW_RANK <= 3 --Select the closest 3 weather stations for each of your locations
