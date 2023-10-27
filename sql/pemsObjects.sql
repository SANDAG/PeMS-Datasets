/*
Removes all PeMS objects and re-creates them. Do not run unless intention
is to drop all PeMS data objects. See the PeMS Data Clearinghouse for raw
data-sets and metadata.

http://pems.dot.ca.gov/

*/
SET NOCOUNT ON
GO


/*****************************************************************************/
-- remove all PeMS objects
-- comment out for safety
--DROP TABLE IF EXISTS [pems].[census_vclass_hour]
--DROP TABLE IF EXISTS [pems].[holiday]
--DROP TABLE IF EXISTS [pems].[station_aadt]
--DROP TABLE IF EXISTS [pems].[station_day]
--DROP TABLE IF EXISTS [pems].[station_five_minute]
--DROP TABLE IF EXISTS [pems].[station_hour]
--DROP TABLE IF EXISTS [pems].[station_metadata]
--DROP TABLE IF EXISTS [pems].[time_min5_xref]
--DROP TABLE IF EXISTS [pems].[time_min60_xref]
--DROP FUNCTION IF EXISTS [pems].[fn_sample_size]
--DROP FUNCTION IF EXISTS [pems].[fn_agg_station_day]
--DROP PROCEDURE IF EXISTS [pems].[sp_agg_station_aadt]
--DROP PROCEDURE IF EXISTS [pems].[sp_agg_station_five_minute_flow]
--DROP PROCEDURE IF EXISTS [pems].[sp_agg_station_five_minute_speed]
--DROP PROCEDURE IF EXISTS [pems].[sp_agg_station_hour_flow]
--DROP PROCEDURE IF EXISTS [pems].[sp_agg_station_hour_speed]
--DROP SCHEMA IF EXISTS [pems]
--GO




/*****************************************************************************/
-- create PeMS schema and tables

-- schemas
CREATE SCHEMA [pems]
GO


-- PeMS Clearinghouse data-set
-- Type: Census V-Class Hour
CREATE TABLE [pems].[census_vclass_hour] (
	[timestamp] smalldatetime NOT NULL,
	[census_station_identifier] bigint NOT NULL,
    [census_substation_identifier] bigint NOT NULL,
    [freeway_identifier] char(5) NOT NULL,
    [freeway_direction] char(1) NOT NULL,
    [fips_city_code] char(5) NOT NULL,
    [fips_county_code] char(3) NOT NULL,
    [district_identifier] char(2) NOT NULL,
    [absolute_postmile] decimal(7,3) NOT NULL,
    [station_type] char(2) NOT NULL,
    [census_station_set_id] bigint NOT NULL,
    [flow] int NOT NULL,
    [samples] tinyint NOT NULL,
    [flow_vehicle_class_0] int NULL,
    [flow_vehicle_class_1] int NULL,
    [flow_vehicle_class_2] int NULL,
    [flow_vehicle_class_3] int NULL,
    [flow_vehicle_class_4] int NULL,
    [flow_vehicle_class_5] int NULL,
    [flow_vehicle_class_6] int NULL,
    [flow_vehicle_class_7] int NULL,
    [flow_vehicle_class_8] int NULL,
    [flow_vehicle_class_9] int NULL,
    [flow_vehicle_class_10] int NULL,
    [flow_vehicle_class_11] int NULL,
    [flow_vehicle_class_12] int NULL,
    [flow_vehicle_class_13] int NULL,
    [flow_vehicle_class_14] int NULL,
    INDEX [ccsi_pems_census_vclass_hour] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_census_vclass_hour] UNIQUE ([timestamp], [census_station_identifier], [census_substation_identifier])
    )
GO


-- PeMS holiday date table
CREATE TABLE [pems].[holiday] (
	[date] date NOT NULL,
	[holiday] char(50) NOT NULL,
	[type] char(20) NOT NULL,
    INDEX [ccsi_pems_holiday] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_holiday] UNIQUE ([date], [holiday])
    )
INSERT INTO [pems].[holiday] VALUES
	('2000-01-14','Martin Luther King Jr. Day','Residual'),
	('2000-01-17','Martin Luther King Jr. Day','Actual'),
	('2000-01-18','Martin Luther King Jr. Day','Residual'),
	('2000-02-10','Lincoln''s Birthday','Residual'),
	('2000-02-11','Lincoln''s Birthday','Observed'),
	('2000-02-12','Lincoln''s Birthday','Actual'),
	('2000-02-14','Lincoln''s Birthday','Residual'),
	('2000-02-18','Washington''s Birthday','Residual'),
	('2000-02-21','Washington''s Birthday','Actual'),
	('2000-02-22','Washington''s Birthday','Residual'),
	('2000-03-30','Cesar Chavez Day','Residual'),
	('2000-03-31','Cesar Chavez Day','Actual'),
	('2000-04-03','Cesar Chavez Day','Residual'),
	('2000-04-20','Good Friday','Residual'),
	('2000-04-21','Good Friday','Actual'),
	('2000-04-24','Good Friday','Residual'),
	('2000-05-26','Memorial Day','Residual'),
	('2000-05-29','Memorial Day','Actual'),
	('2000-05-30','Memorial Day','Residual'),
	('2000-07-03','Independence Day','Residual'),
	('2000-07-04','Independence Day','Actual'),
	('2000-07-05','Independence Day','Residual'),
	('2000-09-01','Labor Day','Residual'),
	('2000-09-04','Labor Day','Actual'),
	('2000-09-05','Labor Day','Residual'),
	('2000-10-07','Columbus Day','Residual'),
	('2000-10-09','Columbus Day','Actual'),
	('2000-10-10','Columbus Day','Residual'),
	('2000-11-09','Veterans Day','Residual'),
	('2000-11-10','Veterans Day','Observed'),
	('2000-11-11','Veterans Day','Actual'),
	('2000-11-13','Veterans Day','Residual'),
	('2000-11-17','Thanksgiving','Residual'),
	('2000-11-20','Thanksgiving','Residual'),
	('2000-11-21','Thanksgiving','Residual'),
	('2000-11-22','Thanksgiving','Residual'),
	('2000-11-23','Thanksgiving','Actual'),
	('2000-11-24','Day After Thanksgiving','Actual'),
	('2000-11-27','Day After Thanksgiving','Residual'),
	('2000-12-15','Christmas Eve','Residual'),
	('2000-12-18','Christmas Eve','Residual'),
	('2000-12-19','Christmas Eve','Residual'),
	('2000-12-20','Christmas Eve','Residual'),
	('2000-12-21','Christmas Eve','Residual'),
	('2000-12-22','Christmas Eve','Residual'),
	('2000-12-24','Christmas Eve','Actual'),
	('2000-12-25','Christmas','Actual'),
	('2000-12-26','Christmas','Residual'),
	('2000-12-27','Christmas','Residual'),
	('2000-12-28','Christmas','Residual'),
	('2000-12-29','Christmas','Residual'),
	('2001-01-01','New Years','Actual'),
	('2001-01-02','New Years','Residual'),
	('2001-01-12','Martin Luther King Jr. Day','Residual'),
	('2001-01-15','Martin Luther King Jr. Day','Actual'),
	('2001-01-16','Martin Luther King Jr. Day','Residual'),
	('2001-02-09','Lincoln''s Birthday','Residual'),
	('2001-02-12','Lincoln''s Birthday','Actual'),
	('2001-02-13','Lincoln''s Birthday','Residual'),
	('2001-02-16','Washington''s Birthday','Residual'),
	('2001-02-19','Washington''s Birthday','Actual'),
	('2001-02-20','Washington''s Birthday','Residual'),
	('2001-03-29','Cesar Chavez Day','Residual'),
	('2001-03-30','Cesar Chavez Day','Observed'),
	('2001-03-31','Cesar Chavez Day','Actual'),
	('2001-04-02','Cesar Chavez Day','Residual'),
	('2001-04-12','Good Friday','Residual'),
	('2001-04-13','Good Friday','Actual'),
	('2001-04-16','Good Friday','Residual'),
	('2001-05-25','Memorial Day','Residual'),
	('2001-05-28','Memorial Day','Actual'),
	('2001-05-29','Memorial Day','Residual'),
	('2001-07-03','Independence Day','Residual'),
	('2001-07-04','Independence Day','Actual'),
	('2001-07-05','Independence Day','Residual'),
	('2001-08-30','Labor Day','Residual'),
	('2001-09-03','Labor Day','Actual'),
	('2001-09-04','Labor Day','Residual'),
	('2001-10-06','Columbus Day','Residual'),
	('2001-10-08','Columbus Day','Actual'),
	('2001-10-09','Columbus Day','Residual'),
	('2001-11-09','Veterans Day','Residual'),
	('2001-11-11','Veterans Day','Actual'),
	('2001-11-12','Veterans Day','Observed'),
	('2001-11-13','Veterans Day','Residual'),
	('2001-11-16','Thanksgiving','Residual'),
	('2001-11-19','Thanksgiving','Residual'),
	('2001-11-20','Thanksgiving','Residual'),
	('2001-11-21','Thanksgiving','Residual'),
	('2001-11-22','Thanksgiving','Actual'),
	('2001-11-23','Day After Thanksgiving','Actual'),
	('2001-11-26','Day After Thanksgiving','Residual'),
	('2001-12-14','Christmas Eve','Residual'),
	('2001-12-17','Christmas Eve','Residual'),
	('2001-12-18','Christmas Eve','Residual'),
	('2001-12-19','Christmas Eve','Residual'),
	('2001-12-20','Christmas Eve','Residual'),
	('2001-12-21','Christmas Eve','Residual'),
	('2001-12-24','Christmas Eve','Actual'),
	('2001-12-25','Christmas','Actual'),
	('2001-12-26','Christmas','Residual'),
	('2001-12-27','Christmas','Residual'),
	('2001-12-28','Christmas','Residual'),
	('2001-12-31','New Years','Residual'),
	('2002-01-01','New Years','Actual'),
	('2002-01-02','New Years','Residual'),
	('2002-01-18','Martin Luther King Jr. Day','Residual'),
	('2002-01-21','Martin Luther King Jr. Day','Actual'),
	('2002-01-22','Martin Luther King Jr. Day','Residual'),
	('2002-02-11','Lincoln''s Birthday','Residual'),
	('2002-02-12','Lincoln''s Birthday','Actual'),
	('2002-02-13','Lincoln''s Birthday','Residual'),
	('2002-02-15','Washington''s Birthday','Residual'),
	('2002-02-18','Washington''s Birthday','Actual'),
	('2002-02-19','Washington''s Birthday','Residual'),
	('2002-03-28','Good Friday','Residual'),
	('2002-03-29','Cesar Chavez Day','Residual'),
	('2002-03-29','Good Friday','Actual'),
	('2002-03-31','Cesar Chavez Day','Actual'),
	('2002-04-01','Cesar Chavez Day','Observed'),
	('2002-04-01','Good Friday','Residual'),
	('2002-04-02','Cesar Chavez Day','Residual'),
	('2002-05-24','Memorial Day','Residual'),
	('2002-05-27','Memorial Day','Actual'),
	('2002-05-28','Memorial Day','Residual'),
	('2002-07-03','Independence Day','Residual'),
	('2002-07-04','Independence Day','Actual'),
	('2002-07-05','Independence Day','Residual'),
	('2002-08-29','Labor Day','Residual'),
	('2002-09-02','Labor Day','Actual'),
	('2002-09-03','Labor Day','Residual'),
	('2002-10-11','Columbus Day','Residual'),
	('2002-10-14','Columbus Day','Actual'),
	('2002-10-15','Columbus Day','Residual'),
	('2002-11-08','Veterans Day','Residual'),
	('2002-11-11','Veterans Day','Actual'),
	('2002-11-12','Veterans Day','Residual'),
	('2002-11-22','Thanksgiving','Residual'),
	('2002-11-25','Thanksgiving','Residual'),
	('2002-11-26','Thanksgiving','Residual'),
	('2002-11-27','Thanksgiving','Residual'),
	('2002-11-28','Thanksgiving','Actual'),
	('2002-11-29','Day After Thanksgiving','Actual'),
	('2002-12-02','Day After Thanksgiving','Residual'),
	('2002-12-13','Christmas Eve','Residual'),
	('2002-12-16','Christmas Eve','Residual'),
	('2002-12-17','Christmas Eve','Residual'),
	('2002-12-18','Christmas Eve','Residual'),
	('2002-12-19','Christmas Eve','Residual'),
	('2002-12-20','Christmas Eve','Residual'),
	('2002-12-23','Christmas Eve','Residual'),
	('2002-12-24','Christmas Eve','Actual'),
	('2002-12-25','Christmas','Actual'),
	('2002-12-26','Christmas','Residual'),
	('2002-12-27','Christmas','Residual'),
	('2002-12-30','New Years','Residual'),
	('2002-12-31','New Years','Residual'),
	('2003-01-01','New Years','Actual'),
	('2003-01-02','New Years','Residual'),
	('2003-01-17','Martin Luther King Jr. Day','Residual'),
	('2003-01-20','Martin Luther King Jr. Day','Actual'),
	('2003-01-21','Martin Luther King Jr. Day','Residual'),
	('2003-02-11','Lincoln''s Birthday','Residual'),
	('2003-02-12','Lincoln''s Birthday','Actual'),
	('2003-02-13','Lincoln''s Birthday','Residual'),
	('2003-02-14','Washington''s Birthday','Residual'),
	('2003-02-17','Washington''s Birthday','Actual'),
	('2003-02-18','Washington''s Birthday','Residual'),
	('2003-03-28','Cesar Chavez Day','Residual'),
	('2003-03-31','Cesar Chavez Day','Actual'),
	('2003-04-01','Cesar Chavez Day','Residual'),
	('2003-04-17','Good Friday','Residual'),
	('2003-04-18','Good Friday','Actual'),
	('2003-04-21','Good Friday','Residual'),
	('2003-05-23','Memorial Day','Residual'),
	('2003-05-26','Memorial Day','Actual'),
	('2003-05-27','Memorial Day','Residual'),
	('2003-07-03','Independence Day','Residual'),
	('2003-07-04','Independence Day','Actual'),
	('2003-07-07','Independence Day','Residual'),
	('2003-08-28','Labor Day','Residual'),
	('2003-09-01','Labor Day','Actual'),
	('2003-09-02','Labor Day','Residual'),
	('2003-10-10','Columbus Day','Residual'),
	('2003-10-13','Columbus Day','Actual'),
	('2003-10-14','Columbus Day','Residual'),
	('2003-11-10','Veterans Day','Residual'),
	('2003-11-11','Veterans Day','Actual'),
	('2003-11-12','Veterans Day','Residual'),
	('2003-11-21','Thanksgiving','Residual'),
	('2003-11-24','Thanksgiving','Residual'),
	('2003-11-25','Thanksgiving','Residual'),
	('2003-11-26','Thanksgiving','Residual'),
	('2003-11-27','Thanksgiving','Actual'),
	('2003-11-28','Day After Thanksgiving','Actual'),
	('2003-12-01','Day After Thanksgiving','Residual'),
	('2003-12-12','Christmas Eve','Residual'),
	('2003-12-15','Christmas Eve','Residual'),
	('2003-12-16','Christmas Eve','Residual'),
	('2003-12-17','Christmas Eve','Residual'),
	('2003-12-18','Christmas Eve','Residual'),
	('2003-12-19','Christmas Eve','Residual'),
	('2003-12-22','Christmas Eve','Residual'),
	('2003-12-23','Christmas Eve','Residual'),
	('2003-12-24','Christmas Eve','Actual'),
	('2003-12-25','Christmas','Actual'),
	('2003-12-26','Christmas','Residual'),
	('2003-12-29','Christmas','Residual'),
	('2003-12-30','New Years','Residual'),
	('2003-12-31','New Years','Residual'),
	('2004-01-01','New Years','Actual'),
	('2004-01-02','New Years','Residual'),
	('2004-01-16','Martin Luther King Jr. Day','Residual'),
	('2004-01-19','Martin Luther King Jr. Day','Actual'),
	('2004-01-20','Martin Luther King Jr. Day','Residual'),
	('2004-02-11','Lincoln''s Birthday','Residual'),
	('2004-02-12','Lincoln''s Birthday','Actual'),
	('2004-02-13','Lincoln''s Birthday','Residual'),
	('2004-02-13','Washington''s Birthday','Residual'),
	('2004-02-16','Washington''s Birthday','Actual'),
	('2004-02-17','Washington''s Birthday','Residual'),
	('2004-03-30','Cesar Chavez Day','Residual'),
	('2004-03-31','Cesar Chavez Day','Actual'),
	('2004-04-01','Cesar Chavez Day','Residual'),
	('2004-04-08','Good Friday','Residual'),
	('2004-04-09','Good Friday','Actual'),
	('2004-04-12','Good Friday','Residual'),
	('2004-05-28','Memorial Day','Residual'),
	('2004-05-31','Memorial Day','Actual'),
	('2004-06-01','Memorial Day','Residual'),
	('2004-07-02','Independence Day','Residual'),
	('2004-07-04','Independence Day','Actual'),
	('2004-07-05','Independence Day','Observed'),
	('2004-07-06','Independence Day','Residual'),
	('2004-09-03','Labor Day','Residual'),
	('2004-09-06','Labor Day','Actual'),
	('2004-09-07','Labor Day','Residual'),
	('2004-10-08','Columbus Day','Residual'),
	('2004-10-11','Columbus Day','Actual'),
	('2004-10-12','Columbus Day','Residual'),
	('2004-11-10','Veterans Day','Residual'),
	('2004-11-11','Veterans Day','Actual'),
	('2004-11-12','Veterans Day','Residual'),
	('2004-11-19','Thanksgiving','Residual'),
	('2004-11-22','Thanksgiving','Residual'),
	('2004-11-23','Thanksgiving','Residual'),
	('2004-11-24','Thanksgiving','Residual'),
	('2004-11-25','Thanksgiving','Actual'),
	('2004-11-26','Day After Thanksgiving','Actual'),
	('2004-11-29','Day After Thanksgiving','Residual'),
	('2004-12-17','Christmas Eve','Residual'),
	('2004-12-20','Christmas Eve','Residual'),
	('2004-12-21','Christmas Eve','Residual'),
	('2004-12-22','Christmas Eve','Residual'),
	('2004-12-23','Christmas Eve','Residual'),
	('2004-12-24','Christmas Eve','Actual'),
	('2004-12-25','Christmas','Actual'),
	('2004-12-27','Christmas','Residual'),
	('2004-12-28','Christmas','Residual'),
	('2004-12-29','Christmas','Residual'),
	('2004-12-30','New Years','Residual'),
	('2004-12-31','New Years','Observed'),
	('2005-01-01','New Years','Actual'),
	('2005-01-03','New Years','Residual'),
	('2005-01-14','Martin Luther King Jr. Day','Residual'),
	('2005-01-17','Martin Luther King Jr. Day','Actual'),
	('2005-01-18','Martin Luther King Jr. Day','Residual'),
	('2005-02-10','Lincoln''s Birthday','Residual'),
	('2005-02-11','Lincoln''s Birthday','Observed'),
	('2005-02-12','Lincoln''s Birthday','Actual'),
	('2005-02-14','Lincoln''s Birthday','Residual'),
	('2005-02-18','Washington''s Birthday','Residual'),
	('2005-02-21','Washington''s Birthday','Actual'),
	('2005-02-22','Washington''s Birthday','Residual'),
	('2005-03-24','Good Friday','Residual'),
	('2005-03-25','Good Friday','Actual'),
	('2005-03-28','Good Friday','Residual'),
	('2005-03-30','Cesar Chavez Day','Residual'),
	('2005-03-31','Cesar Chavez Day','Actual'),
	('2005-04-01','Cesar Chavez Day','Residual'),
	('2005-05-27','Memorial Day','Residual'),
	('2005-05-30','Memorial Day','Actual'),
	('2005-05-31','Memorial Day','Residual'),
	('2005-07-01','Independence Day','Residual'),
	('2005-07-04','Independence Day','Actual'),
	('2005-07-05','Independence Day','Residual'),
	('2005-09-02','Labor Day','Residual'),
	('2005-09-05','Labor Day','Actual'),
	('2005-09-06','Labor Day','Residual'),
	('2005-10-07','Columbus Day','Residual'),
	('2005-10-10','Columbus Day','Actual'),
	('2005-10-11','Columbus Day','Residual'),
	('2005-11-10','Veterans Day','Residual'),
	('2005-11-11','Veterans Day','Actual'),
	('2005-11-14','Veterans Day','Residual'),
	('2005-11-18','Thanksgiving','Residual'),
	('2005-11-21','Thanksgiving','Residual'),
	('2005-11-22','Thanksgiving','Residual'),
	('2005-11-23','Thanksgiving','Residual'),
	('2005-11-24','Thanksgiving','Actual'),
	('2005-11-25','Day After Thanksgiving','Actual'),
	('2005-11-28','Day After Thanksgiving','Residual'),
	('2005-12-16','Christmas Eve','Residual'),
	('2005-12-19','Christmas Eve','Residual'),
	('2005-12-20','Christmas Eve','Residual'),
	('2005-12-21','Christmas Eve','Residual'),
	('2005-12-22','Christmas Eve','Residual'),
	('2005-12-23','Christmas Eve','Residual'),
	('2005-12-24','Christmas Eve','Actual'),
	('2005-12-25','Christmas','Actual'),
	('2005-12-26','Christmas','Residual'),
	('2005-12-27','Christmas','Residual'),
	('2005-12-28','Christmas','Residual'),
	('2005-12-29','Christmas','Residual'),
	('2005-12-30','New Years','Residual'),
	('2006-01-01','New Years','Actual'),
	('2006-01-02','New Years','Observed'),
	('2006-01-03','New Years','Residual'),
	('2006-01-13','Martin Luther King Jr. Day','Residual'),
	('2006-01-16','Martin Luther King Jr. Day','Actual'),
	('2006-01-17','Martin Luther King Jr. Day','Residual'),
	('2006-02-10','Lincoln''s Birthday','Residual'),
	('2006-02-12','Lincoln''s Birthday','Actual'),
	('2006-02-13','Lincoln''s Birthday','Observed'),
	('2006-02-14','Lincoln''s Birthday','Residual'),
	('2006-02-17','Washington''s Birthday','Residual'),
	('2006-02-20','Washington''s Birthday','Actual'),
	('2006-02-21','Washington''s Birthday','Residual'),
	('2006-03-30','Cesar Chavez Day','Residual'),
	('2006-03-31','Cesar Chavez Day','Actual'),
	('2006-04-03','Cesar Chavez Day','Residual'),
	('2006-04-13','Good Friday','Residual'),
	('2006-04-14','Good Friday','Actual'),
	('2006-04-17','Good Friday','Residual'),
	('2006-05-26','Memorial Day','Residual'),
	('2006-05-29','Memorial Day','Actual'),
	('2006-05-30','Memorial Day','Residual'),
	('2006-07-03','Independence Day','Residual'),
	('2006-07-04','Independence Day','Actual'),
	('2006-07-05','Independence Day','Residual'),
	('2006-09-01','Labor Day','Residual'),
	('2006-09-04','Labor Day','Actual'),
	('2006-09-05','Labor Day','Residual'),
	('2006-10-06','Columbus Day','Residual'),
	('2006-10-09','Columbus Day','Actual'),
	('2006-10-10','Columbus Day','Residual'),
	('2006-11-09','Veterans Day','Residual'),
	('2006-11-10','Veterans Day','Observed'),
	('2006-11-11','Veterans Day','Actual'),
	('2006-11-13','Veterans Day','Residual'),
	('2006-11-17','Thanksgiving','Residual'),
	('2006-11-20','Thanksgiving','Residual'),
	('2006-11-21','Thanksgiving','Residual'),
	('2006-11-22','Thanksgiving','Residual'),
	('2006-11-23','Thanksgiving','Actual'),
	('2006-11-24','Day After Thanksgiving','Actual'),
	('2006-11-27','Day After Thanksgiving','Residual'),
	('2006-12-15','Christmas Eve','Residual'),
	('2006-12-18','Christmas Eve','Residual'),
	('2006-12-19','Christmas Eve','Residual'),
	('2006-12-20','Christmas Eve','Residual'),
	('2006-12-21','Christmas Eve','Residual'),
	('2006-12-22','Christmas Eve','Residual'),
	('2006-12-24','Christmas Eve','Actual'),
	('2006-12-25','Christmas','Actual'),
	('2006-12-26','Christmas','Residual'),
	('2006-12-27','Christmas','Residual'),
	('2006-12-28','Christmas','Residual'),
	('2006-12-29','Christmas','Residual'),
	('2007-01-01','New Years','Actual'),
	('2007-01-02','New Years','Observed'),
	('2007-01-12','Martin Luther King Jr. Day','Residual'),
	('2007-01-15','Martin Luther King Jr. Day','Actual'),
	('2007-01-16','Martin Luther King Jr. Day','Residual'),
	('2007-02-09','Lincoln''s Birthday','Residual'),
	('2007-02-12','Lincoln''s Birthday','Actual'),
	('2007-02-13','Lincoln''s Birthday','Residual'),
	('2007-02-16','Washington''s Birthday','Residual'),
	('2007-02-19','Washington''s Birthday','Actual'),
	('2007-02-20','Washington''s Birthday','Residual'),
	('2007-03-29','Cesar Chavez Day','Residual'),
	('2007-03-30','Cesar Chavez Day','Observed'),
	('2007-03-31','Cesar Chavez Day','Actual'),
	('2007-04-02','Cesar Chavez Day','Residual'),
	('2007-04-05','Good Friday','Residual'),
	('2007-04-06','Good Friday','Actual'),
	('2007-04-09','Good Friday','Residual'),
	('2007-05-25','Memorial Day','Residual'),
	('2007-05-28','Memorial Day','Actual'),
	('2007-05-29','Memorial Day','Residual'),
	('2007-07-03','Independence Day','Residual'),
	('2007-07-04','Independence Day','Actual'),
	('2007-07-05','Independence Day','Residual'),
	('2007-08-30','Labor Day','Residual'),
	('2007-09-03','Labor Day','Actual'),
	('2007-09-04','Labor Day','Residual'),
	('2007-10-05','Columbus Day','Residual'),
	('2007-10-08','Columbus Day','Actual'),
	('2007-10-09','Columbus Day','Residual'),
	('2007-11-09','Veterans Day','Residual'),
	('2007-11-11','Veterans Day','Actual'),
	('2007-11-12','Veterans Day','Observed'),
	('2007-11-13','Veterans Day','Residual'),
	('2007-11-16','Thanksgiving','Residual'),
	('2007-11-19','Thanksgiving','Residual'),
	('2007-11-20','Thanksgiving','Residual'),
	('2007-11-21','Thanksgiving','Residual'),
	('2007-11-22','Thanksgiving','Actual'),
	('2007-11-23','Day After Thanksgiving','Actual'),
	('2007-11-26','Day After Thanksgiving','Residual'),
	('2007-12-14','Christmas Eve','Residual'),
	('2007-12-17','Christmas Eve','Residual'),
	('2007-12-18','Christmas Eve','Residual'),
	('2007-12-19','Christmas Eve','Residual'),
	('2007-12-20','Christmas Eve','Residual'),
	('2007-12-21','Christmas Eve','Residual'),
	('2007-12-24','Christmas Eve','Actual'),
	('2007-12-25','Christmas','Actual'),
	('2007-12-26','Christmas','Residual'),
	('2007-12-27','Christmas','Residual'),
	('2007-12-28','Christmas','Residual'),
	('2007-12-31','New Years','Residual'),
	('2008-01-01','New Years','Actual'),
	('2008-01-02','New Years','Observed'),
	('2008-01-18','Martin Luther King Jr. Day','Residual'),
	('2008-01-21','Martin Luther King Jr. Day','Actual'),
	('2008-01-22','Martin Luther King Jr. Day','Residual'),
	('2008-02-11','Lincoln''s Birthday','Residual'),
	('2008-02-12','Lincoln''s Birthday','Actual'),
	('2008-02-13','Lincoln''s Birthday','Residual'),
	('2008-02-15','Washington''s Birthday','Residual'),
	('2008-02-18','Washington''s Birthday','Actual'),
	('2008-02-19','Washington''s Birthday','Residual'),
	('2008-03-20','Good Friday','Residual'),
	('2008-03-21','Good Friday','Actual'),
	('2008-03-24','Good Friday','Residual'),
	('2008-03-28','Cesar Chavez Day','Residual'),
	('2008-03-31','Cesar Chavez Day','Actual'),
	('2008-04-01','Cesar Chavez Day','Residual'),
	('2008-05-23','Memorial Day','Residual'),
	('2008-05-26','Memorial Day','Actual'),
	('2008-05-27','Memorial Day','Residual'),
	('2008-07-03','Independence Day','Residual'),
	('2008-07-04','Independence Day','Actual'),
	('2008-07-07','Independence Day','Residual'),
	('2008-08-28','Labor Day','Residual'),
	('2008-09-01','Labor Day','Actual'),
	('2008-09-02','Labor Day','Residual'),
	('2008-10-10','Columbus Day','Residual'),
	('2008-10-13','Columbus Day','Actual'),
	('2008-10-14','Columbus Day','Residual'),
	('2008-11-10','Veterans Day','Residual'),
	('2008-11-11','Veterans Day','Actual'),
	('2008-11-12','Veterans Day','Residual'),
	('2008-11-21','Thanksgiving','Residual'),
	('2008-11-24','Thanksgiving','Residual'),
	('2008-11-25','Thanksgiving','Residual'),
	('2008-11-26','Thanksgiving','Residual'),
	('2008-11-27','Thanksgiving','Actual'),
	('2008-11-28','Day After Thanksgiving','Actual'),
	('2008-12-01','Day After Thanksgiving','Residual'),
	('2008-12-19','Christmas Eve','Residual'),
	('2008-12-22','Christmas Eve','Residual'),
	('2008-12-23','Christmas Eve','Residual'),
	('2008-12-24','Christmas Eve','Actual'),
	('2008-12-25','Christmas','Actual'),
	('2008-12-26','Christmas','Residual'),
	('2008-12-29','Christmas','Residual'),
	('2008-12-30','New Years','Residual'),
	('2008-12-31','New Years','Residual'),
	('2009-01-01','New Years','Actual'),
	('2009-01-02','New Years','Observed'),
	('2009-01-16','Martin Luther King Jr. Day','Residual'),
	('2009-01-19','Martin Luther King Jr. Day','Actual'),
	('2009-01-20','Martin Luther King Jr. Day','Residual'),
	('2009-02-11','Lincoln''s Birthday','Residual'),
	('2009-02-12','Lincoln''s Birthday','Actual'),
	('2009-02-13','Lincoln''s Birthday','Residual'),
	('2009-02-13','Washington''s Birthday','Residual'),
	('2009-02-16','Washington''s Birthday','Actual'),
	('2009-02-17','Washington''s Birthday','Residual'),
	('2009-03-30','Cesar Chavez Day','Residual'),
	('2009-03-31','Cesar Chavez Day','Actual'),
	('2009-04-01','Cesar Chavez Day','Residual'),
	('2009-04-09','Good Friday','Residual'),
	('2009-04-10','Good Friday','Actual'),
	('2009-04-13','Good Friday','Residual'),
	('2009-05-22','Memorial Day','Residual'),
	('2009-05-25','Memorial Day','Actual'),
	('2009-05-26','Memorial Day','Residual'),
	('2009-07-02','Independence Day','Residual'),
	('2009-07-03','Independence Day','Observed'),
	('2009-07-04','Independence Day','Actual'),
	('2009-07-06','Independence Day','Residual'),
	('2009-09-04','Labor Day','Residual'),
	('2009-09-07','Labor Day','Actual'),
	('2009-09-08','Labor Day','Residual'),
	('2009-10-09','Columbus Day','Residual'),
	('2009-10-12','Columbus Day','Actual'),
	('2009-10-13','Columbus Day','Residual'),
	('2009-11-10','Veterans Day','Residual'),
	('2009-11-11','Veterans Day','Actual'),
	('2009-11-12','Veterans Day','Residual'),
	('2009-11-20','Thanksgiving','Residual'),
	('2009-11-23','Thanksgiving','Residual'),
	('2009-11-24','Thanksgiving','Residual'),
	('2009-11-25','Thanksgiving','Residual'),
	('2009-11-26','Thanksgiving','Actual'),
	('2009-11-27','Day After Thanksgiving','Actual'),
	('2009-11-30','Day After Thanksgiving','Residual'),
	('2009-12-18','Christmas Eve','Residual'),
	('2009-12-21','Christmas Eve','Residual'),
	('2009-12-22','Christmas Eve','Residual'),
	('2009-12-23','Christmas Eve','Residual'),
	('2009-12-24','Christmas Eve','Actual'),
	('2009-12-25','Christmas','Actual'),
	('2009-12-28','Christmas','Residual'),
	('2009-12-29','Christmas','Residual'),
	('2009-12-30','New Years','Residual'),
	('2009-12-31','New Years','Residual')
	INSERT INTO [pems].[holiday] VALUES
	('2010-01-01','New Years','Actual'),
	('2010-01-04','New Years','Residual'),
	('2010-01-15','Martin Luther King Jr. Day','Residual'),
	('2010-01-18','Martin Luther King Jr. Day','Actual'),
	('2010-01-19','Martin Luther King Jr. Day','Residual'),
	('2010-02-12','Washington''s Birthday','Residual'),
	('2010-02-15','Washington''s Birthday','Actual'),
	('2010-02-16','Washington''s Birthday','Residual'),
	('2010-03-30','Cesar Chavez Day','Residual'),
	('2010-03-31','Cesar Chavez Day','Actual'),
	('2010-04-01','Cesar Chavez Day','Residual'),
	('2010-04-01','Good Friday','Residual'),
	('2010-04-02','Good Friday','Actual'),
	('2010-04-05','Good Friday','Residual'),
	('2010-05-28','Memorial Day','Residual'),
	('2010-05-31','Memorial Day','Actual'),
	('2010-06-01','Memorial Day','Residual'),
	('2010-07-02','Independence Day','Residual'),
	('2010-07-04','Independence Day','Actual'),
	('2010-07-05','Independence Day','Observed'),
	('2010-07-06','Independence Day','Residual'),
	('2010-09-03','Labor Day','Residual'),
	('2010-09-06','Labor Day','Actual'),
	('2010-09-07','Labor Day','Residual'),
	('2010-10-08','Columbus Day','Residual'),
	('2010-10-11','Columbus Day','Actual'),
	('2010-10-12','Columbus Day','Residual'),
	('2010-11-10','Veterans Day','Residual'),
	('2010-11-11','Veterans Day','Actual'),
	('2010-11-12','Veterans Day','Residual'),
	('2010-11-19','Thanksgiving','Residual'),
	('2010-11-22','Thanksgiving','Residual'),
	('2010-11-23','Thanksgiving','Residual'),
	('2010-11-24','Thanksgiving','Residual'),
	('2010-11-25','Thanksgiving','Actual'),
	('2010-11-26','Day After Thanksgiving','Actual'),
	('2010-11-29','Day After Thanksgiving','Residual'),
	('2010-12-17','Christmas Eve','Residual'),
	('2010-12-20','Christmas Eve','Residual'),
	('2010-12-21','Christmas Eve','Residual'),
	('2010-12-22','Christmas Eve','Residual'),
	('2010-12-23','Christmas Eve','Residual'),
	('2010-12-24','Christmas Eve','Actual'),
	('2010-12-25','Christmas','Actual'),
	('2010-12-27','Christmas','Residual'),
	('2010-12-28','Christmas','Residual'),
	('2010-12-29','Christmas','Residual'),
	('2010-12-30','New Years','Residual'),
	('2010-12-31','New Years','Observed'),
	('2011-01-01','New Years','Actual'),
	('2011-01-03','New Years','Residual'),
	('2011-01-14','Martin Luther King Jr. Day','Residual'),
	('2011-01-17','Martin Luther King Jr. Day','Actual'),
	('2011-01-18','Martin Luther King Jr. Day','Residual'),
	('2011-02-18','Washington''s Birthday','Residual'),
	('2011-02-21','Washington''s Birthday','Actual'),
	('2011-02-22','Washington''s Birthday','Residual'),
	('2011-03-30','Cesar Chavez Day','Residual'),
	('2011-03-31','Cesar Chavez Day','Actual'),
	('2011-04-01','Cesar Chavez Day','Residual'),
	('2011-04-21','Good Friday','Residual'),
	('2011-04-22','Good Friday','Actual'),
	('2011-04-25','Good Friday','Residual'),
	('2011-05-20','Memorial Day','Residual'),
	('2011-05-23','Memorial Day','Actual'),
	('2011-05-24','Memorial Day','Residual'),
	('2011-07-01','Independence Day','Residual'),
	('2011-07-04','Independence Day','Actual'),
	('2011-07-05','Independence Day','Residual'),
	('2011-09-02','Labor Day','Residual'),
	('2011-09-05','Labor Day','Actual'),
	('2011-09-06','Labor Day','Residual'),
	('2011-10-07','Columbus Day','Residual'),
	('2011-10-10','Columbus Day','Actual'),
	('2011-10-11','Columbus Day','Residual'),
	('2011-11-10','Veterans Day','Residual'),
	('2011-11-11','Veterans Day','Actual'),
	('2011-11-14','Veterans Day','Residual'),
	('2011-11-18','Thanksgiving','Residual'),
	('2011-11-21','Thanksgiving','Residual'),
	('2011-11-22','Thanksgiving','Residual'),
	('2011-11-23','Thanksgiving','Residual'),
	('2011-11-24','Thanksgiving','Actual'),
	('2011-11-25','Day After Thanksgiving','Actual'),
	('2011-11-28','Day After Thanksgiving','Residual'),
	('2011-12-16','Christmas Eve','Residual'),
	('2011-12-19','Christmas Eve','Residual'),
	('2011-12-20','Christmas Eve','Residual'),
	('2011-12-21','Christmas Eve','Residual'),
	('2011-12-22','Christmas Eve','Residual'),
	('2011-12-23','Christmas Eve','Residual'),
	('2011-12-24','Christmas Eve','Actual'),
	('2011-12-25','Christmas','Actual'),
	('2011-12-26','Christmas','Residual'),
	('2011-12-27','Christmas','Residual'),
	('2011-12-28','Christmas','Residual'),
	('2011-12-29','Christmas','Residual'),
	('2011-12-30','New Years','Residual'),
	('2012-01-01','New Years','Actual'),
	('2012-01-02','New Years','Observed'),
	('2012-01-03','New Years','Residual'),
	('2012-01-13','Martin Luther King Jr. Day','Residual'),
	('2012-01-16','Martin Luther King Jr. Day','Actual'),
	('2012-01-17','Martin Luther King Jr. Day','Residual'),
	('2012-02-17','Washington''s Birthday','Residual'),
	('2012-02-20','Washington''s Birthday','Actual'),
	('2012-02-21','Washington''s Birthday','Residual'),
	('2012-03-29','Cesar Chavez Day','Residual'),
	('2012-03-30','Cesar Chavez Day','Observed'),
	('2012-03-31','Cesar Chavez Day','Actual'),
	('2012-04-02','Cesar Chavez Day','Residual'),
	('2012-04-05','Good Friday','Residual'),
	('2012-04-06','Good Friday','Actual'),
	('2012-04-09','Good Friday','Residual'),
	('2012-05-25','Memorial Day','Residual'),
	('2012-05-28','Memorial Day','Actual'),
	('2012-05-29','Memorial Day','Residual'),
	('2012-07-03','Independence Day','Residual'),
	('2012-07-04','Independence Day','Actual'),
	('2012-07-05','Independence Day','Residual'),
	('2012-08-30','Labor Day','Residual'),
	('2012-09-03','Labor Day','Actual'),
	('2012-09-04','Labor Day','Residual'),
	('2012-10-05','Columbus Day','Residual'),
	('2012-10-08','Columbus Day','Actual'),
	('2012-10-09','Columbus Day','Residual'),
	('2012-11-09','Veterans Day','Residual'),
	('2012-11-11','Veterans Day','Actual'),
	('2012-11-12','Veterans Day','Observed'),
	('2012-11-13','Veterans Day','Residual'),
	('2012-11-16','Thanksgiving','Residual'),
	('2012-11-19','Thanksgiving','Residual'),
	('2012-11-20','Thanksgiving','Residual'),
	('2012-11-21','Thanksgiving','Residual'),
	('2012-11-22','Thanksgiving','Actual'),
	('2012-11-23','Day After Thanksgiving','Actual'),
	('2012-11-26','Day After Thanksgiving','Residual'),
	('2012-12-14','Christmas Eve','Residual'),
	('2012-12-17','Christmas Eve','Residual'),
	('2012-12-18','Christmas Eve','Residual'),
	('2012-12-19','Christmas Eve','Residual'),
	('2012-12-20','Christmas Eve','Residual'),
	('2012-12-21','Christmas Eve','Residual'),
	('2012-12-24','Christmas Eve','Actual'),
	('2012-12-25','Christmas','Actual'),
	('2012-12-26','Christmas','Residual'),
	('2012-12-27','Christmas','Residual'),
	('2012-12-28','Christmas','Residual'),
	('2012-12-31','New Years','Residual'),
	('2013-01-01','New Years','Actual'),
	('2013-01-02','New Years','Residual'),
	('2013-01-18','Martin Luther King Jr. Day','Residual'),
	('2013-01-21','Martin Luther King Jr. Day','Actual'),
	('2013-01-22','Martin Luther King Jr. Day','Residual'),
	('2013-02-15','Washington''s Birthday','Residual'),
	('2013-02-18','Washington''s Birthday','Actual'),
	('2013-02-19','Washington''s Birthday','Residual'),
	('2013-03-28','Good Friday','Residual'),
	('2013-03-29','Cesar Chavez Day','Residual'),
	('2013-03-29','Good Friday','Actual'),
	('2013-03-31','Cesar Chavez Day','Actual'),
	('2013-04-01','Cesar Chavez Day','Observed'),
	('2013-04-01','Good Friday','Residual'),
	('2013-04-02','Cesar Chavez Day','Residual'),
	('2013-05-24','Memorial Day','Residual'),
	('2013-05-27','Memorial Day','Actual'),
	('2013-05-28','Memorial Day','Residual'),
	('2013-07-03','Independence Day','Residual'),
	('2013-07-04','Independence Day','Actual'),
	('2013-07-05','Independence Day','Residual'),
	('2013-08-29','Labor Day','Residual'),
	('2013-09-02','Labor Day','Actual'),
	('2013-09-03','Labor Day','Residual'),
	('2013-10-11','Columbus Day','Residual'),
	('2013-10-14','Columbus Day','Actual'),
	('2013-10-15','Columbus Day','Residual'),
	('2013-11-08','Veterans Day','Residual'),
	('2013-11-11','Veterans Day','Actual'),
	('2013-11-12','Veterans Day','Residual'),
	('2013-11-22','Thanksgiving','Residual'),
	('2013-11-25','Thanksgiving','Residual'),
	('2013-11-26','Thanksgiving','Residual'),
	('2013-11-27','Thanksgiving','Residual'),
	('2013-11-28','Thanksgiving','Actual'),
	('2013-11-29','Day After Thanksgiving','Actual'),
	('2013-12-02','Day After Thanksgiving','Residual'),
	('2013-12-13','Christmas Eve','Residual'),
	('2013-12-16','Christmas Eve','Residual'),
	('2013-12-17','Christmas Eve','Residual'),
	('2013-12-18','Christmas Eve','Residual'),
	('2013-12-19','Christmas Eve','Residual'),
	('2013-12-20','Christmas Eve','Residual'),
	('2013-12-23','Christmas Eve','Residual'),
	('2013-12-24','Christmas Eve','Actual'),
	('2013-12-25','Christmas','Actual'),
	('2013-12-26','Christmas','Residual'),
	('2013-12-27','Christmas','Residual'),
	('2013-12-30','New Years','Residual'),
	('2013-12-31','New Years','Residual'),
	('2014-01-01','New Years','Actual'),
	('2014-01-02','New Years','Residual'),
	('2014-01-17','Martin Luther King Jr. Day','Residual'),
	('2014-01-20','Martin Luther King Jr. Day','Actual'),
	('2014-01-21','Martin Luther King Jr. Day','Residual'),
	('2014-02-14','Washington''s Birthday','Residual'),
	('2014-02-17','Washington''s Birthday','Actual'),
	('2014-02-18','Washington''s Birthday','Residual'),
	('2014-03-28','Cesar Chavez Day','Residual'),
	('2014-03-31','Cesar Chavez Day','Actual'),
	('2014-04-01','Cesar Chavez Day','Residual'),
	('2014-04-17','Good Friday','Residual'),
	('2014-04-18','Good Friday','Actual'),
	('2014-04-21','Good Friday','Residual'),
	('2014-05-23','Memorial Day','Residual'),
	('2014-05-26','Memorial Day','Actual'),
	('2014-05-27','Memorial Day','Residual'),
	('2014-07-03','Independence Day','Residual'),
	('2014-07-04','Independence Day','Actual'),
	('2014-07-07','Independence Day','Residual'),
	('2014-08-28','Labor Day','Residual'),
	('2014-09-01','Labor Day','Actual'),
	('2014-09-02','Labor Day','Residual'),
	('2014-10-10','Columbus Day','Residual'),
	('2014-10-13','Columbus Day','Actual'),
	('2014-10-14','Columbus Day','Residual'),
	('2014-11-10','Veterans Day','Residual'),
	('2014-11-11','Veterans Day','Actual'),
	('2014-11-12','Veterans Day','Residual'),
	('2014-11-21','Thanksgiving','Residual'),
	('2014-11-24','Thanksgiving','Residual'),
	('2014-11-25','Thanksgiving','Residual'),
	('2014-11-26','Thanksgiving','Residual'),
	('2014-11-27','Thanksgiving','Actual'),
	('2014-11-28','Day After Thanksgiving','Actual'),
	('2014-12-01','Day After Thanksgiving','Residual'),
	('2014-12-19','Christmas Eve','Residual'),
	('2014-12-22','Christmas Eve','Residual'),
	('2014-12-23','Christmas Eve','Residual'),
	('2014-12-24','Christmas Eve','Actual'),
	('2014-12-25','Christmas','Actual'),
	('2014-12-26','Christmas','Residual'),
	('2014-12-29','Christmas','Residual'),
	('2014-12-30','New Years','Residual'),
	('2014-12-31','New Years','Residual'),
	('2015-01-01','New Years','Actual'),
	('2015-01-02','New Years','Residual'),
	('2015-01-16','Martin Luther King Jr. Day','Residual'),
	('2015-01-19','Martin Luther King Jr. Day','Actual'),
	('2015-01-20','Martin Luther King Jr. Day','Residual'),
	('2015-02-13','Washington''s Birthday','Residual'),
	('2015-02-16','Washington''s Birthday','Actual'),
	('2015-02-17','Washington''s Birthday','Residual'),
	('2015-03-30','Cesar Chavez Day','Residual'),
	('2015-03-31','Cesar Chavez Day','Actual'),
	('2015-04-01','Cesar Chavez Day','Residual'),
	('2015-04-02','Good Friday','Residual'),
	('2015-04-03','Good Friday','Actual'),
	('2015-04-06','Good Friday','Residual'),
	('2015-05-22','Memorial Day','Residual'),
	('2015-05-25','Memorial Day','Actual'),
	('2015-05-26','Memorial Day','Residual'),
	('2015-07-02','Independence Day','Residual'),
	('2015-07-03','Independence Day','Observed'),
	('2015-07-04','Independence Day','Actual'),
	('2015-07-06','Independence Day','Residual'),
	('2015-09-04','Labor Day','Residual'),
	('2015-09-07','Labor Day','Actual'),
	('2015-09-08','Labor Day','Residual'),
	('2015-10-09','Columbus Day','Residual'),
	('2015-10-12','Columbus Day','Actual'),
	('2015-10-13','Columbus Day','Residual'),
	('2015-11-10','Veterans Day','Residual'),
	('2015-11-11','Veterans Day','Actual'),
	('2015-11-12','Veterans Day','Residual'),
	('2015-11-20','Thanksgiving','Residual'),
	('2015-11-23','Thanksgiving','Residual'),
	('2015-11-24','Thanksgiving','Residual'),
	('2015-11-25','Thanksgiving','Residual'),
	('2015-11-26','Thanksgiving','Actual'),
	('2015-11-27','Day After Thanksgiving','Actual'),
	('2015-11-30','Day After Thanksgiving','Residual'),
	('2015-12-18','Christmas Eve','Residual'),
	('2015-12-21','Christmas Eve','Residual'),
	('2015-12-22','Christmas Eve','Residual'),
	('2015-12-23','Christmas Eve','Residual'),
	('2015-12-24','Christmas Eve','Actual'),
	('2015-12-25','Christmas','Actual'),
	('2015-12-28','Christmas','Residual'),
	('2015-12-29','Christmas','Residual'),
	('2015-12-30','New Years','Residual'),
	('2015-12-31','New Years','Residual'),
	('2016-01-01','New Years','Actual'),
	('2016-01-04','New Years','Residual'),
	('2016-01-15','Martin Luther King Jr. Day','Residual'),
	('2016-01-18','Martin Luther King Jr. Day','Actual'),
	('2016-01-19','Martin Luther King Jr. Day','Residual'),
	('2016-02-12','Washington''s Birthday','Residual'),
	('2016-02-15','Washington''s Birthday','Actual'),
	('2016-02-16','Washington''s Birthday','Residual'),
	('2016-03-24','Good Friday','Residual'),
	('2016-03-25','Good Friday','Actual'),
	('2016-03-28','Good Friday','Residual'),
	('2016-03-30','Cesar Chavez Day','Residual'),
	('2016-03-31','Cesar Chavez Day','Actual'),
	('2016-04-01','Cesar Chavez Day','Residual'),
	('2016-05-27','Memorial Day','Residual'),
	('2016-05-30','Memorial Day','Actual'),
	('2016-05-31','Memorial Day','Residual'),
	('2016-07-01','Independence Day','Residual'),
	('2016-07-04','Independence Day','Actual'),
	('2016-07-05','Independence Day','Residual'),
	('2016-09-02','Labor Day','Residual'),
	('2016-09-05','Labor Day','Actual'),
	('2016-09-06','Labor Day','Residual'),
	('2016-10-07','Columbus Day','Residual'),
	('2016-10-10','Columbus Day','Actual'),
	('2016-10-11','Columbus Day','Residual'),
	('2016-11-10','Veterans Day','Residual'),
	('2016-11-11','Veterans Day','Actual'),
	('2016-11-14','Veterans Day','Residual'),
	('2016-11-18','Thanksgiving','Residual'),
	('2016-11-21','Thanksgiving','Residual'),
	('2016-11-22','Thanksgiving','Residual'),
	('2016-11-23','Thanksgiving','Residual'),
	('2016-11-24','Thanksgiving','Actual'),
	('2016-11-25','Day After Thanksgiving','Actual'),
	('2016-11-28','Day After Thanksgiving','Residual'),
	('2016-12-16','Christmas Eve','Residual'),
	('2016-12-19','Christmas Eve','Residual'),
	('2016-12-20','Christmas Eve','Residual'),
	('2016-12-21','Christmas Eve','Residual'),
	('2016-12-22','Christmas Eve','Residual'),
	('2016-12-23','Christmas Eve','Residual'),
	('2016-12-24','Christmas Eve','Actual'),
	('2016-12-25','Christmas','Actual'),
	('2016-12-26','Christmas','Residual'),
	('2016-12-27','Christmas','Residual'),
	('2016-12-28','Christmas','Residual'),
	('2016-12-29','Christmas','Residual'),
	('2016-12-30','New Years','Residual'),
	('2017-01-01','New Years','Actual'),
	('2017-01-02','New Years','Observed'),
	('2017-01-03','New Years','Residual'),
	('2017-01-13','Martin Luther King Jr. Day','Residual'),
	('2017-01-16','Martin Luther King Jr. Day','Actual'),
	('2017-01-17','Martin Luther King Jr. Day','Residual'),
	('2017-02-17','Washington''s Birthday','Residual'),
	('2017-02-20','Washington''s Birthday','Actual'),
	('2017-02-21','Washington''s Birthday','Residual'),
	('2017-03-30','Cesar Chavez Day','Residual'),
	('2017-03-31','Cesar Chavez Day','Actual'),
	('2017-04-03','Cesar Chavez Day','Residual'),
	('2017-04-13','Good Friday','Residual'),
	('2017-04-14','Good Friday','Actual'),
	('2017-04-17','Good Friday','Residual'),
	('2017-05-26','Memorial Day','Residual'),
	('2017-05-29','Memorial Day','Actual'),
	('2017-05-30','Memorial Day','Residual'),
	('2017-07-03','Independence Day','Residual'),
	('2017-07-04','Independence Day','Actual'),
	('2017-07-05','Independence Day','Residual'),
	('2017-09-01','Labor Day','Residual'),
	('2017-09-04','Labor Day','Actual'),
	('2017-09-05','Labor Day','Residual'),
	('2017-10-06','Columbus Day','Residual'),
	('2017-10-09','Columbus Day','Actual'),
	('2017-10-10','Columbus Day','Residual'),
	('2017-11-09','Veterans Day','Residual'),
	('2017-11-10','Veterans Day','Observed'),
	('2017-11-11','Veterans Day','Actual'),
	('2017-11-13','Veterans Day','Residual'),
	('2017-11-17','Thanksgiving','Residual'),
	('2017-11-20','Thanksgiving','Residual'),
	('2017-11-21','Thanksgiving','Residual'),
	('2017-11-22','Thanksgiving','Residual'),
	('2017-11-23','Thanksgiving','Actual'),
	('2017-11-24','Day After Thanksgiving','Actual'),
	('2017-11-27','Day After Thanksgiving','Residual'),
	('2017-12-15','Christmas Eve','Residual'),
	('2017-12-18','Christmas Eve','Residual'),
	('2017-12-19','Christmas Eve','Residual'),
	('2017-12-20','Christmas Eve','Residual'),
	('2017-12-21','Christmas Eve','Residual'),
	('2017-12-22','Christmas Eve','Residual'),
	('2017-12-24','Christmas Eve','Actual'),
	('2017-12-25','Christmas','Actual'),
	('2017-12-26','Christmas','Residual'),
	('2017-12-27','Christmas','Residual'),
	('2017-12-28','Christmas','Residual'),
	('2017-12-29','Christmas','Residual'),
	('2018-01-01','New Years','Actual'),
	('2018-01-02','New Years','Residual'),
	('2018-01-12','Martin Luther King Jr. Day','Residual'),
	('2018-01-15','Martin Luther King Jr. Day','Actual'),
	('2018-01-16','Martin Luther King Jr. Day','Residual'),
	('2018-02-16','Washington''s Birthday','Residual'),
	('2018-02-19','Washington''s Birthday','Actual'),
	('2018-02-20','Washington''s Birthday','Residual'),
	('2018-03-29','Cesar Chavez Day','Residual'),
	('2018-03-29','Good Friday','Residual'),
	('2018-03-30','Cesar Chavez Day','Observed'),
	('2018-03-30','Good Friday','Actual'),
	('2018-03-31','Cesar Chavez Day','Actual'),
	('2018-04-02','Cesar Chavez Day','Residual'),
	('2018-04-02','Good Friday','Residual'),
	('2018-05-25','Memorial Day','Residual'),
	('2018-05-28','Memorial Day','Actual'),
	('2018-05-29','Memorial Day','Residual'),
	('2018-07-03','Independence Day','Residual'),
	('2018-07-04','Independence Day','Actual'),
	('2018-07-05','Independence Day','Residual'),
	('2018-08-30','Labor Day','Residual'),
	('2018-09-03','Labor Day','Actual'),
	('2018-09-04','Labor Day','Residual'),
	('2018-10-05','Columbus Day','Residual'),
	('2018-10-08','Columbus Day','Actual'),
	('2018-10-09','Columbus Day','Residual'),
	('2018-11-09','Veterans Day','Residual'),
	('2018-11-11','Veterans Day','Actual'),
	('2018-11-12','Veterans Day','Observed'),
	('2018-11-13','Veterans Day','Residual'),
	('2018-11-16','Thanksgiving','Residual'),
	('2018-11-19','Thanksgiving','Residual'),
	('2018-11-20','Thanksgiving','Residual'),
	('2018-11-21','Thanksgiving','Residual'),
	('2018-11-22','Thanksgiving','Actual'),
	('2018-11-23','Day After Thanksgiving','Actual'),
	('2018-11-26','Day After Thanksgiving','Residual'),
	('2018-12-14','Christmas Eve','Residual'),
	('2018-12-17','Christmas Eve','Residual'),
	('2018-12-18','Christmas Eve','Residual'),
	('2018-12-19','Christmas Eve','Residual'),
	('2018-12-20','Christmas Eve','Residual'),
	('2018-12-21','Christmas Eve','Residual'),
	('2018-12-24','Christmas Eve','Actual'),
	('2018-12-25','Christmas','Actual'),
	('2018-12-26','Christmas','Residual'),
	('2018-12-27','Christmas','Residual'),
	('2018-12-28','Christmas','Residual'),
	('2018-12-31','New Years','Residual'),
	('2019-01-01','New Years','Actual'),
	('2019-01-02','New Years','Residual'),
	('2019-01-18','Martin Luther King Jr. Day','Residual'),
	('2019-01-21','Martin Luther King Jr. Day','Actual'),
	('2019-01-22','Martin Luther King Jr. Day','Residual'),
	('2019-02-15','Washington''s Birthday','Residual'),
	('2019-02-18','Washington''s Birthday','Actual'),
	('2019-02-19','Washington''s Birthday','Residual'),
	('2019-03-29','Cesar Chavez Day','Residual'),
	('2019-03-31','Cesar Chavez Day','Actual'),
	('2019-04-01','Cesar Chavez Day','Observed'),
	('2019-04-02','Cesar Chavez Day','Residual'),
	('2019-04-18','Good Friday','Residual'),
	('2019-04-19','Good Friday','Actual'),
	('2019-04-22','Good Friday','Residual'),
	('2019-05-24','Memorial Day','Residual'),
	('2019-05-27','Memorial Day','Actual'),
	('2019-05-28','Memorial Day','Residual'),
	('2019-07-03','Independence Day','Residual'),
	('2019-07-04','Independence Day','Actual'),
	('2019-07-05','Independence Day','Residual'),
	('2019-08-29','Labor Day','Residual'),
	('2019-09-02','Labor Day','Actual'),
	('2019-09-03','Labor Day','Residual'),
	('2019-10-11','Columbus Day','Residual'),
	('2019-10-14','Columbus Day','Actual'),
	('2019-10-15','Columbus Day','Residual'),
	('2019-11-08','Veterans Day','Residual'),
	('2019-11-11','Veterans Day','Actual'),
	('2019-11-12','Veterans Day','Residual'),
	('2019-11-22','Thanksgiving','Residual'),
	('2019-11-25','Thanksgiving','Residual'),
	('2019-11-26','Thanksgiving','Residual'),
	('2019-11-27','Thanksgiving','Residual'),
	('2019-11-28','Thanksgiving','Actual'),
	('2019-11-29','Day After Thanksgiving','Actual'),
	('2019-12-02','Day After Thanksgiving','Residual'),
	('2019-12-13','Christmas Eve','Residual'),
	('2019-12-16','Christmas Eve','Residual'),
	('2019-12-17','Christmas Eve','Residual'),
	('2019-12-18','Christmas Eve','Residual'),
	('2019-12-19','Christmas Eve','Residual'),
	('2019-12-20','Christmas Eve','Residual'),
	('2019-12-24','Christmas Eve','Actual'),
	('2019-12-25','Christmas','Actual'),
	('2019-12-26','Christmas','Residual'),
	('2019-12-27','Christmas','Residual'),
	('2019-12-30','New Years','Residual'),
	('2019-12-31','New Years','Residual'),
	('2020-01-01','New Years','Actual'),
	('2020-01-02','New Years','Residual'),
	('2020-01-17','Martin Luther King Jr. Day','Residual'),
	('2020-01-20','Martin Luther King Jr. Day','Actual'),
	('2020-01-21','Martin Luther King Jr. Day','Residual'),
	('2020-02-14','Washington''s Birthday','Residual'),
	('2020-02-17','Washington''s Birthday','Actual'),
	('2020-02-18','Washington''s Birthday','Residual'),
	('2020-03-30','Cesar Chavez Day','Residual'),
	('2020-03-31','Cesar Chavez Day','Actual'),
	('2020-04-01','Cesar Chavez Day','Residual'),
	('2020-04-09','Good Friday','Residual'),
	('2020-04-10','Good Friday','Actual'),
	('2020-04-13','Good Friday','Residual'),
	('2020-05-22','Memorial Day','Residual'),
	('2020-05-25','Memorial Day','Actual'),
	('2020-05-26','Memorial Day','Residual'),
	('2020-07-02','Independence Day','Residual'),
	('2020-07-03','Independence Day','Observed'),
	('2020-07-04','Independence Day','Actual'),
	('2020-07-06','Good Friday','Residual'),
	('2020-09-04','Labor Day','Residual'),
	('2020-09-07','Labor Day','Actual'),
	('2020-09-08','Labor Day','Residual'),
	('2020-10-09','Columbus Day','Residual'),
	('2020-10-12','Columbus Day','Actual'),
	('2020-10-13','Columbus Day','Residual'),
	('2020-11-10','Veterans Day','Residual'),
	('2020-11-11','Veterans Day','Actual'),
	('2020-11-12','Veterans Day','Residual'),
	('2020-11-20','Thanksgiving','Residual'),
	('2020-11-23','Thanksgiving','Residual'),
	('2020-11-24','Thanksgiving','Residual'),
	('2020-11-25','Thanksgiving','Residual'),
	('2020-11-26','Thanksgiving','Actual'),
	('2020-11-27','Day After Thanksgiving','Actual'),
	('2020-11-30','Day After Thanksgiving','Residual'),
	('2020-12-18','Christmas Eve','Residual'),
	('2020-12-21','Christmas Eve','Residual'),
	('2020-12-22','Christmas Eve','Residual'),
	('2020-12-23','Christmas Eve','Residual'),
	('2020-12-24','Christmas Eve','Actual'),
	('2020-12-25','Christmas','Actual'),
	('2020-12-28','Christmas','Residual'),
	('2020-12-29','Christmas','Residual'),
	('2020-12-30','New Years','Residual'),
	('2020-12-31','New Years','Residual'),
	('2021-01-01','New Years','Actual'),
	('2021-01-02','New Years','Residual'),
	('2021-01-15','Martin Luther King Jr. Day','Residual'),
	('2021-01-18','Martin Luther King Jr. Day','Actual'),
	('2021-01-19','Martin Luther King Jr. Day','Residual'),
	('2021-02-13','Washington''s Birthday','Residual'),
	('2021-02-15','Washington''s Birthday','Actual'),
	('2021-02-16','Washington''s Birthday','Residual'),
	('2021-03-30','Cesar Chavez Day','Residual'),
	('2021-03-31','Cesar Chavez Day','Actual'),
	('2021-04-01','Cesar Chavez Day','Residual'),
	('2021-04-02','Good Friday','Actual'),
	('2021-04-05','Good Friday','Residual'),
	('2021-05-28','Memorial Day','Residual'),
	('2021-05-31','Memorial Day','Actual'),
	('2021-06-01','Memorial Day','Residual'),
	('2021-07-02','Independence Day','Residual'),
	('2021-07-04','Independence Day','Actual'),
	('2021-07-05','Independence Day','Observed'),
	('2021-07-06','Independence Day','Residual'),
	('2021-09-03','Labor Day','Residual'),
	('2021-09-06','Labor Day','Actual'),
	('2021-09-07','Labor Day','Residual'),
	('2021-10-08','Columbus Day','Residual'),
	('2021-10-11','Columbus Day','Actual'),
	('2021-10-12','Columbus Day','Residual'),
	('2021-11-10','Veterans Day','Residual'),
	('2021-11-11','Veterans Day','Actual'),
	('2021-11-12','Veterans Day','Residual'),
	('2021-11-19','Thanksgiving','Residual'),
	('2021-11-23','Thanksgiving','Residual'),
	('2021-11-24','Thanksgiving','Residual'),
	('2021-11-25','Thanksgiving','Actual'),
	('2021-11-26','Day After Thanksgiving','Actual'),
	('2021-11-29','Day After Thanksgiving','Residual'),
	('2021-12-17','Christmas Eve','Residual'),
	('2021-12-21','Christmas Eve','Residual'),
	('2021-12-22','Christmas Eve','Residual'),
	('2021-12-23','Christmas Eve','Residual'),
	('2021-12-24','Christmas Eve','Actual'),
	('2021-12-25','Christmas','Actual'),
	('2021-12-27','Christmas','Residual'),
	('2021-12-28','Christmas','Residual'),
	('2021-12-30','New Years','Residual'),
	('2021-12-31','New Years','Residual'),
	('2022-01-01','New Years','Actual'),
	('2022-01-03','New Years','Residual'),
	('2022-01-14','Martin Luther King Jr. Day','Residual'),
	('2022-01-17','Martin Luther King Jr. Day','Actual'),
	('2022-01-18','Martin Luther King Jr. Day','Residual'),
	('2022-02-18','Washington''s Birthday','Residual'),
	('2022-02-21','Washington''s Birthday','Actual'),
	('2022-02-22','Washington''s Birthday','Residual'),
	('2022-03-30','Cesar Chavez Day','Residual'),
	('2022-03-31','Cesar Chavez Day','Actual'),
	('2022-04-01','Cesar Chavez Day','Residual'),
	('2022-04-14','Good Friday','Residual'),
	('2022-04-15','Good Friday','Actual'),
	('2022-04-18','Good Friday','Residual'),
	('2022-05-27','Memorial Day','Residual'),
	('2022-05-30','Memorial Day','Actual'),
	('2022-05-31','Memorial Day','Residual'),
	('2022-07-01','Independence Day','Residual'),
	('2022-07-04','Independence Day','Actual'),
	('2022-07-05','Independence Day','Residual'),
	('2022-07-06','Independence Day','Residual'),
	('2022-09-02','Labor Day','Residual'),
	('2022-09-05','Labor Day','Actual'),
	('2022-09-06','Labor Day','Residual'),
	('2022-10-07','Columbus Day','Residual'),
	('2022-10-10','Columbus Day','Actual'),
	('2022-10-11','Columbus Day','Residual'),
	('2022-11-10','Veterans Day','Residual'),
	('2022-11-11','Veterans Day','Actual'),
	('2022-11-12','Veterans Day','Residual'),
	('2022-11-22','Thanksgiving','Residual'),
	('2022-11-23','Thanksgiving','Residual'),
	('2022-11-24','Thanksgiving','Actual'),
	('2022-11-25','Day After Thanksgiving','Actual'),
	('2022-11-28','Day After Thanksgiving','Residual'),
	('2022-12-20','Christmas Eve','Residual'),
	('2022-12-21','Christmas Eve','Residual'),
	('2022-12-22','Christmas Eve','Residual'),
	('2022-12-23','Christmas Eve','Residual'),
	('2022-12-24','Christmas Eve','Actual'),
	('2022-12-25','Christmas','Actual'),
	('2022-12-26','Christmas','Observed'),
	('2022-12-27','Christmas','Residual'),
	('2022-12-30','New Years','Residual'),
	('2022-12-31','New Years','Residual'),
	('2023-01-01','New Years','Actual'),
	('2023-01-02','New Years','Residual'),
	('2023-01-15','Martin Luther King Jr. Day','Residual'),
	('2023-01-16','Martin Luther King Jr. Day','Actual'),
	('2023-01-17','Martin Luther King Jr. Day','Residual'),
	('2023-02-19','Washingtons Birthday','Residual'),
	('2023-02-20','Washingtons Birthday','Actual'),
	('2023-02-21','Washingtons Birthday','Residual'),
	('2023-03-31','Cesar Chavez Day','Actual'),
	('2023-04-01','Cesar Chavez Day','Residual'),
	('2023-04-02','Cesar Chavez Day','Residual'),
	('2023-04-14','Good Friday','Actual'),
	('2023-04-15','Good Friday','Residual'),
	('2023-04-16','Good Friday','Residual'),
	('2023-05-26','Memorial Day','Residual'),
	('2023-05-29','Memorial Day','Actual'),
	('2023-05-30','Memorial Day','Residual'),
	('2023-06-30','Independence Day','Residual'),
	('2023-07-01','Independence Day','Residual'),
	('2023-07-02','Independence Day','Residual'),
	('2023-07-03','Independence Day','Residual'),
	('2023-07-04','Independence Day','Actual'),
	('2023-07-05','Independence Day','Observed'),
	('2023-09-01','Labor Day','Residual'),
	('2023-09-04','Labor Day','Actual'),
	('2023-09-05','Labor Day','Actual'),
	('2023-10-06','Columbus Day','Residual'),
	('2023-10-09','Columbus Day','Actual'),
	('2023-10-10','Columbus Day','Residual'),
	('2023-11-09','Veterans Day','Residual'),
	('2023-11-10','Veterans Day','Actual'),
	('2023-11-22','Thanksgiving','Residual'),
	('2023-11-23','Thanksgiving','Actual'),
	('2023-11-24','Day After Thanksgiving','Actual'),
	('2023-12-22','Christmas Eve','Residual'),
	('2023-12-23','Christmas Eve','Residual'),
	('2023-12-24','Christmas Eve','Actual'),
	('2023-12-25','Christmas','Actual'),
	('2023-12-26','Christmas','Observed'),
	('2023-12-27','Christmas','Residual'),
	('2023-12-29','New Years','Residual'),
	('2023-12-30','New Years','Residual'),
	('2023-12-31','New Years','Residual')
GO


-- PeMS Clearinghouse data-set
-- Type: Station AADT
-- File: Station AADT Month Hour
CREATE TABLE [pems].[station_aadt] (
	[timestamp] smalldatetime NOT NULL,
	[station] bigint NOT NULL,
    [freeway_identifier] char(5) NOT NULL,
    [freeway_direction] char(1) NOT NULL,
    [city_identifier] char(5) NOT NULL,
    [county_identifier] char(2) NOT NULL,
    [district_identifier] char(2) NOT NULL,
    [station_type] char(2) NOT NULL,
    [param_set] char(1) NOT NULL,
    [absolute_postmile] decimal(7,3) NOT NULL,
    [hour_of_day] tinyint NOT NULL,
    [day_number] tinyint NOT NULL,
    [mahw] decimal(6,1) NULL,
    [number_of_days] tinyint NOT NULL,
    INDEX [ccsi_pems_station_aadt] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_station_aadt] UNIQUE ([timestamp], [station], [day_number], [hour_of_day])
    )
GO


-- PeMS Clearinghouse data-set
-- Type: Station Day
CREATE TABLE [pems].[station_day] (
	[timestamp] smalldatetime NOT NULL,
	[station] bigint NOT NULL,
    [district] char(2) NOT NULL,
    [route] char(5) NOT NULL,
    [direction_of_travel] char(1) NOT NULL,
    [lane_type] char(2) NOT NULL,
    [station_length] decimal(4,3) NULL,
    [samples] smallint NOT NULL,
    [percentage_observed] smallint NOT NULL,
    [total_flow] int NULL,
    [delay_35] decimal(6,1) NULL,
    [delay_40] decimal(6,1) NULL,
    [delay_45] decimal(6,1) NULL,
    [delay_50] decimal(6,1) NULL,
    [delay_55] decimal(6,1) NULL,
    [delay_60] decimal(6,1) NULL,
    INDEX [ccsi_pems_station_day] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_station_day] UNIQUE ([timestamp], [station])
    )
GO


-- PeMS Clearinghouse data-set
-- Type: Station 5-Minute
CREATE TABLE [pems].[station_five_minute] (
	[timestamp] smalldatetime NOT NULL,
	[station] bigint NOT NULL,
    [district] char(2) NOT NULL,
    [freeway] char(5) NOT NULL,
    [direction_of_travel] char(1) NOT NULL,
    [lane_type] char(2) NOT NULL,
    [station_length] decimal(4,3) NULL,
    [samples] smallint NOT NULL,
    [percentage_observed] smallint NOT NULL,
    [total_flow] int NULL,
    [average_occupancy] decimal(5,1) NULL,
    [average_speed] decimal(4,1) NULL,
    [lane1_samples] smallint NULL,
    [lane1_flow] smallint NULL,
    [lane1_average_occupancy] decimal(5,1) NULL,
    [lane1_average_speed] decimal(4,1) NULL,
    [lane1_observed] bit NOT NULL,
    [lane2_samples] smallint NULL,
    [lane2_flow] smallint NULL,
    [lane2_average_occupancy] decimal(5,1) NULL,
    [lane2_average_speed] decimal(4,1) NULL,
    [lane2_observed] bit NOT NULL,
    [lane3_samples] smallint NULL,
    [lane3_flow] smallint NULL,
    [lane3_average_occupancy] decimal(5,1) NULL,
    [lane3_average_speed] decimal(4,1) NULL,
    [lane3_observed] bit NOT NULL,
    [lane4_samples] smallint NULL,
    [lane4_flow] smallint NULL,
    [lane4_average_occupancy] decimal(5,1) NULL,
    [lane4_average_speed] decimal(4,1) NULL,
    [lane4_observed] bit NOT NULL,
    [lane5_samples] smallint NULL,
    [lane5_flow] smallint NULL,
    [lane5_average_occupancy] decimal(5,1) NULL,
    [lane5_average_speed] decimal(4,1) NULL,
    [lane5_observed] bit NOT NULL,
    [lane6_samples] smallint NULL,
    [lane6_flow] smallint NULL,
    [lane6_average_occupancy] decimal(5,1) NULL,
    [lane6_average_speed] decimal(4,1) NULL,
    [lane6_observed] bit NOT NULL,
    [lane7_samples] smallint NULL,
    [lane7_flow] smallint NULL,
    [lane7_average_occupancy] decimal(5,1) NULL,
    [lane7_average_speed] decimal(4,1) NULL,
    [lane7_observed] bit NOT NULL,
    [lane8_samples] smallint NULL,
    [lane8_flow] smallint NULL,
    [lane8_average_occupancy] decimal(5,1) NULL,
    [lane8_average_speed] decimal(4,1) NULL,
    [lane8_observed] bit NOT NULL,
    INDEX [ccsi_pems_station_five_minute] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_station_five_minute] UNIQUE ([timestamp], [station])
    )
GO


-- PeMS Clearinghouse data-set
-- Type: Station Hour
CREATE TABLE [pems].[station_hour] (
	[timestamp] smalldatetime NOT NULL,
	[station] bigint NOT NULL,
    [district] char(2) NOT NULL,
    [route] char(5) NOT NULL,
    [direction_of_travel] char(1) NOT NULL,
    [lane_type] char(2) NOT NULL,
    [station_length] decimal(4,3) NULL,
    [samples] smallint NOT NULL,
    [percentage_observed] smallint NOT NULL,
    [total_flow] int NULL,
    [average_occupancy] decimal(5,1) NULL,
    [average_speed] decimal(4,1) NULL,
    [delay_35] decimal(6,1) NULL,
    [delay_40] decimal(6,1) NULL,
    [delay_45] decimal(6,1) NULL,
    [delay_50] decimal(6,1) NULL,
    [delay_55] decimal(6,1) NULL,
    [delay_60] decimal(6,1) NULL,
    [lane1_flow] smallint NULL,
    [lane1_average_occupancy] decimal(5,1) NULL,
    [lane1_average_speed] decimal(4,1) NULL,
    [lane2_flow] smallint NULL,
    [lane2_average_occupancy] decimal(5,1) NULL,
    [lane2_average_speed] decimal(4,1) NULL,
    [lane3_flow] smallint NULL,
    [lane3_average_occupancy] decimal(5,1) NULL,
    [lane3_average_speed] decimal(4,1) NULL,
    [lane4_flow] smallint NULL,
    [lane4_average_occupancy] decimal(5,1) NULL,
    [lane4_average_speed] decimal(4,1) NULL,
    [lane5_flow] smallint NULL,
    [lane5_average_occupancy] decimal(5,1) NULL,
    [lane5_average_speed] decimal(4,1) NULL,
    [lane6_flow] smallint NULL,
    [lane6_average_occupancy] decimal(5,1) NULL,
    [lane6_average_speed] decimal(4,1) NULL,
    [lane7_flow] smallint NULL,
    [lane7_average_occupancy] decimal(5,1) NULL,
    [lane7_average_speed] decimal(4,1) NULL,
    [lane8_flow] smallint NULL,
    [lane8_average_occupancy] decimal(5,1) NULL,
    [lane8_average_speed] decimal(4,1) NULL,
    INDEX [ccsi_pems_station_hour] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_station_hour] UNIQUE ([timestamp], [station])
    )
GO


-- PeMS Clearinghouse data-set
-- Type: Station Hour
CREATE TABLE [pems].[station_metadata] (
    [metadata_date] date NOT NULL,
    [station] bigint NOT NULL,
	[freeway] char(5) NOT NULL,
	[direction] char(1) NOT NULL,
	[district] char(2) NOT NULL,
	[county] char(2) NOT NULL,
	[city] char(5) NULL,
	[state_postmile] char(10) NOT NULL,
	[absolute_postmile] char(10) NULL,
	[latitude] float NULL,
	[longitude] float NULL,
	[length] float NULL,
	[type] char(2) NOT NULL,
	[lanes] int NOT NULL,
	[name] char(50) NULL,
	[user_id_1] int NOT NULL,
	[user_id_2] int NULL,
	[user_id_3] int NULL,
	[user_id_4] int NULL,
	[shape] geometry NULL,
    CONSTRAINT [ixuq_pems_station_metadata] UNIQUE ([metadata_date], [station])
    )
GO


-- PeMS 5-minute time period cross-reference
CREATE TABLE [pems].[time_min5_xref] (
	[min5] smallint NOT NULL,
	[min5_period_start] time NOT NULL,
	[min5_period_end] time NOT NULL,
	[min15] tinyint NOT NULL,
	[min15_period_start] time NOT NULL,
	[min15_period_end] time NOT NULL,
	[min30] tinyint NOT NULL,
	[min30_period_start] time NOT NULL,
	[min30_period_end] time NOT NULL,
	[abm_half_hour] tinyint NOT NULL,
	[abm_half_hour_period_start] time NOT NULL,
	[abm_half_hour_period_end] time NOT NULL,
	[min60] tinyint NOT NULL,
	[min60_period_start] time NOT NULL,
	[min60_period_end] time NOT NULL,
	[abm_5_tod] tinyint NOT NULL,
	[abm_5_tod_period_start] time NOT NULL,
	[abm_5_tod_period_end] time NOT NULL,
	[day] tinyint NOT NULL,
	[day_period_start] time NOT NULL,
	[day_period_end] time NOT NULL,
    INDEX [ccsi_pems_time_min5_xref] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_time_min5_xref] UNIQUE ([min5])
    )
INSERT INTO [pems].[time_min5_xref] VALUES
    (1,'00:00:00','00:04:59',1,'00:00:00','00:14:59',1,'00:00:00','00:29:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (2,'00:05:00','00:09:59',1,'00:00:00','00:14:59',1,'00:00:00','00:29:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (3,'00:10:00','00:14:59',1,'00:00:00','00:14:59',1,'00:00:00','00:29:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (4,'00:15:00','00:19:59',2,'00:15:00','00:29:59',1,'00:00:00','00:29:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (5,'00:20:00','00:24:59',2,'00:15:00','00:29:59',1,'00:00:00','00:29:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (6,'00:25:00','00:29:59',2,'00:15:00','00:29:59',1,'00:00:00','00:29:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (7,'00:30:00','00:34:59',3,'00:30:00','00:44:59',2,'00:30:00','00:59:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (8,'00:35:00','00:39:59',3,'00:30:00','00:44:59',2,'00:30:00','00:59:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (9,'00:40:00','00:44:59',3,'00:30:00','00:44:59',2,'00:30:00','00:59:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (10,'00:45:00','00:49:59',4,'00:45:00','00:59:59',2,'00:30:00','00:59:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (11,'00:50:00','00:54:59',4,'00:45:00','00:59:59',2,'00:30:00','00:59:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (12,'00:55:00','00:59:59',4,'00:45:00','00:59:59',2,'00:30:00','00:59:59',40,'00:00:00','02:59:59',1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (13,'01:00:00','01:04:59',5,'01:00:00','01:14:59',3,'01:00:00','01:29:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (14,'01:05:00','01:09:59',5,'01:00:00','01:14:59',3,'01:00:00','01:29:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (15,'01:10:00','01:14:59',5,'01:00:00','01:14:59',3,'01:00:00','01:29:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (16,'01:15:00','01:19:59',6,'01:15:00','01:29:59',3,'01:00:00','01:29:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (17,'01:20:00','01:24:59',6,'01:15:00','01:29:59',3,'01:00:00','01:29:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (18,'01:25:00','01:29:59',6,'01:15:00','01:29:59',3,'01:00:00','01:29:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (19,'01:30:00','01:34:59',7,'01:30:00','01:44:59',4,'01:30:00','01:59:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (20,'01:35:00','01:39:59',7,'01:30:00','01:44:59',4,'01:30:00','01:59:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (21,'01:40:00','01:44:59',7,'01:30:00','01:44:59',4,'01:30:00','01:59:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (22,'01:45:00','01:49:59',8,'01:45:00','01:59:59',4,'01:30:00','01:59:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (23,'01:50:00','01:54:59',8,'01:45:00','01:59:59',4,'01:30:00','01:59:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (24,'01:55:00','01:59:59',8,'01:45:00','01:59:59',4,'01:30:00','01:59:59',40,'00:00:00','02:59:59',2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (25,'02:00:00','02:04:59',9,'02:00:00','02:14:59',5,'02:00:00','02:29:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (26,'02:05:00','02:09:59',9,'02:00:00','02:14:59',5,'02:00:00','02:29:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (27,'02:10:00','02:14:59',9,'02:00:00','02:14:59',5,'02:00:00','02:29:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (28,'02:15:00','02:19:59',10,'02:15:00','02:29:59',5,'02:00:00','02:29:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (29,'02:20:00','02:24:59',10,'02:15:00','02:29:59',5,'02:00:00','02:29:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (30,'02:25:00','02:29:59',10,'02:15:00','02:29:59',5,'02:00:00','02:29:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (31,'02:30:00','02:34:59',11,'02:30:00','02:44:59',6,'02:30:00','02:59:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (32,'02:35:00','02:39:59',11,'02:30:00','02:44:59',6,'02:30:00','02:59:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (33,'02:40:00','02:44:59',11,'02:30:00','02:44:59',6,'02:30:00','02:59:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (34,'02:45:00','02:49:59',12,'02:45:00','02:59:59',6,'02:30:00','02:59:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (35,'02:50:00','02:54:59',12,'02:45:00','02:59:59',6,'02:30:00','02:59:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (36,'02:55:00','02:59:59',12,'02:45:00','02:59:59',6,'02:30:00','02:59:59',40,'00:00:00','02:59:59',3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (37,'03:00:00','03:04:59',13,'03:00:00','03:14:59',7,'03:00:00','03:29:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (38,'03:05:00','03:09:59',13,'03:00:00','03:14:59',7,'03:00:00','03:29:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (39,'03:10:00','03:14:59',13,'03:00:00','03:14:59',7,'03:00:00','03:29:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (40,'03:15:00','03:19:59',14,'03:15:00','03:29:59',7,'03:00:00','03:29:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (41,'03:20:00','03:24:59',14,'03:15:00','03:29:59',7,'03:00:00','03:29:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (42,'03:25:00','03:29:59',14,'03:15:00','03:29:59',7,'03:00:00','03:29:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (43,'03:30:00','03:34:59',15,'03:30:00','03:44:59',8,'03:30:00','03:59:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (44,'03:35:00','03:39:59',15,'03:30:00','03:44:59',8,'03:30:00','03:59:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (45,'03:40:00','03:44:59',15,'03:30:00','03:44:59',8,'03:30:00','03:59:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (46,'03:45:00','03:49:59',16,'03:45:00','03:59:59',8,'03:30:00','03:59:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (47,'03:50:00','03:54:59',16,'03:45:00','03:59:59',8,'03:30:00','03:59:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (48,'03:55:00','03:59:59',16,'03:45:00','03:59:59',8,'03:30:00','03:59:59',1,'03:00:00','04:59:59',4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (49,'04:00:00','04:04:59',17,'04:00:00','04:14:59',9,'04:00:00','04:29:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (50,'04:05:00','04:09:59',17,'04:00:00','04:14:59',9,'04:00:00','04:29:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (51,'04:10:00','04:14:59',17,'04:00:00','04:14:59',9,'04:00:00','04:29:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (52,'04:15:00','04:19:59',18,'04:15:00','04:29:59',9,'04:00:00','04:29:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (53,'04:20:00','04:24:59',18,'04:15:00','04:29:59',9,'04:00:00','04:29:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (54,'04:25:00','04:29:59',18,'04:15:00','04:29:59',9,'04:00:00','04:29:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (55,'04:30:00','04:34:59',19,'04:30:00','04:44:59',10,'04:30:00','04:59:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (56,'04:35:00','04:39:59',19,'04:30:00','04:44:59',10,'04:30:00','04:59:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (57,'04:40:00','04:44:59',19,'04:30:00','04:44:59',10,'04:30:00','04:59:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (58,'04:45:00','04:49:59',20,'04:45:00','04:59:59',10,'04:30:00','04:59:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (59,'04:50:00','04:54:59',20,'04:45:00','04:59:59',10,'04:30:00','04:59:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (60,'04:55:00','04:59:59',20,'04:45:00','04:59:59',10,'04:30:00','04:59:59',1,'03:00:00','04:59:59',5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (61,'05:00:00','05:04:59',21,'05:00:00','05:14:59',11,'05:00:00','05:29:59',2,'05:00:00','05:29:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (62,'05:05:00','05:09:59',21,'05:00:00','05:14:59',11,'05:00:00','05:29:59',2,'05:00:00','05:29:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (63,'05:10:00','05:14:59',21,'05:00:00','05:14:59',11,'05:00:00','05:29:59',2,'05:00:00','05:29:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (64,'05:15:00','05:19:59',22,'05:15:00','05:29:59',11,'05:00:00','05:29:59',2,'05:00:00','05:29:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (65,'05:20:00','05:24:59',22,'05:15:00','05:29:59',11,'05:00:00','05:29:59',2,'05:00:00','05:29:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (66,'05:25:00','05:29:59',22,'05:15:00','05:29:59',11,'05:00:00','05:29:59',2,'05:00:00','05:29:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (67,'05:30:00','05:34:59',23,'05:30:00','05:44:59',12,'05:30:00','05:59:59',3,'05:30:00','05:59:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (68,'05:35:00','05:39:59',23,'05:30:00','05:44:59',12,'05:30:00','05:59:59',3,'05:30:00','05:59:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (69,'05:40:00','05:44:59',23,'05:30:00','05:44:59',12,'05:30:00','05:59:59',3,'05:30:00','05:59:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (70,'05:45:00','05:49:59',24,'05:45:00','05:59:59',12,'05:30:00','05:59:59',3,'05:30:00','05:59:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (71,'05:50:00','05:54:59',24,'05:45:00','05:59:59',12,'05:30:00','05:59:59',3,'05:30:00','05:59:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (72,'05:55:00','05:59:59',24,'05:45:00','05:59:59',12,'05:30:00','05:59:59',3,'05:30:00','05:59:59',6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (73,'06:00:00','06:04:59',25,'06:00:00','06:14:59',13,'06:00:00','06:29:59',4,'06:00:00','06:29:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (74,'06:05:00','06:09:59',25,'06:00:00','06:14:59',13,'06:00:00','06:29:59',4,'06:00:00','06:29:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (75,'06:10:00','06:14:59',25,'06:00:00','06:14:59',13,'06:00:00','06:29:59',4,'06:00:00','06:29:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (76,'06:15:00','06:19:59',26,'06:15:00','06:29:59',13,'06:00:00','06:29:59',4,'06:00:00','06:29:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (77,'06:20:00','06:24:59',26,'06:15:00','06:29:59',13,'06:00:00','06:29:59',4,'06:00:00','06:29:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (78,'06:25:00','06:29:59',26,'06:15:00','06:29:59',13,'06:00:00','06:29:59',4,'06:00:00','06:29:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (79,'06:30:00','06:34:59',27,'06:30:00','06:44:59',14,'06:30:00','06:59:59',5,'06:30:00','06:59:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (80,'06:35:00','06:39:59',27,'06:30:00','06:44:59',14,'06:30:00','06:59:59',5,'06:30:00','06:59:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (81,'06:40:00','06:44:59',27,'06:30:00','06:44:59',14,'06:30:00','06:59:59',5,'06:30:00','06:59:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (82,'06:45:00','06:49:59',28,'06:45:00','06:59:59',14,'06:30:00','06:59:59',5,'06:30:00','06:59:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (83,'06:50:00','06:54:59',28,'06:45:00','06:59:59',14,'06:30:00','06:59:59',5,'06:30:00','06:59:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (84,'06:55:00','06:59:59',28,'06:45:00','06:59:59',14,'06:30:00','06:59:59',5,'06:30:00','06:59:59',7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (85,'07:00:00','07:04:59',29,'07:00:00','07:14:59',15,'07:00:00','07:29:59',6,'07:00:00','07:29:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (86,'07:05:00','07:09:59',29,'07:00:00','07:14:59',15,'07:00:00','07:29:59',6,'07:00:00','07:29:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (87,'07:10:00','07:14:59',29,'07:00:00','07:14:59',15,'07:00:00','07:29:59',6,'07:00:00','07:29:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (88,'07:15:00','07:19:59',30,'07:15:00','07:29:59',15,'07:00:00','07:29:59',6,'07:00:00','07:29:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (89,'07:20:00','07:24:59',30,'07:15:00','07:29:59',15,'07:00:00','07:29:59',6,'07:00:00','07:29:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (90,'07:25:00','07:29:59',30,'07:15:00','07:29:59',15,'07:00:00','07:29:59',6,'07:00:00','07:29:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (91,'07:30:00','07:34:59',31,'07:30:00','07:44:59',16,'07:30:00','07:59:59',7,'07:30:00','07:59:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (92,'07:35:00','07:39:59',31,'07:30:00','07:44:59',16,'07:30:00','07:59:59',7,'07:30:00','07:59:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (93,'07:40:00','07:44:59',31,'07:30:00','07:44:59',16,'07:30:00','07:59:59',7,'07:30:00','07:59:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (94,'07:45:00','07:49:59',32,'07:45:00','07:59:59',16,'07:30:00','07:59:59',7,'07:30:00','07:59:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (95,'07:50:00','07:54:59',32,'07:45:00','07:59:59',16,'07:30:00','07:59:59',7,'07:30:00','07:59:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (96,'07:55:00','07:59:59',32,'07:45:00','07:59:59',16,'07:30:00','07:59:59',7,'07:30:00','07:59:59',8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (97,'08:00:00','08:04:59',33,'08:00:00','08:14:59',17,'08:00:00','08:29:59',8,'08:00:00','08:29:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (98,'08:05:00','08:09:59',33,'08:00:00','08:14:59',17,'08:00:00','08:29:59',8,'08:00:00','08:29:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (99,'08:10:00','08:14:59',33,'08:00:00','08:14:59',17,'08:00:00','08:29:59',8,'08:00:00','08:29:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (100,'08:15:00','08:19:59',34,'08:15:00','08:29:59',17,'08:00:00','08:29:59',8,'08:00:00','08:29:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (101,'08:20:00','08:24:59',34,'08:15:00','08:29:59',17,'08:00:00','08:29:59',8,'08:00:00','08:29:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (102,'08:25:00','08:29:59',34,'08:15:00','08:29:59',17,'08:00:00','08:29:59',8,'08:00:00','08:29:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (103,'08:30:00','08:34:59',35,'08:30:00','08:44:59',18,'08:30:00','08:59:59',9,'08:30:00','08:59:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (104,'08:35:00','08:39:59',35,'08:30:00','08:44:59',18,'08:30:00','08:59:59',9,'08:30:00','08:59:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (105,'08:40:00','08:44:59',35,'08:30:00','08:44:59',18,'08:30:00','08:59:59',9,'08:30:00','08:59:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (106,'08:45:00','08:49:59',36,'08:45:00','08:59:59',18,'08:30:00','08:59:59',9,'08:30:00','08:59:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (107,'08:50:00','08:54:59',36,'08:45:00','08:59:59',18,'08:30:00','08:59:59',9,'08:30:00','08:59:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (108,'08:55:00','08:59:59',36,'08:45:00','08:59:59',18,'08:30:00','08:59:59',9,'08:30:00','08:59:59',9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (109,'09:00:00','09:04:59',37,'09:00:00','09:14:59',19,'09:00:00','09:29:59',10,'09:00:00','09:29:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (110,'09:05:00','09:09:59',37,'09:00:00','09:14:59',19,'09:00:00','09:29:59',10,'09:00:00','09:29:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (111,'09:10:00','09:14:59',37,'09:00:00','09:14:59',19,'09:00:00','09:29:59',10,'09:00:00','09:29:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (112,'09:15:00','09:19:59',38,'09:15:00','09:29:59',19,'09:00:00','09:29:59',10,'09:00:00','09:29:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (113,'09:20:00','09:24:59',38,'09:15:00','09:29:59',19,'09:00:00','09:29:59',10,'09:00:00','09:29:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (114,'09:25:00','09:29:59',38,'09:15:00','09:29:59',19,'09:00:00','09:29:59',10,'09:00:00','09:29:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (115,'09:30:00','09:34:59',39,'09:30:00','09:44:59',20,'09:30:00','09:59:59',11,'09:30:00','09:59:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (116,'09:35:00','09:39:59',39,'09:30:00','09:44:59',20,'09:30:00','09:59:59',11,'09:30:00','09:59:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (117,'09:40:00','09:44:59',39,'09:30:00','09:44:59',20,'09:30:00','09:59:59',11,'09:30:00','09:59:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (118,'09:45:00','09:49:59',40,'09:45:00','09:59:59',20,'09:30:00','09:59:59',11,'09:30:00','09:59:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (119,'09:50:00','09:54:59',40,'09:45:00','09:59:59',20,'09:30:00','09:59:59',11,'09:30:00','09:59:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (120,'09:55:00','09:59:59',40,'09:45:00','09:59:59',20,'09:30:00','09:59:59',11,'09:30:00','09:59:59',10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (121,'10:00:00','10:04:59',41,'10:00:00','10:14:59',21,'10:00:00','10:29:59',12,'10:00:00','10:29:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (122,'10:05:00','10:09:59',41,'10:00:00','10:14:59',21,'10:00:00','10:29:59',12,'10:00:00','10:29:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (123,'10:10:00','10:14:59',41,'10:00:00','10:14:59',21,'10:00:00','10:29:59',12,'10:00:00','10:29:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (124,'10:15:00','10:19:59',42,'10:15:00','10:29:59',21,'10:00:00','10:29:59',12,'10:00:00','10:29:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (125,'10:20:00','10:24:59',42,'10:15:00','10:29:59',21,'10:00:00','10:29:59',12,'10:00:00','10:29:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (126,'10:25:00','10:29:59',42,'10:15:00','10:29:59',21,'10:00:00','10:29:59',12,'10:00:00','10:29:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (127,'10:30:00','10:34:59',43,'10:30:00','10:44:59',22,'10:30:00','10:59:59',13,'10:30:00','10:59:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (128,'10:35:00','10:39:59',43,'10:30:00','10:44:59',22,'10:30:00','10:59:59',13,'10:30:00','10:59:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (129,'10:40:00','10:44:59',43,'10:30:00','10:44:59',22,'10:30:00','10:59:59',13,'10:30:00','10:59:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (130,'10:45:00','10:49:59',44,'10:45:00','10:59:59',22,'10:30:00','10:59:59',13,'10:30:00','10:59:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (131,'10:50:00','10:54:59',44,'10:45:00','10:59:59',22,'10:30:00','10:59:59',13,'10:30:00','10:59:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (132,'10:55:00','10:59:59',44,'10:45:00','10:59:59',22,'10:30:00','10:59:59',13,'10:30:00','10:59:59',11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (133,'11:00:00','11:04:59',45,'11:00:00','11:14:59',23,'11:00:00','11:29:59',14,'11:00:00','11:29:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (134,'11:05:00','11:09:59',45,'11:00:00','11:14:59',23,'11:00:00','11:29:59',14,'11:00:00','11:29:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (135,'11:10:00','11:14:59',45,'11:00:00','11:14:59',23,'11:00:00','11:29:59',14,'11:00:00','11:29:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (136,'11:15:00','11:19:59',46,'11:15:00','11:29:59',23,'11:00:00','11:29:59',14,'11:00:00','11:29:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (137,'11:20:00','11:24:59',46,'11:15:00','11:29:59',23,'11:00:00','11:29:59',14,'11:00:00','11:29:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (138,'11:25:00','11:29:59',46,'11:15:00','11:29:59',23,'11:00:00','11:29:59',14,'11:00:00','11:29:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (139,'11:30:00','11:34:59',47,'11:30:00','11:44:59',24,'11:30:00','11:59:59',15,'11:30:00','11:59:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (140,'11:35:00','11:39:59',47,'11:30:00','11:44:59',24,'11:30:00','11:59:59',15,'11:30:00','11:59:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (141,'11:40:00','11:44:59',47,'11:30:00','11:44:59',24,'11:30:00','11:59:59',15,'11:30:00','11:59:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (142,'11:45:00','11:49:59',48,'11:45:00','11:59:59',24,'11:30:00','11:59:59',15,'11:30:00','11:59:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (143,'11:50:00','11:54:59',48,'11:45:00','11:59:59',24,'11:30:00','11:59:59',15,'11:30:00','11:59:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (144,'11:55:00','11:59:59',48,'11:45:00','11:59:59',24,'11:30:00','11:59:59',15,'11:30:00','11:59:59',12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (145,'12:00:00','12:04:59',49,'12:00:00','12:14:59',25,'12:00:00','12:29:59',16,'12:00:00','12:29:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (146,'12:05:00','12:09:59',49,'12:00:00','12:14:59',25,'12:00:00','12:29:59',16,'12:00:00','12:29:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (147,'12:10:00','12:14:59',49,'12:00:00','12:14:59',25,'12:00:00','12:29:59',16,'12:00:00','12:29:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (148,'12:15:00','12:19:59',50,'12:15:00','12:29:59',25,'12:00:00','12:29:59',16,'12:00:00','12:29:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (149,'12:20:00','12:24:59',50,'12:15:00','12:29:59',25,'12:00:00','12:29:59',16,'12:00:00','12:29:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (150,'12:25:00','12:29:59',50,'12:15:00','12:29:59',25,'12:00:00','12:29:59',16,'12:00:00','12:29:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (151,'12:30:00','12:34:59',51,'12:30:00','12:44:59',26,'12:30:00','12:59:59',17,'12:30:00','12:59:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (152,'12:35:00','12:39:59',51,'12:30:00','12:44:59',26,'12:30:00','12:59:59',17,'12:30:00','12:59:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (153,'12:40:00','12:44:59',51,'12:30:00','12:44:59',26,'12:30:00','12:59:59',17,'12:30:00','12:59:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (154,'12:45:00','12:49:59',52,'12:45:00','12:59:59',26,'12:30:00','12:59:59',17,'12:30:00','12:59:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (155,'12:50:00','12:54:59',52,'12:45:00','12:59:59',26,'12:30:00','12:59:59',17,'12:30:00','12:59:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (156,'12:55:00','12:59:59',52,'12:45:00','12:59:59',26,'12:30:00','12:59:59',17,'12:30:00','12:59:59',13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (157,'13:00:00','13:04:59',53,'13:00:00','13:14:59',27,'13:00:00','13:29:59',18,'13:00:00','13:29:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (158,'13:05:00','13:09:59',53,'13:00:00','13:14:59',27,'13:00:00','13:29:59',18,'13:00:00','13:29:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (159,'13:10:00','13:14:59',53,'13:00:00','13:14:59',27,'13:00:00','13:29:59',18,'13:00:00','13:29:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (160,'13:15:00','13:19:59',54,'13:15:00','13:29:59',27,'13:00:00','13:29:59',18,'13:00:00','13:29:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (161,'13:20:00','13:24:59',54,'13:15:00','13:29:59',27,'13:00:00','13:29:59',18,'13:00:00','13:29:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (162,'13:25:00','13:29:59',54,'13:15:00','13:29:59',27,'13:00:00','13:29:59',18,'13:00:00','13:29:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (163,'13:30:00','13:34:59',55,'13:30:00','13:44:59',28,'13:30:00','13:59:59',19,'13:30:00','13:59:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (164,'13:35:00','13:39:59',55,'13:30:00','13:44:59',28,'13:30:00','13:59:59',19,'13:30:00','13:59:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (165,'13:40:00','13:44:59',55,'13:30:00','13:44:59',28,'13:30:00','13:59:59',19,'13:30:00','13:59:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (166,'13:45:00','13:49:59',56,'13:45:00','13:59:59',28,'13:30:00','13:59:59',19,'13:30:00','13:59:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (167,'13:50:00','13:54:59',56,'13:45:00','13:59:59',28,'13:30:00','13:59:59',19,'13:30:00','13:59:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (168,'13:55:00','13:59:59',56,'13:45:00','13:59:59',28,'13:30:00','13:59:59',19,'13:30:00','13:59:59',14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (169,'14:00:00','14:04:59',57,'14:00:00','14:14:59',29,'14:00:00','14:29:59',20,'14:00:00','14:29:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (170,'14:05:00','14:09:59',57,'14:00:00','14:14:59',29,'14:00:00','14:29:59',20,'14:00:00','14:29:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (171,'14:10:00','14:14:59',57,'14:00:00','14:14:59',29,'14:00:00','14:29:59',20,'14:00:00','14:29:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (172,'14:15:00','14:19:59',58,'14:15:00','14:29:59',29,'14:00:00','14:29:59',20,'14:00:00','14:29:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (173,'14:20:00','14:24:59',58,'14:15:00','14:29:59',29,'14:00:00','14:29:59',20,'14:00:00','14:29:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (174,'14:25:00','14:29:59',58,'14:15:00','14:29:59',29,'14:00:00','14:29:59',20,'14:00:00','14:29:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (175,'14:30:00','14:34:59',59,'14:30:00','14:44:59',30,'14:30:00','14:59:59',21,'14:30:00','14:59:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (176,'14:35:00','14:39:59',59,'14:30:00','14:44:59',30,'14:30:00','14:59:59',21,'14:30:00','14:59:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (177,'14:40:00','14:44:59',59,'14:30:00','14:44:59',30,'14:30:00','14:59:59',21,'14:30:00','14:59:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (178,'14:45:00','14:49:59',60,'14:45:00','14:59:59',30,'14:30:00','14:59:59',21,'14:30:00','14:59:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (179,'14:50:00','14:54:59',60,'14:45:00','14:59:59',30,'14:30:00','14:59:59',21,'14:30:00','14:59:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (180,'14:55:00','14:59:59',60,'14:45:00','14:59:59',30,'14:30:00','14:59:59',21,'14:30:00','14:59:59',15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (181,'15:00:00','15:04:59',61,'15:00:00','15:14:59',31,'15:00:00','15:29:59',22,'15:00:00','15:29:59',16,'15:00:00','15:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (182,'15:05:00','15:09:59',61,'15:00:00','15:14:59',31,'15:00:00','15:29:59',22,'15:00:00','15:29:59',16,'15:00:00','15:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (183,'15:10:00','15:14:59',61,'15:00:00','15:14:59',31,'15:00:00','15:29:59',22,'15:00:00','15:29:59',16,'15:00:00','15:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (184,'15:15:00','15:19:59',62,'15:15:00','15:29:59',31,'15:00:00','15:29:59',22,'15:00:00','15:29:59',16,'15:00:00','15:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (185,'15:20:00','15:24:59',62,'15:15:00','15:29:59',31,'15:00:00','15:29:59',22,'15:00:00','15:29:59',16,'15:00:00','15:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (186,'15:25:00','15:29:59',62,'15:15:00','15:29:59',31,'15:00:00','15:29:59',22,'15:00:00','15:29:59',16,'15:00:00','15:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (187,'15:30:00','15:34:59',63,'15:30:00','15:44:59',32,'15:30:00','15:59:59',23,'15:30:00','15:59:59',16,'15:00:00','15:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (188,'15:35:00','15:39:59',63,'15:30:00','15:44:59',32,'15:30:00','15:59:59',23,'15:30:00','15:59:59',16,'15:00:00','15:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (189,'15:40:00','15:44:59',63,'15:30:00','15:44:59',32,'15:30:00','15:59:59',23,'15:30:00','15:59:59',16,'15:00:00','15:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (190,'15:45:00','15:49:59',64,'15:45:00','15:59:59',32,'15:30:00','15:59:59',23,'15:30:00','15:59:59',16,'15:00:00','15:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (191,'15:50:00','15:54:59',64,'15:45:00','15:59:59',32,'15:30:00','15:59:59',23,'15:30:00','15:59:59',16,'15:00:00','15:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (192,'15:55:00','15:59:59',64,'15:45:00','15:59:59',32,'15:30:00','15:59:59',23,'15:30:00','15:59:59',16,'15:00:00','15:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (193,'16:00:00','16:04:59',65,'16:00:00','16:14:59',33,'16:00:00','16:29:59',24,'16:00:00','16:29:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (194,'16:05:00','16:09:59',65,'16:00:00','16:14:59',33,'16:00:00','16:29:59',24,'16:00:00','16:29:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (195,'16:10:00','16:14:59',65,'16:00:00','16:14:59',33,'16:00:00','16:29:59',24,'16:00:00','16:29:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (196,'16:15:00','16:19:59',66,'16:15:00','16:29:59',33,'16:00:00','16:29:59',24,'16:00:00','16:29:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (197,'16:20:00','16:24:59',66,'16:15:00','16:29:59',33,'16:00:00','16:29:59',24,'16:00:00','16:29:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (198,'16:25:00','16:29:59',66,'16:15:00','16:29:59',33,'16:00:00','16:29:59',24,'16:00:00','16:29:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (199,'16:30:00','16:34:59',67,'16:30:00','16:44:59',34,'16:30:00','16:59:59',25,'16:30:00','16:59:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (200,'16:35:00','16:39:59',67,'16:30:00','16:44:59',34,'16:30:00','16:59:59',25,'16:30:00','16:59:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (201,'16:40:00','16:44:59',67,'16:30:00','16:44:59',34,'16:30:00','16:59:59',25,'16:30:00','16:59:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (202,'16:45:00','16:49:59',68,'16:45:00','16:59:59',34,'16:30:00','16:59:59',25,'16:30:00','16:59:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (203,'16:50:00','16:54:59',68,'16:45:00','16:59:59',34,'16:30:00','16:59:59',25,'16:30:00','16:59:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (204,'16:55:00','16:59:59',68,'16:45:00','16:59:59',34,'16:30:00','16:59:59',25,'16:30:00','16:59:59',17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (205,'17:00:00','17:04:59',69,'17:00:00','17:14:59',35,'17:00:00','17:29:59',26,'17:00:00','17:29:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (206,'17:05:00','17:09:59',69,'17:00:00','17:14:59',35,'17:00:00','17:29:59',26,'17:00:00','17:29:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (207,'17:10:00','17:14:59',69,'17:00:00','17:14:59',35,'17:00:00','17:29:59',26,'17:00:00','17:29:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (208,'17:15:00','17:19:59',70,'17:15:00','17:29:59',35,'17:00:00','17:29:59',26,'17:00:00','17:29:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (209,'17:20:00','17:24:59',70,'17:15:00','17:29:59',35,'17:00:00','17:29:59',26,'17:00:00','17:29:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (210,'17:25:00','17:29:59',70,'17:15:00','17:29:59',35,'17:00:00','17:29:59',26,'17:00:00','17:29:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (211,'17:30:00','17:34:59',71,'17:30:00','17:44:59',36,'17:30:00','17:59:59',27,'17:30:00','17:59:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (212,'17:35:00','17:39:59',71,'17:30:00','17:44:59',36,'17:30:00','17:59:59',27,'17:30:00','17:59:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (213,'17:40:00','17:44:59',71,'17:30:00','17:44:59',36,'17:30:00','17:59:59',27,'17:30:00','17:59:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (214,'17:45:00','17:49:59',72,'17:45:00','17:59:59',36,'17:30:00','17:59:59',27,'17:30:00','17:59:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (215,'17:50:00','17:54:59',72,'17:45:00','17:59:59',36,'17:30:00','17:59:59',27,'17:30:00','17:59:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (216,'17:55:00','17:59:59',72,'17:45:00','17:59:59',36,'17:30:00','17:59:59',27,'17:30:00','17:59:59',18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (217,'18:00:00','18:04:59',73,'18:00:00','18:14:59',37,'18:00:00','18:29:59',28,'18:00:00','18:29:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (218,'18:05:00','18:09:59',73,'18:00:00','18:14:59',37,'18:00:00','18:29:59',28,'18:00:00','18:29:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (219,'18:10:00','18:14:59',73,'18:00:00','18:14:59',37,'18:00:00','18:29:59',28,'18:00:00','18:29:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (220,'18:15:00','18:19:59',74,'18:15:00','18:29:59',37,'18:00:00','18:29:59',28,'18:00:00','18:29:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (221,'18:20:00','18:24:59',74,'18:15:00','18:29:59',37,'18:00:00','18:29:59',28,'18:00:00','18:29:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (222,'18:25:00','18:29:59',74,'18:15:00','18:29:59',37,'18:00:00','18:29:59',28,'18:00:00','18:29:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (223,'18:30:00','18:34:59',75,'18:30:00','18:44:59',38,'18:30:00','18:59:59',29,'18:30:00','18:59:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (224,'18:35:00','18:39:59',75,'18:30:00','18:44:59',38,'18:30:00','18:59:59',29,'18:30:00','18:59:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (225,'18:40:00','18:44:59',75,'18:30:00','18:44:59',38,'18:30:00','18:59:59',29,'18:30:00','18:59:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (226,'18:45:00','18:49:59',76,'18:45:00','18:59:59',38,'18:30:00','18:59:59',29,'18:30:00','18:59:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (227,'18:50:00','18:54:59',76,'18:45:00','18:59:59',38,'18:30:00','18:59:59',29,'18:30:00','18:59:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (228,'18:55:00','18:59:59',76,'18:45:00','18:59:59',38,'18:30:00','18:59:59',29,'18:30:00','18:59:59',19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (229,'19:00:00','19:04:59',77,'19:00:00','19:14:59',39,'19:00:00','19:29:59',30,'19:00:00','19:29:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (230,'19:05:00','19:09:59',77,'19:00:00','19:14:59',39,'19:00:00','19:29:59',30,'19:00:00','19:29:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (231,'19:10:00','19:14:59',77,'19:00:00','19:14:59',39,'19:00:00','19:29:59',30,'19:00:00','19:29:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (232,'19:15:00','19:19:59',78,'19:15:00','19:29:59',39,'19:00:00','19:29:59',30,'19:00:00','19:29:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (233,'19:20:00','19:24:59',78,'19:15:00','19:29:59',39,'19:00:00','19:29:59',30,'19:00:00','19:29:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (234,'19:25:00','19:29:59',78,'19:15:00','19:29:59',39,'19:00:00','19:29:59',30,'19:00:00','19:29:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (235,'19:30:00','19:34:59',79,'19:30:00','19:44:59',40,'19:30:00','19:59:59',31,'19:30:00','19:59:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (236,'19:35:00','19:39:59',79,'19:30:00','19:44:59',40,'19:30:00','19:59:59',31,'19:30:00','19:59:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (237,'19:40:00','19:44:59',79,'19:30:00','19:44:59',40,'19:30:00','19:59:59',31,'19:30:00','19:59:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (238,'19:45:00','19:49:59',80,'19:45:00','19:59:59',40,'19:30:00','19:59:59',31,'19:30:00','19:59:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (239,'19:50:00','19:54:59',80,'19:45:00','19:59:59',40,'19:30:00','19:59:59',31,'19:30:00','19:59:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (240,'19:55:00','19:59:59',80,'19:45:00','19:59:59',40,'19:30:00','19:59:59',31,'19:30:00','19:59:59',20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (241,'20:00:00','20:04:59',81,'20:00:00','20:14:59',41,'20:00:00','20:29:59',32,'20:00:00','20:29:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (242,'20:05:00','20:09:59',81,'20:00:00','20:14:59',41,'20:00:00','20:29:59',32,'20:00:00','20:29:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (243,'20:10:00','20:14:59',81,'20:00:00','20:14:59',41,'20:00:00','20:29:59',32,'20:00:00','20:29:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (244,'20:15:00','20:19:59',82,'20:15:00','20:29:59',41,'20:00:00','20:29:59',32,'20:00:00','20:29:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (245,'20:20:00','20:24:59',82,'20:15:00','20:29:59',41,'20:00:00','20:29:59',32,'20:00:00','20:29:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (246,'20:25:00','20:29:59',82,'20:15:00','20:29:59',41,'20:00:00','20:29:59',32,'20:00:00','20:29:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (247,'20:30:00','20:34:59',83,'20:30:00','20:44:59',42,'20:30:00','20:59:59',33,'20:30:00','20:59:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (248,'20:35:00','20:39:59',83,'20:30:00','20:44:59',42,'20:30:00','20:59:59',33,'20:30:00','20:59:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (249,'20:40:00','20:44:59',83,'20:30:00','20:44:59',42,'20:30:00','20:59:59',33,'20:30:00','20:59:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (250,'20:45:00','20:49:59',84,'20:45:00','20:59:59',42,'20:30:00','20:59:59',33,'20:30:00','20:59:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (251,'20:50:00','20:54:59',84,'20:45:00','20:59:59',42,'20:30:00','20:59:59',33,'20:30:00','20:59:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (252,'20:55:00','20:59:59',84,'20:45:00','20:59:59',42,'20:30:00','20:59:59',33,'20:30:00','20:59:59',21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (253,'21:00:00','21:04:59',85,'21:00:00','21:14:59',43,'21:00:00','21:29:59',34,'21:00:00','21:29:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (254,'21:05:00','21:09:59',85,'21:00:00','21:14:59',43,'21:00:00','21:29:59',34,'21:00:00','21:29:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (255,'21:10:00','21:14:59',85,'21:00:00','21:14:59',43,'21:00:00','21:29:59',34,'21:00:00','21:29:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (256,'21:15:00','21:19:59',86,'21:15:00','21:29:59',43,'21:00:00','21:29:59',34,'21:00:00','21:29:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (257,'21:20:00','21:24:59',86,'21:15:00','21:29:59',43,'21:00:00','21:29:59',34,'21:00:00','21:29:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (258,'21:25:00','21:29:59',86,'21:15:00','21:29:59',43,'21:00:00','21:29:59',34,'21:00:00','21:29:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (259,'21:30:00','21:34:59',87,'21:30:00','21:44:59',44,'21:30:00','21:59:59',35,'21:30:00','21:59:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (260,'21:35:00','21:39:59',87,'21:30:00','21:44:59',44,'21:30:00','21:59:59',35,'21:30:00','21:59:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (261,'21:40:00','21:44:59',87,'21:30:00','21:44:59',44,'21:30:00','21:59:59',35,'21:30:00','21:59:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (262,'21:45:00','21:49:59',88,'21:45:00','21:59:59',44,'21:30:00','21:59:59',35,'21:30:00','21:59:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (263,'21:50:00','21:54:59',88,'21:45:00','21:59:59',44,'21:30:00','21:59:59',35,'21:30:00','21:59:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (264,'21:55:00','21:59:59',88,'21:45:00','21:59:59',44,'21:30:00','21:59:59',35,'21:30:00','21:59:59',22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (265,'22:00:00','22:04:59',89,'22:00:00','22:14:59',45,'22:00:00','22:29:59',36,'22:00:00','22:29:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (266,'22:05:00','22:09:59',89,'22:00:00','22:14:59',45,'22:00:00','22:29:59',36,'22:00:00','22:29:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (267,'22:10:00','22:14:59',89,'22:00:00','22:14:59',45,'22:00:00','22:29:59',36,'22:00:00','22:29:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (268,'22:15:00','22:19:59',90,'22:15:00','22:29:59',45,'22:00:00','22:29:59',36,'22:00:00','22:29:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (269,'22:20:00','22:24:59',90,'22:15:00','22:29:59',45,'22:00:00','22:29:59',36,'22:00:00','22:29:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (270,'22:25:00','22:29:59',90,'22:15:00','22:29:59',45,'22:00:00','22:29:59',36,'22:00:00','22:29:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (271,'22:30:00','22:34:59',91,'22:30:00','22:44:59',46,'22:30:00','22:59:59',37,'22:30:00','22:59:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (272,'22:35:00','22:39:59',91,'22:30:00','22:44:59',46,'22:30:00','22:59:59',37,'22:30:00','22:59:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (273,'22:40:00','22:44:59',91,'22:30:00','22:44:59',46,'22:30:00','22:59:59',37,'22:30:00','22:59:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (274,'22:45:00','22:49:59',92,'22:45:00','22:59:59',46,'22:30:00','22:59:59',37,'22:30:00','22:59:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (275,'22:50:00','22:54:59',92,'22:45:00','22:59:59',46,'22:30:00','22:59:59',37,'22:30:00','22:59:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (276,'22:55:00','22:59:59',92,'22:45:00','22:59:59',46,'22:30:00','22:59:59',37,'22:30:00','22:59:59',23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (277,'23:00:00','23:04:59',93,'23:00:00','23:14:59',47,'23:00:00','23:29:59',38,'23:00:00','23:29:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (278,'23:05:00','23:09:59',93,'23:00:00','23:14:59',47,'23:00:00','23:29:59',38,'23:00:00','23:29:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (279,'23:10:00','23:14:59',93,'23:00:00','23:14:59',47,'23:00:00','23:29:59',38,'23:00:00','23:29:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (280,'23:15:00','23:19:59',94,'23:15:00','23:29:59',47,'23:00:00','23:29:59',38,'23:00:00','23:29:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (281,'23:20:00','23:24:59',94,'23:15:00','23:29:59',47,'23:00:00','23:29:59',38,'23:00:00','23:29:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (282,'23:25:00','23:29:59',94,'23:15:00','23:29:59',47,'23:00:00','23:29:59',38,'23:00:00','23:29:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (283,'23:30:00','23:34:59',95,'23:30:00','23:44:59',48,'23:30:00','23:59:59',39,'23:30:00','23:59:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (284,'23:35:00','23:39:59',95,'23:30:00','23:44:59',48,'23:30:00','23:59:59',39,'23:30:00','23:59:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (285,'23:40:00','23:44:59',95,'23:30:00','23:44:59',48,'23:30:00','23:59:59',39,'23:30:00','23:59:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (286,'23:45:00','23:49:59',96,'23:45:00','23:59:59',48,'23:30:00','23:59:59',39,'23:30:00','23:59:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (287,'23:50:00','23:54:59',96,'23:45:00','23:59:59',48,'23:30:00','23:59:59',39,'23:30:00','23:59:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (288,'23:55:00','23:59:59',96,'23:45:00','23:59:59',48,'23:30:00','23:59:59',39,'23:30:00','23:59:59',24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59')
GO


-- PeMS 60-minute time period cross-reference
CREATE TABLE [pems].[time_min60_xref] (
	[min60] tinyint NOT NULL,
	[min60_period_start] time NOT NULL,
	[min60_period_end] time NOT NULL,
	[abm_5_tod] tinyint NULL,
	[abm_5_tod_period_start] time NULL,
	[abm_5_tod_period_end] time NULL,
	[day] tinyint NOT NULL,
	[day_period_start] time NOT NULL,
	[day_period_end] time NOT NULL,
    INDEX [ccsi_pems_time_min60_xref] CLUSTERED COLUMNSTORE,
    CONSTRAINT [ixuq_pems_time_min60_xref] UNIQUE ([min60])
    )
INSERT INTO [pems].[time_min60_xref] VALUES
    (1,'00:00:00','00:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (2,'01:00:00','01:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (3,'02:00:00','02:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (4,'03:00:00','03:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (5,'04:00:00','04:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (6,'05:00:00','05:59:59',1,'03:00:00','05:59:59',1,'00:00:00','23:59:59'),
    (7,'06:00:00','06:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (8,'07:00:00','07:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (9,'08:00:00','08:59:59',2,'06:00:00','08:59:59',1,'00:00:00','23:59:59'),
    (10,'09:00:00','09:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (11,'10:00:00','10:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (12,'11:00:00','11:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (13,'12:00:00','12:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (14,'13:00:00','13:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (15,'14:00:00','14:59:59',3,'09:00:00','15:29:59',1,'00:00:00','23:59:59'),
    (16,'15:00:00','15:59:59',NULL,NULL,NULL,1,'00:00:00','23:59:59'),
    (17,'16:00:00','16:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (18,'17:00:00','17:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (19,'18:00:00','18:59:59',4,'15:30:00','18:59:59',1,'00:00:00','23:59:59'),
    (20,'19:00:00','19:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (21,'20:00:00','20:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (22,'21:00:00','21:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (23,'22:00:00','22:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59'),
    (24,'23:00:00','23:59:59',5,'19:00:00','02:59:59',1,'00:00:00','23:59:59')
GO




/*****************************************************************************/
-- create PeMS programmability objects

-- create function to provide Ns for each PeMS count station by year ---------
DROP FUNCTION IF EXISTS [pems].[fn_sample_size]
GO

CREATE FUNCTION [pems].[fn_sample_size] ()
RETURNS TABLE
AS
RETURN
/**
summary:   >
    Return table of each PeMS data-set station by year with the number
    of observations and percentage of observations provided over the year.
    For example, a count station providing daily counts for the year 2014
    with 300 records would show N = 300 and pct = 300/365.

    This table can be queried at the station level to show what data exists
    and how much coverage data-set has when creating yearly summary statistics.
**/
SELECT
    'Census V-Class Hour' AS [type]
    ,'hour' AS [temporal_resolution]
    ,YEAR([timestamp]) AS [year]
    ,[census_substation_identifier] AS [station]
    ,COUNT(*) AS [n]
    ,CONVERT(DECIMAL(4,1), ROUND(100.0 * COUNT(*) / (365 * 24), 1)) AS [pct]
FROM
    [pems].[census_vclass_hour]
GROUP BY
    YEAR([timestamp])
    ,[census_substation_identifier]

UNION ALL

SELECT
    'Station AADT Month Hour' AS [type]
    ,'hour' AS [temporal_resolution]
    ,YEAR([timestamp]) AS [year]
    ,[station]
    ,COUNT([number_of_days]) AS [n]
    ,CONVERT(DECIMAL(4,1), ROUND(100.0 * COUNT([number_of_days]) / (365 * 24), 1)) AS [pct]
FROM
    [pems].[station_aadt]
GROUP BY
    YEAR([timestamp])
    ,[station]

UNION ALL

SELECT
    'Station Day' AS [type]
    ,'day' AS [temporal_resolution]
    ,YEAR([timestamp]) AS [year]
    ,[station]
    ,COUNT(*) AS [n]
    ,CONVERT(DECIMAL(4,1), ROUND(100.0 * COUNT(*) / (365), 1)) AS [pct]
FROM
    [pems].[station_day]
GROUP BY
    YEAR([timestamp])
    ,[station]

UNION ALL

SELECT
    'Station 5-Minute' AS [type]
    ,'five minute' AS [temporal_resolution]
    ,YEAR([timestamp]) AS [year]
    ,[station]
    ,COUNT(*) AS [n]
    ,CONVERT(DECIMAL(4,1), ROUND(100.0 * COUNT(*) / (365 * 24 * 12), 1)) AS [pct]
FROM
    [pems].[station_five_minute]
GROUP BY
    YEAR([timestamp])
    ,[station]

UNION ALL

SELECT
    'Station Hour' AS [type]
    ,'hour' AS [temporal_resolution]
    ,YEAR([timestamp]) AS [year]
    ,[station]
    ,COUNT(*) AS [n]
    ,CONVERT(DECIMAL(4,1), ROUND(100.0 * COUNT(*) / (365 * 24), 1)) AS [pct]
FROM
    [pems].[station_hour]
GROUP BY
    YEAR([timestamp])
    ,[station]
GO




-- create table valued function to aggregate Station Day data-set ------------
DROP FUNCTION IF EXISTS [pems].[fn_agg_station_day]
GO

CREATE FUNCTION [pems].[fn_agg_station_day] ()
RETURNS TABLE
AS
/**
summary:   >
    Aggregates the PeMS Data Clearinghouse data-set:
        Type: Station Day
        District: 11
        SQL table: [pems].[station_day]

    Calculates the average daily traffic flow within each year and month of
    available data.

    Provides the average traffic flow weighted by the number of samples in the
    raw dataset used to calculate the traffic flow for each day. Also provided
    are the total number of days and total number of samples across all lanes
    for each day in the raw dataset used to calculate traffic flow within
    the given year, month, and station

    Weekends, holidays, and imputed values are removed from the aggregation.

    The result set can be further filtered or aggregated across year and month
    making sure to weight the mean by the number of observations [n] or the
    number of [samples] using the formulas:
        [meanN] = SUM([metric] * [n]) / SUM([n])
        [meanSamples] = SUM([metric] * [samples]) / SUM([samples])
    Similarly, the standard deviation can also be calculated using the
    formulas and above mean calculations:
        [stdDevN] = SQRT(SUM([metric]^2 * [n]) / SUM([n]) - [meanN]^2)
        [stdDevSamples] = SQRT(SUM([metric]^2 * [samples]) / SUM([samples]) - [meanSamples]^2)

revisions:
    - Gregor Schroeder; 3/11/2020; added standard deviation calculation
**/
RETURN
with [meanTbl] AS (
    SELECT
        DATENAME(YEAR, [timestamp]) AS [year]
        ,DATENAME(MONTH, [timestamp]) AS [month]
        ,[station]
        ,SUM(1.0 * [total_flow] * [samples]) / SUM([samples]) AS [mean]  -- average traffic flow weighted by number of samples used in computing each [total_flow]
    FROM
        [pems].[station_day]
    WHERE
        DATENAME(WEEKDAY, [timestamp]) NOT IN ('Saturday', 'Sunday')  -- remove weekends from the aggregation
        AND CONVERT(DATE, [timestamp]) NOT IN (SELECT [date] FROM [pems].[holiday])  -- remove holidays from the aggregation
        AND [samples] > 0  -- do not use imputed values
        AND [total_flow] IS NOT NULL  -- do not count records where metric was not measured
    GROUP BY
        DATENAME(YEAR, [timestamp])
        ,DATENAME(MONTH, [timestamp])
        ,[station])
SELECT
    [meanTbl].[year]
    ,[meanTbl].[month]
    ,[meanTbl].[station]
    ,[meanTbl].[mean] AS [metric]  -- sum( x * p(x) ) = u
    ,SQRT(SUM(POWER(1.0 * [total_flow], 2) * [samples]) / SUM([samples]) - POWER(1.0 * [meanTbl].[mean], 2))  AS [std_dev]  -- sum( x^2 * p(x) ) - u^2 = std_dev
    ,SUM(CASE WHEN [samples] = 0 THEN 0 ELSE 1 END) AS [n]  -- total number of days used in computing [total_flow] values that make up the average traffic flow
    ,SUM([samples]) AS [samples]  -- total number of [samples] received for all lanes across all days used to compute average traffic flow
FROM
    [pems].[station_day]
INNER JOIN
    [meanTbl]
ON
    DATENAME(YEAR, [station_day].[timestamp]) = [meanTbl].[year]
    AND DATENAME(MONTH, [station_day].[timestamp]) = [meanTbl].[month]
    AND [station_day].[station] = [meanTbl].[station]
WHERE
    DATENAME(WEEKDAY, [timestamp]) NOT IN ('Saturday', 'Sunday')  -- remove weekends from the aggregation
    AND CONVERT(DATE, [timestamp]) NOT IN (SELECT [date] FROM [pems].[holiday])  -- remove holidays from the aggregation
    AND [samples] > 0  -- do not use imputed values
    AND [total_flow] IS NOT NULL  -- do not count records where metric was not measured
GROUP BY
    [meanTbl].[year]
    ,[meanTbl].[month]
    ,[meanTbl].[station]
    ,[meanTbl].[mean]
GO




-- create stored procedure to aggregate Station AADT Month Hour data-set ------
DROP PROCEDURE IF EXISTS [pems].[sp_agg_station_aadt]
GO

CREATE PROCEDURE [pems].[sp_agg_station_aadt]
    @time_column nvarchar(max)  -- column in [pems].[time_min60_xref]
    -- table used to aggregate station aadt month hour data to user-specified
    -- temporal resolution
AS

/**
summary:   >
    Aggregates the PeMS Data Clearinghouse data-set:
        Type: Station AADT
        File: Station AADT Month Hour
        District: 11
        SQL table: [pems].[station_aadt]

    Calculates the average traffic flow within each year and month of
    available data at a user-specified time resolution. Note the data operates
    at the hour resolution so aggregation can only be done at the hour level
    or above.

    Provides the average traffic flow weighted by the number of days in the raw
    dataset used to calculate the traffic flow. Also provided are the total
    number of days in the raw dataset used to calculate traffic flow within
    the given year, month, day, station, and time resolution.

    Weekends are removed from the aggregation but one must trust CalTrans that
    holidays have been appropriately accounted for in these monthly estimates.

    The result set can be further filtered or aggregated across year and month
    making sure to weight the mean by the number of observations [n] using the
    formula:
        [mean] = SUM([mahw] * [n]) / SUM([n])

revisions:
	- Gregor Schroeder; 5/15/2020; added summation to user-input time periods
		for each day/date of data prior to taking the mean
		removed standard deviation calculation
**/

BEGIN
	-- ensure input time column exists in [pems].[time_min60_xref]
	-- stop execution if it does not and throw error
	IF EXISTS(SELECT [COLUMN_NAME] FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_SCHEMA] = 'pems' AND [TABLE_NAME] = 'time_min60_xref' AND [COLUMN_NAME] = @time_column)
    BEGIN
	    -- build dynamic SQL string
	    DECLARE @sql nvarchar(max) = '
			with [tbl_day] AS (
				SELECT
					DATENAME(YEAR, [timestamp]) AS [year]
					,DATEPART(MONTH, [timestamp]) AS [month_number]
					,DATENAME(MONTH, [timestamp]) AS [month]
					,[station]
					,[time_min60_xref].' + @time_column + '
					,SUM([mahw]) AS [mahw]  -- total average traffic flow
					,SUM([number_of_days]) AS [number_of_days]  -- number of days used in computing each [mahw]
				FROM
					[pems].[station_aadt]
				INNER JOIN
					[pems].[time_min60_xref]
				ON
					[station_aadt].[hour_of_day] + 1 = [time_min60_xref].[min60]
				WHERE
					[day_number] NOT IN (0, 6)  -- remove weekends from the aggregation
					AND [number_of_days] > 0  -- only use records with observations
					AND [mahw] IS NOT NULL  -- remove records where metric is unobserved
				GROUP BY
					CONVERT(DATE, [timestamp])
					,DATENAME(YEAR, [timestamp])
					,DATEPART(MONTH, [timestamp])
					,DATENAME(MONTH, [timestamp])
					,[station]
					,[time_min60_xref].' + @time_column + ')
			SELECT
				[year]
				,[month]
				,[station]
				,' + @time_column + '
				,SUM(CONVERT(float, [mahw]) * [number_of_days]) / SUM([number_of_days]) AS [mean]  -- average traffic flow weighted by number of days used in computing each [mahw]
				,SUM([number_of_days]) AS [n]  -- total number of days used in computing [mahw] values that make up the average traffic flow
			FROM
				[tbl_day]
			GROUP BY
				[year]
				,[month_number]
				,[month]
				,[station]
				,' + @time_column

        -- execute dynamic SQL string
	    EXECUTE (@sql)
    END
    ELSE
    BEGIN
        RAISERROR ('The column %s does not exist in the [pems].[time_min60_xref] table.', 16, 1, @time_column)
    END

END
GO




-- create table valued function to aggregate total flow ----------------------
-- for the Station 5 Minute data-set
DROP PROCEDURE  IF EXISTS [pems].[sp_agg_station_five_minute_flow]
GO

CREATE PROCEDURE [pems].[sp_agg_station_five_minute_flow]
    @time_column nvarchar(max),  -- column in [pems].[time_min5_xref]
    -- table used to aggregate station hour data to user-specified
    -- temporal resolution
    @year_filter integer -- year of data to calculate metric for
AS
/**
summary:   >
    Aggregates the PeMS Data Clearinghouse data-set:
        Type: Station 5 Minute
        District: 11
        SQL table: [pems].[station_five_minute]
    Calculates the average traffic flow within each month of
    available data for a user-specified year at a user-specified time
    resolution. Note the data operates at the five minute resolution so
    aggregation can only be done at the five minute level or above.

	Data is first aggregated to user-specified time periods within each day.
	Days without full coverage (all five minute time periods present with
	[samples] > 0 and [total_flow] IS NOT NULL) are removed from
	consideration. Days are then aggregated within each month at the
	user-specified time resolution weighted by the number of samples present
	in each day.

    Provides the average traffic flow weighted by the number of
    samples in the raw dataset used to calculate the average traffic flow for
	each user-specified time resolution period.
    Also provided are the total number of records and total number of samples
    across all lanes for each day in the raw dataset used to calculate the
    average traffic flow within the given year, month, station, and
	user-specified time resolution period.

    Weekends, holidays, and imputed values are removed from the aggregation.
    The result set can be further filtered or aggregated across month
    and user-specified time resolution periods making sure to weight by the
    number of observations [n] or the number of [samples] using the formulas:
        [total_flow] = SUM([total_flow] * [n]) / SUM([n])
        [total_flow] = SUM([total_flow] * [samples]) / SUM([samples])
revisions:
	- Gregor Schroeder; 5/15/2020; added summation to user-input time periods
		for each day/date of data prior to taking the mean
**/
BEGIN
    IF NOT EXISTS(SELECT [COLUMN_NAME] FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_SCHEMA] = 'pems' AND [TABLE_NAME] = 'time_min5_xref' AND [COLUMN_NAME] = @time_column)
    BEGIN
        RAISERROR ('The column %s does not exist in the [pems].[time_min5_xref] table.', 16, 1, @time_column)
    END
    ELSE
    BEGIN
		-- build dynamic SQL string
		DECLARE @sql nvarchar(max) = '
		with [tbl_day] AS (
			SELECT
				CONVERT(DATE, [timestamp]) AS [date]
				,DATEPART(MONTH, [timestamp]) AS [month_number]
				,DATENAME(MONTH, [timestamp]) AS [month]
				,[station]
				,[time_min5_xref].' + @time_column + '
				,SUM([total_flow]) AS [total_flow]  -- total flow aggregated to time periods of interest within the day
				,SUM(CASE WHEN [samples] = 0 THEN 0 ELSE 1 END) AS [n]  -- total number of records aggregated to time periods of interest within the day
				,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records aggregated to time periods of interest within the day
			FROM
				[pems].[station_five_minute]
			INNER JOIN
				[pems].[time_min5_xref]
			ON
				CONVERT(TIME, [station_five_minute].[timestamp]) = [time_min5_xref].[min5_period_start]
			WHERE
				DATENAME(WEEKDAY, [timestamp]) NOT IN (''Saturday'', ''Sunday'')  -- remove weekends from the aggregation
				AND CONVERT(DATE, [timestamp]) NOT IN (SELECT [date] FROM [pems].[holiday])  -- remove holidays from the aggregation
				AND [samples] > 0  -- do not use imputed values
				AND [total_flow] IS NOT NULL  -- do not count records where total flow was not measured
				AND DATENAME(YEAR, [timestamp]) = ' + CONVERT(nvarchar, @year_filter) + '
			GROUP BY
				CONVERT(DATE, [timestamp])
				,DATEPART(MONTH, [timestamp])
				,DATENAME(MONTH, [timestamp])
				,[station]
				,[time_min5_xref].' + @time_column + '),
		[records_check] AS (
			SELECT
				' + @time_column + '
				,COUNT([min5]) AS [n]
			FROM
				[pems].[time_min5_xref]
			GROUP BY
				' + @time_column + ')
		SELECT
			' + CONVERT(nvarchar, @year_filter) + ' AS [year]
			,[month]
			,[station]
			,[tbl_day].' + @time_column + '
			,SUM(1.0 * [total_flow] * [samples]) / SUM([samples]) AS [total_flow]  -- total flow weighted by number of samples used in computing each record
			,SUM([tbl_day].[n]) AS [n]  -- total number of records used in computing total flow values that make up the average total flow
			,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records used to compute average total flow
		FROM
			[tbl_day]
		INNER JOIN  -- only use records within each day that have full datasets
			[records_check]
		ON
			[tbl_day].' + @time_column + ' = [records_check].' + @time_column + '
			AND [tbl_day].[n] = [records_check].[n]
		GROUP BY
			[month_number]
			,[month]
			,[station]
			,[tbl_day].' + @time_column

        -- execute dynamic SQL string
	    EXECUTE (@sql)
    END
END
GO




-- create table valued function to aggregate average speed -------------------
-- for the Station 5 Minute data-set
DROP PROCEDURE  IF EXISTS [pems].[sp_agg_station_five_minute_speed]
GO

CREATE PROCEDURE [pems].[sp_agg_station_five_minute_speed]
    @time_column nvarchar(max),  -- column in [pems].[time_min5_xref]
    -- table used to aggregate station hour data to user-specified
    -- temporal resolution
    @year_filter integer -- year of data to calculate metric for
AS
/**
summary:   >
    Aggregates the PeMS Data Clearinghouse data-set:
        Type: Station 5 Minute
        District: 11
        SQL table: [pems].[station_five_minute]
    Calculates the average speed within each month of available data for a
	user-specified year at a user-specified time resolution. Note the data
	operates at the five minute resolution so aggregation can only be done at
	the five minute level or above.

	Data is first aggregated to user-specified time periods within each day.
	Days without full coverage (all five minute time periods present with
	[samples] > 0 and [average_speed] IS NOT NULL) are removed from
	consideration. Days are then aggregated within each month at the
	user-specified time resolution weighted by the number of samples present
	in each day.

    Provides the average speed weighted by the number of samples in the raw
	dataset used to calculate the average speed for each user-specified time
	resolution period.
    Also provided are the total number of records and total number of samples
    across all lanes for each day in the raw dataset used to calculate the
    average speed within the given year, month, station, and user-specified
	time resolution period.

    Weekends, holidays, and imputed values are removed from the aggregation.
    The result set can be further filtered or aggregated across month
    and user-specified time resolution periods making sure to weight by the
    number of observations [n] or the number of [samples] using the formulas:
        [average_speed] = SUM([average_speed] * [n]) / SUM([n])
        [average_speed] = SUM([average_speed] * [samples]) / SUM([samples])
revisions:
	- Gregor Schroeder; 5/15/2020; added summation to user-input time periods
		for each day/date of data prior to taking the mean
**/
BEGIN
    IF NOT EXISTS(SELECT [COLUMN_NAME] FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_SCHEMA] = 'pems' AND [TABLE_NAME] = 'time_min5_xref' AND [COLUMN_NAME] = @time_column)
    BEGIN
        RAISERROR ('The column %s does not exist in the [pems].[time_min5_xref] table.', 16, 1, @time_column)
    END
    ELSE
    BEGIN
		-- build dynamic SQL string
		DECLARE @sql nvarchar(max) = '
		with [tbl_day] AS (
			SELECT
				CONVERT(DATE, [timestamp]) AS [date]
				,DATEPART(MONTH, [timestamp]) AS [month_number]
				,DATENAME(MONTH, [timestamp]) AS [month]
				,[station]
				,[time_min5_xref].' + @time_column + '
				,AVG([average_speed]) AS [average_speed]  -- average speed aggregated to time periods of interest within the day
				,SUM(CASE WHEN [samples] = 0 THEN 0 ELSE 1 END) AS [n]  -- total number of records aggregated to time periods of interest within the day
				,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records aggregated to time periods of interest within the day
			FROM
				[pems].[station_five_minute]
			INNER JOIN
				[pems].[time_min5_xref]
			ON
				CONVERT(TIME, [station_five_minute].[timestamp]) = [time_min5_xref].[min5_period_start]
			WHERE
				DATENAME(WEEKDAY, [timestamp]) NOT IN (''Saturday'', ''Sunday'')  -- remove weekends from the aggregation
				AND CONVERT(DATE, [timestamp]) NOT IN (SELECT [date] FROM [pems].[holiday])  -- remove holidays from the aggregation
				AND [samples] > 0  -- do not use imputed values
				AND [average_speed] IS NOT NULL  -- do not count records where average speed was not measured
				AND DATENAME(YEAR, [timestamp]) = ' + CONVERT(nvarchar, @year_filter) + '
			GROUP BY
				CONVERT(DATE, [timestamp])
				,DATEPART(MONTH, [timestamp])
				,DATENAME(MONTH, [timestamp])
				,[station]
				,[time_min5_xref].' + @time_column + '),
		[records_check] AS (
			SELECT
				' + @time_column + '
				,COUNT([min5]) AS [n]
			FROM
				[pems].[time_min5_xref]
			GROUP BY
				' + @time_column + ')
		SELECT
			' + CONVERT(nvarchar, @year_filter) + ' AS [year]
			,[month]
			,[station]
			,[tbl_day].' + @time_column + '
			,SUM(1.0 * [average_speed] * [samples]) / SUM([samples]) AS [average_speed]  -- average speed weighted by number of samples used in computing each record
			,SUM([tbl_day].[n]) AS [n]  -- total number of records used in computing average speed values that make up the average speed
			,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records used to compute average speed
		FROM
			[tbl_day]
		INNER JOIN  -- only use records within each day that have full datasets
			[records_check]
		ON
			[tbl_day].' + @time_column + ' = [records_check].' + @time_column + '
			AND [tbl_day].[n] = [records_check].[n]
		GROUP BY
			[month_number]
			,[month]
			,[station]
			,[tbl_day].' + @time_column

        -- execute dynamic SQL string
	    EXECUTE (@sql)
    END
END
GO




-- create table valued function to aggregate total flow ----------------------
-- for the Station Hour data-set
DROP PROCEDURE  IF EXISTS [pems].[sp_agg_station_hour_flow]
GO

CREATE PROCEDURE [pems].[sp_agg_station_hour_flow]
    @time_column nvarchar(30),  -- column in [pems].[time_min60_xref]
    -- table used to aggregate station hour data to user-specified
    -- temporal resolution
    @year_filter integer -- year of data to calculate metric for
AS
/**
summary:   >
    Aggregates the PeMS Data Clearinghouse data-set:
        Type: Station Hour
        District: 11
        SQL table: [pems].[station_hour]
    Calculates the average traffic flow within each month of
    available data for a user-specified year at a user-specified time
    resolution. Note the data operates at the hour resolution so
    aggregation can only be done at the hour level or above.

	Data is first aggregated to user-specified time periods within each day.
	Days without full coverage (all five minute time periods present with
	[samples] > 0 and [total_flow] IS NOT NULL) are removed from
	consideration. Days are then aggregated within each month at the
	user-specified time resolution weighted by the number of samples present
	in each day.

    Provides the average traffic flow weighted by the number of
    samples in the raw dataset used to calculate the average traffic flow for
	each user-specified time resolution period.
    Also provided are the total number of records and total number of samples
    across all lanes for each day in the raw dataset used to calculate the
    average traffic flow within the given year, month, station, and
	user-specified time resolution period.

    Weekends, holidays, and imputed values are removed from the aggregation.
    The result set can be further filtered or aggregated across month
    and user-specified time resolution periods making sure to weight by the
    number of observations [n] or the number of [samples] using the formulas:
        [total_flow] = SUM([total_flow] * [n]) / SUM([n])
        [total_flow] = SUM([total_flow] * [samples]) / SUM([samples])
revisions:
	- Gregor Schroeder; 5/15/2020; added summation to user-input time periods
		for each day/date of data prior to taking the mean
**/
BEGIN
    IF NOT EXISTS(SELECT [COLUMN_NAME] FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_SCHEMA] = 'pems' AND [TABLE_NAME] = 'time_min60_xref' AND [COLUMN_NAME] = @time_column)
    BEGIN
        RAISERROR ('The column %s does not exist in the [pems].[time_min60_xref] table.', 16, 1, @time_column)
    END
    ELSE
    BEGIN
		-- build dynamic SQL string
		DECLARE @sql nvarchar(max) = '
		with [tbl_day] AS (
			SELECT
				CONVERT(DATE, [timestamp]) AS [date]
				,DATEPART(MONTH, [timestamp]) AS [month_number]
				,DATENAME(MONTH, [timestamp]) AS [month]
				,[station]
				,[time_min60_xref].' + @time_column + '
				,SUM([total_flow]) AS [total_flow]  -- total flow aggregated to time periods of interest within the day
				,SUM(CASE WHEN [samples] = 0 THEN 0 ELSE 1 END) AS [n]  -- total number of records aggregated to time periods of interest within the day
				,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records aggregated to time periods of interest within the day
			FROM
				[pems].[station_hour]
			INNER JOIN
				[pems].[time_min60_xref]
			ON
				DATEPART(HOUR, [station_hour].[timestamp]) + 1 = [time_min60_xref].[min60]
			WHERE
				DATENAME(WEEKDAY, [timestamp]) NOT IN (''Saturday'', ''Sunday'')  -- remove weekends from the aggregation
				AND CONVERT(DATE, [timestamp]) NOT IN (SELECT [date] FROM [pems].[holiday])  -- remove holidays from the aggregation
				AND [samples] > 0  -- do not use imputed values
				AND [total_flow] IS NOT NULL  -- do not count records where total flow was not measured
				AND DATENAME(YEAR, [timestamp]) = ' + CONVERT(nvarchar, @year_filter) + '
			GROUP BY
				CONVERT(DATE, [timestamp])
				,DATEPART(MONTH, [timestamp])
				,DATENAME(MONTH, [timestamp])
				,[station]
				,[time_min60_xref].' + @time_column + '),
		[records_check] AS (
			SELECT
				' + @time_column + '
				,COUNT([min60]) AS [n]
			FROM
				[pems].[time_min60_xref]
			GROUP BY
				' + @time_column + ')
		SELECT
			' + CONVERT(nvarchar, @year_filter) + ' AS [year]
			,[month]
			,[station]
			,[tbl_day].' + @time_column + '
			,SUM(1.0 * [total_flow] * [samples]) / SUM([samples]) AS [total_flow]  -- total flow weighted by number of samples used in computing each record
			,SUM([tbl_day].[n]) AS [n]  -- total number of records used in computing total flow values that make up the average flow
			,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records used to compute average flow
		FROM
			[tbl_day]
		INNER JOIN  -- only use records within each day that have full datasets
			[records_check]
		ON
			[tbl_day].' + @time_column + ' = [records_check].' + @time_column + '
			AND [tbl_day].[n] = [records_check].[n]
		GROUP BY
			[month_number]
			,[month]
			,[station]
			,[tbl_day].' + @time_column

		-- execute dynamic SQL string
		EXECUTE (@sql)
    END
END
GO




-- create table valued function to aggregate average speed -------------------
-- for the Station Hour data-set
DROP PROCEDURE  IF EXISTS [pems].[sp_agg_station_hour_speed]
GO

CREATE PROCEDURE [pems].[sp_agg_station_hour_speed]
    @time_column nvarchar(30),  -- column in [pems].[time_min60_xref]
    -- table used to aggregate station hour data to user-specified
    -- temporal resolution
    @year_filter integer -- year of data to calculate metric for
AS
/**
summary:   >
    Aggregates the PeMS Data Clearinghouse data-set:
        Type: Station Hour
        District: 11
        SQL table: [pems].[station_hour]
    Calculates the average speed within each month of available data for a
	user-specified year at a user-specified time resolution. Note the data
	operates at the hour resolution so aggregation can only be done at
	the hour level or above.

	Data is first aggregated to user-specified time periods within each day.
	Days without full coverage (all five minute time periods present with
	[samples] > 0 and [average_speed] IS NOT NULL) are removed from
	consideration. Days are then aggregated within each month at the
	user-specified time resolution weighted by the number of samples present
	in each day.

    Provides the average speed weighted by the number of samples in the raw
	dataset used to calculate the average speed for each user-specified time
	resolution period.
    Also provided are the total number of records and total number of samples
    across all lanes for each day in the raw dataset used to calculate the
    average speed within the given year, month, station, and user-specified
	time resolution period.

    Weekends, holidays, and imputed values are removed from the aggregation.
    The result set can be further filtered or aggregated across month
    and user-specified time resolution periods making sure to weight by the
    number of observations [n] or the number of [samples] using the formulas:
        [average_speed] = SUM([average_speed] * [n]) / SUM([n])
        [average_speed] = SUM([average_speed] * [samples]) / SUM([samples])
revisions:
	- Gregor Schroeder; 5/15/2020; added summation to user-input time periods
		for each day/date of data prior to taking the mean
**/
BEGIN
    IF NOT EXISTS(SELECT [COLUMN_NAME] FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_SCHEMA] = 'pems' AND [TABLE_NAME] = 'time_min60_xref' AND [COLUMN_NAME] = @time_column)
    BEGIN
        RAISERROR ('The column %s does not exist in the [pems].[time_min60_xref] table.', 16, 1, @time_column)
    END
    ELSE
    BEGIN
		-- build dynamic SQL string
		DECLARE @sql nvarchar(max) = '
		with [tbl_day] AS (
			SELECT
				CONVERT(DATE, [timestamp]) AS [date]
				,DATEPART(MONTH, [timestamp]) AS [month_number]
				,DATENAME(MONTH, [timestamp]) AS [month]
				,[station]
				,[time_min60_xref].' + @time_column + '
				,AVG([average_speed]) AS [average_speed]  -- average speed aggregated to time periods of interest within the day
				,SUM(CASE WHEN [samples] = 0 THEN 0 ELSE 1 END) AS [n]  -- total number of records aggregated to time periods of interest within the day
				,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records aggregated to time periods of interest within the day
			FROM
				[pems].[station_hour]
			INNER JOIN
				[pems].[time_min60_xref]
			ON
				DATEPART(HOUR, [station_hour].[timestamp]) + 1 = [time_min60_xref].[min60]
			WHERE
				DATENAME(WEEKDAY, [timestamp]) NOT IN (''Saturday'', ''Sunday'')  -- remove weekends from the aggregation
				AND CONVERT(DATE, [timestamp]) NOT IN (SELECT [date] FROM [pems].[holiday])  -- remove holidays from the aggregation
				AND [samples] > 0  -- do not use imputed values
				AND [average_speed] IS NOT NULL  -- do not count records where average speed was not measured
				AND DATENAME(YEAR, [timestamp]) = ' + CONVERT(nvarchar, @year_filter) + '
			GROUP BY
				CONVERT(DATE, [timestamp])
				,DATEPART(MONTH, [timestamp])
				,DATENAME(MONTH, [timestamp])
				,[station]
				,[time_min60_xref].' + @time_column + '),
		[records_check] AS (
			SELECT
				' + @time_column + '
				,COUNT([min60]) AS [n]
			FROM
				[pems].[time_min60_xref]
			GROUP BY
				' + @time_column + ')
		SELECT
			' + CONVERT(nvarchar, @year_filter) + ' AS [year]
			,[month]
			,[station]
			,[tbl_day].' + @time_column + '
			,SUM(1.0 * [average_speed] * [samples]) / SUM([samples]) AS [average_speed]  -- average speed weighted by number of samples used in computing each record
			,SUM([tbl_day].[n]) AS [n]  -- total number of records used in computing average speed values that make up the average speed
			,SUM([samples]) AS [samples]  -- total number of samples received for all lanes across all records used to compute average speed
		FROM
			[tbl_day]
		INNER JOIN  -- only use records within each day that have full datasets
			[records_check]
		ON
			[tbl_day].' + @time_column + ' = [records_check].' + @time_column + '
			AND [tbl_day].[n] = [records_check].[n]
		GROUP BY
			[month_number]
			,[month]
			,[station]
			,[tbl_day].' + @time_column

		-- execute dynamic SQL string
		EXECUTE (@sql)
    END
END
GO
