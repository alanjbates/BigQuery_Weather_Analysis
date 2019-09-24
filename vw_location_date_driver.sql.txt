/*
This view creates a driver table that forces a row for each location, for each day.
*/

SELECT
CONCAT(city, ', ', state) AS Location
,cal_driver.cal_date

FROM `abates-dsc.weather_analysis.calendar` cal_driver

    CROSS JOIN `abates-dsc.weather_analysis.us_state_capitals` loc_driver
    
WHERE EXTRACT(YEAR FROM cal_driver.cal_date) BETWEEN EXTRACT(YEAR FROM CURRENT_DATE)-1 AND EXTRACT(YEAR FROM CURRENT_DATE)
AND cal_driver.cal_date < CURRENT_DATE
GROUP BY 1,2