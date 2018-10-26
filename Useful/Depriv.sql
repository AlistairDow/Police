

drop table [Depriv].['IMD2015']

select * from [Depriv].[IMD]

select count([LSOA code (2011)]) from [Depriv].[IMD]

if object_id('Star.Deptab') is not null
 begin
	drop table Star.Deptab
end

select 
a.[AreaID]
,isnull(d.[Index of Multiple Deprivation (IMD) Rank (where 1 is most depriv],99999) [DepRank]
,d.[Index of Multiple Deprivation (IMD) Decile (where 1 is most depr] [DepIndex]
,p.[PlaceID]
into Star.Deptab
from [Depriv].[CleanIMD] d
inner join [Star].[Area] a
	on d.[LSOA code (2011)]=a.[LSOACodes]
inner join [Star].[Place] p
	on  d.[LocalAuthName]=p.[Place]

ALTER TABLE Star.Deptab Alter Column [DepRank] int not null
go
ALTER TABLE Star.Deptab ADD CONSTRAINT PK_DepRank PRIMARY KEY ([DepRank]);
go




select top 10 * from [Depriv].[IMD]



	select * from cte where [Place] is not null



