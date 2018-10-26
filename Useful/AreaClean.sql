use police

if object_id('Area.TempNamed') is not null
 begin
	drop table Area.TempNamed
end
 

select [Area Codes], [Area Names], [F3] LSOAnames,
case when substring([F3],1, 10)= 'Birmingham' and CHARINDEX('1',[F3])=12 or substring([F3],1, 5)= 'Leeds' and CHARINDEX('1',[F3])=7 then substring([F3],1,charindex('1',[F3])-2) /*Birmingham and Leeds are the only areas with LSOA identifiers which start with 1*/
when [F3] is not null or [F3] != '' then substring([F3],1,charindex('0',[F3])-2) /*Removing the numeric characters*/
else 'Total'
end [Place], [All Ages] 
into [Area].TempNamed
from Area.[Query]
/*This removes the identifier defining each specific LSOA in the overlying area (e.g. 001A)*/

if object_id('Area.PopTotal') is not null
 begin
	drop table Area.PopTotal
end
 
select * into Area.PopTotal from [Area].TempNamed where [Place]='Total' 
/*This creates a table of the area headers so we have the Total Population against the area name and is run before the below command */

if object_id('Area.AreaPop') is not null
 begin
	drop table Area.AreaPop
end
 
select c.[Area Codes], c.[Place], c.[All Ages] [Pop],
p.[All Ages] [TotalPop], c.[LSOAnames], p.[Area Codes] [PlaceLSOA]
into Area.AreaPop
from Area.TempNamed c
left join Area.PopTotal p
	on c.[Place]=p.[Area Names]
where c.[Area Names] is null
/*This joins our Area.PopTotal to our identifier free data creating a new table, we also create a ratio of the Population in an area against the average in an area */

begin tran

;with cte as(
select [Place], sum([Pop]) [Total2] from Area.AreaPop where [TotalPop] is null group by [Place] )

update a
set a.[TotalPop]=c.[Total2]
from Area.AreaPop a 
inner join cte c
	on a.[Place]=c.[Place]
where a.[TotalPop] is null

commit tran
/* This completes the [TotalPop] values set as we had a handful of values which were Null */
select distinct * from Area.AreaPop where Place='Rhondda, Cynon, Taff' or Place='Rhondda Cynon Taf'

begin tran
update Area.AreaPop
set 
Place='Rhondda Cynon Taf',
PlaceLSOA='W06000016'
where Place='Rhondda, Cynon, Taff'

commit tran

--select distinct Place, PlaceLSOA  from Area.AreaPop
--except
--select la_name, la_code from [Area].[PlaceLSOALU]
-- This provides only fields where the PlaceLSOA is null

begin tran
update a
set a.PlaceLSOA=p.la_code
from Area.AreaPop a
inner join [Area].[PlaceLSOALU] p
	on  a.Place=p.la_name

commit tran