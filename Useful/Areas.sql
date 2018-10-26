ALTER SCHEMA Area 
    TRANSFER dbo.Query

select top 10 * from Area.[Query] 

--select count(*) from Area.[Query] where [Area Names] is null 34753
;with cte as(
select [Area Codes], [Area Names], 
case when substring([F3],1, 10)= 'Birmingham' and CHARINDEX('1',[F3])=12 or substring([F3],1, 5)= 'Leeds' and CHARINDEX('1',[F3])=7 then substring([F3],1,charindex('1',[F3])-2)
when [F3] is not null or [F3] != '' then substring([F3],1,charindex('0',[F3])-2)
else 'Total'
end [Place], [All Ages] from Area.[Query]
)

--select * into Area.PopTotal from cte where [Place]='Total' 
-- select count(*) from cte  35101
--,cte2 as (
select c.[Area Codes], c.[Place], c.[All Ages],
p.[All Ages] [TotalPop],
round(cast(p.[All Ages] as float)/Avg(p.[All Ages]) over(),5) [PopRatio]
into Area.AreaPop
from cte c
left join Area.PopTotal p
	on c.[Place]=p.[Area Names]
where c.[Area Names] is null

--select c.[Area Codes], c.[Place], c.[All Ages], [TotalPop],[PopRatio] into Area.AreaPop from cte2 where [Area Names] is null
drop table Area.AreaPop
select count(*) from Area.AreaPop 34753

select * from Area.AreaPop



select * from Area.AreaPop where [All Ages]= [TotalPop]

select distinct [Area Codes]  from Area.AreaPop
select distinct [Area Codes] from [Area].[Query]
select * from Area.AreaPop
except 
select * from Area.AreaPop2

select substring('Birmingham',1, 10)
select CHARINDEX('1','Birmingham 101A')


