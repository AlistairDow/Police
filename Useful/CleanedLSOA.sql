USE [Police]
GO

if object_id('Crime.[CrimeClense]') is not null
 begin
	drop table Crime.[CrimeClense]
end

SELECT 
       [Month]
      ,[Reported by]
      ,[Falls within]
      ,[Longitude]
      ,[Latitude]
      ,[Location]
      ,[LSOA code]
      ,[LSOA name]
      ,[Crime type]
      ,[Last outcome category]
      ,[Context]
into Crime.[CrimeClense]
  FROM [Crime].[Street]
GO
/*This create a table without the CrimeID from our original document*/
ALTER TABLE [Crime].[CrimeClense] ADD CrimeID int identity(1,1) not null
GO
/*This creates a unique key which will allow me to refer to each column*/
if object_id('Crime.[EmpMatchLSOA]') is not null
 begin
	drop table [Crime].[EmpMatchLSOA]
end

select distinct e.CrimeID,
e.[Latitude], 
e.[Longitude], 
e.[Reported by], 
e.[Location], 
e.[LSOA Code] [ELSOA Code],
e.[LSOA NAME] [ELSOA Name], 
s.[LSOA Code], 
s.[LSOA NAME]
into [Crime].[EmpMatchLSOA]
from Crime.[CrimeClense] e
	inner join Crime.[CrimeClense] s
	on e.[Latitude]=s.[Latitude] and e.[Longitude]=s.[Longitude]
where 1=1
and s.[LSOA Code] != '' and e.[LSOA code] =''

/*This create a table which has Empty LSOA code and Name in [CrimeClense] but the table has a matching Longitude and Latitude in the table which has a complete LSOA Code*/

begin tran
go

update c
set c.[LSOA name]=e.[LSOA NAME]
from Crime.CrimeClense c
inner join [Crime].[EmpMatchLSOA]  e
	on c.CrimeID=e.CrimeID

update c
set c.[LSOA code]=e.[LSOA Code] 
from Crime.CrimeClense c
inner join [Crime].[EmpMatchLSOA]  e
	on c.CrimeID=e.CrimeID



/*
This updates our CrimeClense table adding to empty LSOA codes and Names which we found in [Crime].[EmpMatchLSOA]
select * from Crime.[CrimeClense] where CrimeID in (6263489, 6436883, 7719966, 7794869) random sample check
*/

commit tran

begin tran
 update Crime.[CrimeClense]
set [LSOA Code] = [LSOA NAME]
where [LSOA NAME] in ('E01002460'
,'E01002537'
,'E01025624'
,'E01025673'
,'E01025734'
,'E01025766'
,'E01028009'
,'E01031790')
go

update [Crime].[CrimeClense]
set [LSOA NAME] = [Crime type]
where [LSOA NAME] in ('E01002460'
,'E01002537'
,'E01025624'
,'E01025673'
,'E01025734'
,'E01025766'
,'E01028009'
,'E01031790')

/*
The above was after noting that we have some LSOA codes in the LSOA Name column and some LSOA Name in the [Crime type] column

select * from Crime.CrimeClense where 
 [LSOA NAME] in ('E01002460'
,'E01002537'
,'E01025624'
,'E01025673'
,'E01025734'
,'E01025766'
,'E01028009'
,'E01031790')
*/
commit tran



select
CrimeID
,[Month]
,[Reported by]
,[Falls within]
,[LSOA code]
,[LSOA name]
,[Crime type]
into [Crime].[CleanedStreet]
 FROM [Crime].[CrimeClense]
 where [LSOA code] != ''
 /*Finally this is where we remove all the Empty LSOA code as we know they are going to be key for joining to other tables*/

 /*
 45262469 rows
-- drop table dbo.TempT1
-- select 
--  c.[LSOA code]
--  ,c.CrimeID
--  ,c.[Reported by]
--  ,c.[Month]
--  ,count(c.CrimeID) over (partition by c.[Month]) EngMonthCrime
--into TempT1
--FROM [Crime].[CrimeClense] c
--where c.[LSOA code] in ( 
--select distinct [Lower Super Output Area Code] from [Sport].[Geographic]) 
 
select Count(CrimeID) [CLSOAM]
,[LSOA code]
,[Month]
,EngMonthCrime
into TempT2c
from TempT1
group by [LSOA code], [Month], EngMonthCrime

select Count(CrimeID) [CLSOAM]
,[LSOA code]
,[Month]
into TempT2b
from TempT1
group by [Month], [LSOA code]



select 
	c.CrimeID
	,c.[Reported by]
	,[LSOA code]
into ReviewT1
FROM [Crime].[CrimeClense] c
where c.[LSOA code] not in ( 
select distinct [Lower Super Output Area Code] from [Sport].[Geographic]) 

select * from ReviewT1

select distinct [Falls within] FROM [Crime].[CrimeClense]


      ,[LSOA code]
      ,[LSOA name]
      ,[Crime type]
      ,[Last outcome category]
      ,[Context]
      ,[CrimeID]*/