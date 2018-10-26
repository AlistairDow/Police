create view Star.vw_FacilChange
as
with cte as (
select distinct g.[Local Authority Name], Count(*) over (partition by g.[Local Authority Name]) [Ocount] from [Sport].[Facilities] f
inner join Sport.Geographic g
	on f.FACILITYID=g.FACILITYID
where f.OpeningDate != '' and cast(right(f.OpeningDate,4) as int) > 2010
)/*Facilities which have Openned since 2010*/ 

,cte2 as(
select distinct g.[Local Authority Name], Count(*) over (partition by g.[Local Authority Name]) [fcount] 
from [Sport].[Facilities] f
inner join Sport.Geographic g
	on f.FACILITYID=g.FACILITYID
where f.RecEndDate != '' and cast(right(f.RecEndDate,4) as int) > 2010
)/*Facilities which have closed since 2010*/

,cte3 as(
select g.[Local Authority Name], count(*) over (partition by g.[Local Authority Name]) [Total]
from [Sport].[Facilities] f
inner join Sport.Geographic g
	on f.FACILITYID=g.FACILITYID
where cast(right(f.RecEndDate,4) as int) !< 2011 or f.RecEndDate ='')
/*Total Number*/

select distinct 
c.[Local Authority Name],
c.Ocount - c2.fcount [Change],
(c.Ocount - c2.fcount)/ cast(c3.[Total] as float) * 100 [Percentage],
DENSE_RANK() over(order by (c.Ocount - c2.fcount)/ cast(c3.[Total] as float) asc) [Ranking],
c.Ocount, 
c2.fcount
from cte c
inner join cte2 c2
	on c.[Local Authority Name]=c2.[Local Authority Name]
inner join cte3 c3
	on c.[Local Authority Name]=c3.[Local Authority Name]
/*Joining our data together to calcultae the change in values*/

