drop table [Crime].[CleanedStreet]
select
CrimeID
,[Month]
,[Reported by]
,[Falls within]
,[Longitude]
,[Latitude]
,[Location]
,[LSOA code]
,[LSOA name]
,[Crime type]
,nullif([Last outcome category], '') [LastOutCat]
,nullif([Context], '') [Cont]
into [Crime].[CleanedStreet]
 FROM [Crime].[CrimeClense]
 where [LSOA code] != ''

 ALTER TABLE [Crime].[MonthData] ADD MonthID int identity(1,1) not null
GO

 select 
 distinct
 [Month] Mnth
 into [Crime].[MonthData]
 from [Crime].[CleanedStreet]

ALTER TABLE [Crime].[MonthData] ADD MonthID int identity(1,1) not null
GO



 select distinct
 [Reported by]
,[Falls within]
into Crime.PoliceForce
from Crime.[CleanedStreet]

ALTER TABLE Crime.PoliceForce ADD PoliceID int identity(1,1) not null
GO

select * from Crime.PoliceForce


select distinct
[Longitude]
,[Latitude]
,[Location]
into Crime.Location
from 
Crime.[CleanedStreet]
 
ALTER TABLE Crime.Location ADD LocationID int identity(1,1) not null
GO

select distinct 