/*
Objective: Analysis
*/

--Number of rides--
--Monthly number of rides within a year
SELECT [ride_month], [ride_year], count(*) AS Number_of_rides
FROM [bike_sharing].[dbo].[main-divvy-tripdata]
GROUP BY [ride_month], [ride_year]
ORDER BY [ride_year], [ride_month]

--Numbers of Rides from Each Type of Customer
SELECT [ride_month], [ride_year], [member_casual], count(*) AS Number_of_rides
FROM [bike_sharing].[dbo].[main-divvy-tripdata]
GROUP BY [ride_month], [ride_year], [member_casual]
ORDER BY [ride_year], [ride_month], [member_casual]

 SELECT * 
 FROM (SELECT
			ride_id,
            ride_month_text,
            member_casual
        FROM [bike_sharing].[dbo].[main-divvy-tripdata]
	) AS t
    PIVOT (COUNT(ride_id)
			FOR ride_month_text IN (
            [October],[November],
            [December],[January],[February],[March],
            [April],[May],[June],[July], [August],[September]
			)
    ) AS pvt_tbl;


--Total Ridership by Weekday
SELECT *
FROM (SELECT 
			ride_id,
			day_of_week,
            member_casual
			FROM [bike_sharing].[dbo].[main-divvy-tripdata]
	) AS t
	PIVOT (COUNT(ride_id)
			FOR day_of_week IN (
            [Sunday],[Monday],[Tuesday],[Wednesday],
            [Thursday],[Friday],[Saturday]
			)
    ) AS pvt_tbl;



--Average Ride Length--
--Box plot stats
SELECT DISTINCT
  member_casual
 ,MAX(ride_length_sec) OVER (PARTITION BY member_casual) AS MaxDuration
 ,MIN(ride_length_sec) OVER (PARTITION BY member_casual) AS MinDuration
 ,AVG(CAST(ride_length_sec AS BIGINT)) OVER (PARTITION BY member_casual) AS MeanDuration 
 ,(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ride_length_sec) OVER (PARTITION BY member_casual)) AS Percentile25
 ,(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ride_length_sec) OVER (PARTITION BY member_casual)) AS Percentile75
 ,(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY ride_length_sec) OVER (PARTITION BY member_casual)) AS MedianDuration
FROM [bike_sharing].[dbo].[main-divvy-tripdata]


--Average Monthly Ride Length
SELECT *
FROM (SELECT 
			ride_month_text,
            member_casual,
			ride_length_sec
		FROM [bike_sharing].[dbo].[main-divvy-tripdata]
	) AS t
	PIVOT (AVG(ride_length_sec)
			FOR ride_month_text IN (
            [October],[November],
            [December],[January],[February],[March],
            [April],[May],[June],[July], [August],[September]
			)
    ) AS pvt_tbl;

--Average Ride Length by Weekday
SELECT *
FROM (SELECT 
			day_of_week,
            member_casual,
			ride_length_sec
		FROM [bike_sharing].[dbo].[main-divvy-tripdata]
	) AS t
	PIVOT (AVG(ride_length_sec)
			FOR day_of_week IN (
            [Sunday],[Monday],[Tuesday],[Wednesday],
            [Thursday],[Friday],[Saturday]
			)
    ) AS pvt_tbl;

--Number of rider by Bike Type and Membership Type
SELECT rideable_type, member_casual, COUNT(*)
FROM [bike_sharing].[dbo].[main-divvy-tripdata]
GROUP BY rideable_type, member_casual
ORDER BY rideable_type, member_casual

SELECT *
FROM (SELECT ride_id, rideable_type, member_casual FROM [bike_sharing].[dbo].[main-divvy-tripdata]) AS t
PIVOT (COUNT(ride_id) FOR rideable_type IN (classic_bike, docked_bike, electric_bike)