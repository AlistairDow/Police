select top 10 
[LSOA name], 
[Month], 
--[Crime type], 
Count([Crime ID]) Ccount, 
sum(case	
	when [Last outcome category] is not null then 1
	else 0
end) [LOcount]
from [Crime].[Street] 
group by [Month], [LSOA NAME]

select * from [Crime].[Street] where 1=2

select  from 

select distinct [Reported by], [LSOA Code], [LSOA NAME], [Crime type] from [Crime].[Street] where [LSOA NAME] in ('E01002460'
,'E01002537'
,'E01025624'
,'E01025673'
,'E01025734'
,'E01025766'
,'E01028009'
,'E01031790')
order by [LSOA NAME]

select distinct [Latitude], [Longitude], [Reported by], [Location], [LSOA Code], [LSOA NAME] into [Crime].[EmpLSOA] from [Crime].[Street] where [LSOA NAME] = ''


drop table [Crime].[EmpMatchLSOA]
select distinct e.[Latitude], 
e.[Longitude], 
e.[Reported by], 
e.[Location], 
e.[LSOA Code] [ELSOA Code],
e.[LSOA NAME] [ELSOA Name], 
s.[LSOA Code], 
s.[LSOA NAME]
into [Crime].[EmpMatchLSOA]
from [Crime].[EmpLSOA] e
	inner join [Crime].[Street] s
	on e.[Latitude]=s.[Latitude] and e.[Longitude]=s.[Longitude]
where 1=1
and s.[LSOA Code] != ''


select rank() over (partition by [Location] order by [LSOA Name]), *  from [Crime].[EmpMatchLSOA] 




begin tran
go

update [Crime].[Street]
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

update [Crime].[Street]
set [LSOA NAME] = [Crime type]
where [LSOA NAME] in ('E01002460'
,'E01002537'
,'E01025624'
,'E01025673'
,'E01025734'
,'E01025766'
,'E01028009'
,'E01031790')
rollback tran

select distinct [Month] from [Crime].[Street] 