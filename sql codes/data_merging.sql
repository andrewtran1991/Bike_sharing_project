/*
Objective: Combine data tables
*/

DROP TABLE IF EXISTS [bike_sharing].[dbo].[main-divvy-tripdata]
CREATE TABLE [bike_sharing].[dbo].[main-divvy-tripdata](
        [ride_id] [nvarchar](50) NOT NULL,
        [rideable_type] [nvarchar](50),
        [started_at] [datetime2](7),
        [ended_at] [datetime2](7),
        [start_station_name] [nvarchar](MAX),
        [start_station_id] [nvarchar](MAX),
        [end_station_name] [nvarchar](MAX),
        [end_station_id] [nvarchar](MAX),
        [start_lat] [float],
        [start_lng] [float],
        [end_lat] [float],
        [end_lng] [float],
        [member_casual] [nvarchar](50)
    )


TRUNCATE TABLE [bike_sharing].[dbo].[main-divvy-tripdata]
INSERT INTO [bike_sharing].[dbo].[main-divvy-tripdata] (
        ride_id,
        rideable_type,
        started_at,
        ended_at,
        start_station_name,
        start_station_id,
        end_station_name,
        end_station_id,
        start_lat,
        start_lng,
        end_lat,
        end_lng,
        member_casual
    ) SELECT
        ride_id,
        rideable_type,
        started_at,
        ended_at,
        start_station_name,
        start_station_id,
        end_station_name,
        end_station_id,
        start_lat,
        start_lng,
        end_lat,
        end_lng,
        member_casual
    FROM (SELECT * FROM [bike_sharing].[dbo].[202010-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202011-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202012-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202101-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202102-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202103-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202104-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202105-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202106-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202107-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202108-divvy-tripdata]
			UNION ALL
			SELECT * FROM [bike_sharing].[dbo].[202109-divvy-tripdata] 
			)t
