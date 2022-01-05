/*
Objective: Data Cleaning Process
*/

--Number of rows
SELECT count(*) FROM [bike_sharing].[dbo].[main-divvy-tripdata]

--Add Ride Length Field
ALTER TABLE [bike_sharing].[dbo].[main-divvy-tripdata] ADD ride_length_sec [int] NULL;
UPDATE [bike_sharing].[dbo].[main-divvy-tripdata] SET ride_length_sec = DATEDIFF(SS, started_at, ended_at);

--Add Day of the Week Field
ALTER TABLE [bike_sharing].[dbo].[main-divvy-tripdata] ADD day_of_week NVARCHAR(10) NULL;
UPDATE [bike_sharing].[dbo].[main-divvy-tripdata] SET day_of_week = DATENAME(WEEKDAY, started_at);

--Add Month (number and text)
ALTER TABLE [bike_sharing].[dbo].[main-divvy-tripdata] ADD ride_month [int] NULL;
UPDATE [bike_sharing].[dbo].[main-divvy-tripdata] SET ride_month = month(started_at);

ALTER TABLE [bike_sharing].[dbo].[main-divvy-tripdata] ADD ride_month_text NVARCHAR(10) NULL;
UPDATE [bike_sharing].[dbo].[main-divvy-tripdata] SET ride_month_text = DATENAME(MONTH, started_at);

--Add Year
ALTER TABLE [bike_sharing].[dbo].[main-divvy-tripdata] ADD ride_year [int] NULL;
UPDATE [bike_sharing].[dbo].[main-divvy-tripdata] SET ride_year = year(started_at);

--Remove records where the start time was later than the end time
SELECT sum(CASE WHEN started_at > ended_at THEN 1 ELSE 0 END) AS Total_Error,
	   count(*) AS "Total", 
	   (sum(CASE WHEN started_at > ended_at THEN 1 ELSE 0 END)/(count(*) * 1.0) * 100) AS "Percent"
FROM [bike_sharing].[dbo].[main-divvy-tripdata]

DELETE FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE started_at > ended_at;

--Ride Lengths Less than a Minute
SELECT sum(CASE WHEN ride_length_sec < 60 THEN 1 ELSE 0 END) AS Total_Error,
	   count(*) AS "Total", 
	   (sum(CASE WHEN ride_length_sec < 60 THEN 1 ELSE 0 END)/(count(*) * 1.0) * 100) AS "Percent"
FROM [bike_sharing].[dbo].[main-divvy-tripdata]

DELETE FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE ride_length_sec < 60;

--Remove Test Fields
SELECT count(*) as Num_error FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE start_station_id LIKE '%TEST%' OR end_station_id LIKE '%TEST%';

DELETE FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE start_station_id LIKE '%TEST%' OR end_station_id LIKE '%TEST%';

--Remove trips that are missing docking station identifiers
SELECT count(*) as Num_missing FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE start_station_id IS NULL OR end_station_id IS NULL;

DELETE FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE start_station_id IS NULL OR end_station_id IS NULL;

--Remove trips that are missing any coordinates
SELECT count(*) as Num_missing FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE start_lat IS NULL OR start_lng IS NULL OR end_lat IS NULL OR end_lng IS NULL;

DELETE FROM [bike_sharing].[dbo].[main-divvy-tripdata]
WHERE start_lat IS NULL OR start_lng IS NULL OR end_lat IS NULL OR end_lng IS NULL;

--Find duplicates
SELECT ride_id, count(*)
FROM [bike_sharing].[dbo].[main-divvy-tripdata]
GROUP BY ride_id
HAVING count(*) > 1

SELECT DISTINCT count(*)
FROM [bike_sharing].[dbo].[main-divvy-tripdata] --4,294,637 rows