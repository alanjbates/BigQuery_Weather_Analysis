# BigQuery Weather Analysis

Here is an example of the power of BigQuery and SQL for feature engineering. 

This will give you a record of weather data, for every day, for every location in your dataset.

It can be used as input into further analysis or data products.

![Image of Architecture](https://raw.githubusercontent.com/alanjbates/BigQuery_Weather_Analysis/master/images/weather_feature.png)

Cross join calendar and location together to force a row for every day for every location.

Calc the distance between each of your location and every weather station using BigQuery geo functions.

Clean up the noaa gsod data by adding human readable attribute names.

Account for missing weather station data by using the three closest locations and COALESCE the output to the first not null value for every attribute.

Here is a sample of the results for one location:

![Image of Architecture](https://raw.githubusercontent.com/alanjbates/BigQuery_Weather_Analysis/master/images/weather_feature_results.png)
