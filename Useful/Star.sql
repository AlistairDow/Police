create schema Star

if object_id('Star.CrimeFact') is not null
 begin
	drop table Star.CrimeFact
end 
/*This is to remove the FK constraints to allow this to run on the existing table set*/
if object_id('Star.MonthData') is not null
 begin
	drop table Star.[MonthData]
end

 select 
 distinct
 [Month] Mnth
 into Star.[MonthData]
 from [Crime].[CleanedStreet]
 /*Creating a table of our Months from the Police Street data and adding its primary key*/
ALTER TABLE Star.[MonthData] ADD [MonthID] int identity(1,1) not null primary key
GO

if object_id('Star.PoliceForce') is not null
 begin
	drop table Star.PoliceForce
end

 select distinct
 [Reported by]
,[Falls within]
into Star.PoliceForce
from Crime.[CleanedStreet]
 /*Creating a table of our PoliceForces from the Police Street data and adding its primary key*/
ALTER TABLE Star.PoliceForce ADD PoliceID int identity(1,1) not null primary key
GO

if object_id('Star.SportFact') is not null
 begin
	drop table Star.SportFact
end 


if object_id('Star.PointLocation') is not null
 begin
	drop table Star.PointLocation
end

select distinct *
into Star.PointLocation
from(
select
[Longitude]
,[Latitude]
from 
Crime.[CleanedStreet]
union all
select
[Longitude]
,[Latitude]
from 
[Sport].[Geographic]) UN
  /*Creating a list of our Point data from the Police Street data and the sport data adding its primary key*/
ALTER TABLE Star.PointLocation ADD LocationID int identity(1,1) not null primary key
GO
/* This is our first table which is joining information between our data sets, we have point information on both Crime.[CleanedStreet] and Sport.Geographic which would best be contained in just one table */

if object_id('Star.CrimeType') is not null
 begin
	drop table Star.CrimeType
end

select distinct
[Crime type] CrimeType
into Star.CrimeType
from 
Crime.[CleanedStreet]
 /*Creating a table of all our crime data */
ALTER TABLE Star.CrimeType ADD CrimeTypeID int identity(1,1) not null primary key
GO

/*
;with cte as (
select c.[LSOA code], c.[LSOA name] from [Area].[AreaPop] a inner join crime.CleanedStreet c on a.[Area Codes]=c.[LSOA code])

select count(*) from cte = 45262438 
select count(*) from crime.CleanedStreet = 45262438
Because these counts are equal we dont need to create an table for ESOA Codes and ESOA Names for Crime as the can use the one we will create for Area*/

/*As above these are to remove the FK constraints to allow this to run on the existing table set*/
if object_id('Star.Deptab') is not null
 begin
	drop table Star.Deptab
end

if object_id('Star.Area') is not null
 begin
	drop table Star.Area
end
/
if object_id('Star.Place') is not null
 begin
	drop table Star.Place
end


select distinct
[Place]
,[TotalPop]
,[PlaceLSOA]
into Star.Place
from 
[Area].[AreaPop]
/*Creating Place and area tables which are linked to both the data sets*/
ALTER TABLE Star.Place ADD PlaceID int identity(1,1) not null primary key
GO

if object_id('Star.Area') is not null
 begin
	drop table Star.Area
end

SELECT a.[Area Codes] [LSOACodes]
      ,s.[PlaceID]
      ,a.[Pop] [PopinLSOA]
      ,a.[LSOAnames] [LSOANames]
into Star.Area
FROM [Area].[AreaPop] a
inner join Star.Place s
	on a.[Place]=s.[Place] and a.[TotalPop]=s.[TotalPop]

ALTER TABLE Star.Area ADD AreaID int identity(1,1) not null primary key
GO

if object_id('Star.CrimeFact') is not null
 begin
	drop table Star.CrimeFact
end 
/*This is creating the Fact table for our Crime data*/
 SELECT distinct [CrimeID]
      ,m.MonthID 
      ,p.PoliceID
      ,l.LocationID
      ,a.AreaID
      ,t.CrimeTypeID
into Star.CrimeFact
FROM [Crime].[CleanedStreet] c
inner join Star.[MonthData] m
	on c.[Month]=m.Mnth
inner join Star.PoliceForce p
	on c.[Falls within]=p.[Falls within] and c.[Reported by]=p.[Reported by]
inner join Star.PointLocation l
	on c.Longitude=l.[Longitude] and c.Latitude =l.Latitude
inner join Star.Area a
	on c.[LSOA Code]=a.[LSOACodes]
inner join Star.CrimeType t
	on c.[Crime type]=t.[CrimeType]


ALTER TABLE Star.CrimeFact ADD CFactID int identity(1,1) not null primary key
go

if object_id('Star.Sites') is not null
 begin
	drop table Star.Sites
end

select 
cast(isnull([SiteID],9999999) as int) [SiteID] /*This can be used in a join to the FACT table so I want to ensure there are no null values, 99999999 is representing unknown*/
,[SiteName]
into Star.Sites
from Sport.Sites

ALTER TABLE Star.Sites ADD SiteKeyID int identity(1,1) not null primary key
go


if object_id('Star.Facility') is not null
 begin
	drop table Star.Facility
end

select distinct
isnull([FACILITYID],99999999) [FacilityID]   /*99999999 is representing unknown*/
,cast(isnull([FacTypeID],999) as int) [FacTypeID] /*This is used in a join to the Facility table so I want to ensure there are no null values, 999 is representing unknown*/
,cast(isnull([FacSubTypeID],99999) as int) [FacSubTypeID] /*This is used in a join to the Facility table so I want to ensure there are no null values, 99999 is representing unknown*/
,cast(right(RecEndDate,4) as INT) [RecEndDate]
,OpeningDate
into Star.Facility
from 
[Sport].[Facilities]
where cast(right(RecEndDate,4) as INT) > 2010 or RecEndDate ='' 
/*This is reducing our sample size as we only want values after 2010*/

ALTER TABLE Star.Facility ADD FacilityKeyID int identity(1,1) not null primary key
GO

if object_id('Star.SportFact') is not null
 begin
	drop table Star.SportFact
end

select distinct
l.LocationID
,a.AreaID
,s.SiteKeyID
,f.FacilityKeyID
into Star.SportFact
from
[Sport].[Geographic] g
inner join [Star].[PointLocation] l
	on g.Longitude=l.[Longitude] and g.[Latitude]=l.[Latitude]
inner join [Star].Area a
	on g.[Lower Super Output Area Code]=a.[LSOACodes]
right join [Star].[Sites] s
	on g.[SiteID]= s.[SiteID]
right join Star.Facility f
	on g.[FACILITYID]=f.[FACILITYID]
 
ALTER TABLE Star.SportFact ADD SportFactID int identity(1,1) not null primary key
GO

if object_id('Star.FacilityType') is not null
 begin
	drop table Star.[FacilityType]
end

select distinct
cast(isnull([FacTypeID],999) as int) [FacTypeID] 
,[FacTypeDescription]
,[FacTypeDefinition]
into Star.[FacilityType]
from 
[Sport].[FacilityType]

ALTER TABLE Star.[FacilityType] Alter Column [FacTypeID] int not null 
go
ALTER TABLE Star.[FacilityType] ADD CONSTRAINT PK_FacilityType PRIMARY KEY ([FacTypeID])
go
/*This typeid is complete and unique so we can use it as a Primary Key*/

if object_id('Star.FacilitySubType') is not null
 begin
	drop table Star.[FacilitySubType]
end

select distinct
isnull([FacSubTypeID],99999) [FacSubTypeID]  /*This is used in a join to the Facility table so I want to ensure there are no null values, 99999 is representing unknown*/
,[FacSubTypeDescription]
,[FacSubTypeName]
into Star.[FacilitySubType]
from 
[Sport].[FacilitySubType]

ALTER TABLE Star.[FacilitySubType] Alter Column [FacSubTypeID] int not null 
go
ALTER TABLE Star.[FacilitySubType] ADD CONSTRAINT PK_FacilitySubType PRIMARY KEY ([FacSubTypeID])
go
/*This subtypeid is complete and unique so we can use it as a Primary Key*/



if object_id('Star.Deptab') is not null
 begin
	drop table Star.Deptab
end
/*Enriching our location and area data with Deprivation data*/
select 
a.[AreaID] /*Joining this to the area table*/
,isnull(d.[Index of Multiple Deprivation (IMD) Rank (where 1 is most depriv],99999) [DepRank] /*This value is not unique*/
,d.[Index of Multiple Deprivation (IMD) Decile (where 1 is most depr] [DepIndex]
,p.[PlaceID]/*Joining this to the place table*/
into Star.Deptab
from [Depriv].[CleanIMD] d
inner join [Star].[Area] a
	on d.[LSOA code (2011)]=a.[LSOACodes]
inner join [Star].[Place] p
	on  d.[LocalAuthName]=p.[Place]

ALTER TABLE Star.Deptab ADD DepID int identity(1,1) not null primary key
GO

/*Adding Foreign keys to link my tables together*/

ALTER table [Star].[CrimeFact]
Add constraint FK_CrimeArea foreign key (AreaID)
	References [Star].[Area] (AreaID)

ALTER table [Star].[CrimeFact]
Add constraint FK_CMonth foreign key (monthID)
	References [Star].[MonthData] (MonthID)
	
ALTER table [Star].[CrimeFact]
Add constraint FK_PoliceForce foreign key (PoliceID)
	References [Star].[PoliceForce] (PoliceID)

ALTER table [Star].[CrimeFact]
Add constraint FK_CrimePointLoc foreign key (LocationID)
	References [Star].[PointLocation] (LocationID)

ALTER table [Star].[CrimeFact]
Add constraint FK_CrimeType foreign key (CrimeTypeID)
	References [Star].[CrimeType] (CrimeTypeID)

Alter table [Star].[Area]
Add constraint FK_Place foreign key (PlaceID)
	References [Star].[Place] (PlaceID)

ALTER table [Star].[SportFact]
Add constraint FK_SportArea foreign key (AreaID)
	References [Star].[Area] (AreaID)
	
ALTER table [Star].[SportFact]
Add constraint FK_SportPointLoc foreign key (LocationID)
	References [Star].[PointLocation] (LocationID)
		
ALTER table [Star].[SportFact]
Add constraint FK_SportSite foreign key (SiteKeyID)
	References [Star].[Sites] (SiteKeyID)

	ALTER table [Star].[SportFact]
Add constraint FK_Facility foreign key (FacilityKeyID)
	References [Star].[Facility] (FacilityKeyID)	

ALTER table [Star].[Facility]
Add constraint FK_FacilitySubType foreign key (FacSubTypeID)
	References [Star].[FacilitySubType] (FacSubTypeID)	

ALTER table [Star].[Facility]
Add constraint FK_FacilityType foreign key (FacTypeID)
	References [Star].[FacilityType] (FacTypeID)	

Alter table Star.Deptab
Add constraint FK_DepArea foreign key ([AreaID])
	References [Star].Area ([AreaID])	

Alter table Star.Deptab
Add constraint FK_DepPlace foreign key ([PlaceID])
	References [Star].[Place] ([PlaceID])	