
if object_id('Star.vw_Crimensport') is not null
 begin
	drop VIEW Star.vw_Crimensport
end

create view Star.vw_Crimensport
as
with cte as(
select 
s.Place
,c.PlaceLSOA
,c.TotCrime
,c.CrimeRatio
,c.TotCrime/s.TotFact [Crime/Fact]
,c.CrimeRatio/s.SportRatio [CrimeRatio/FactRatio]
,s.TotFact
,s.SportRatio
,cast(s.TotFact as float)/c.TotCrime [Fact/Crime]
,s.SportRatio/CrimeRatio [FactRatio/CrimeRatio]
,p.TotalPop
,p.TotalPop/Avg(p.TotalPop) over () [PopRatio]
from Star.vw_ExWcrimevplace c
inner join Star.vw_sportvplace s
	on c.PlaceID=s.PlaceID
inner join [Star].[Place] p
	on c.PlaceID=p.PlaceID)
/*Creating a table joining our Sport and Crime data including a few ratios*/

select *, 
SportRatio/PopRatio SportPopRatio,
CrimeRatio/PopRatio CrimePopRatio,
[Fact/Crime]/avg([Fact/Crime]) over() FCRatio, 
cast([Crime/Fact] as float)/avg([Crime/Fact]) over() CFRatio, 
([Fact/Crime]/avg([Fact/Crime]) over())*PopRatio FCPRatio, 
(cast([Crime/Fact] as float)/avg([Crime/Fact]) over())*PopRatio CFPRatio 
from cte
/* Aggregating areas of our crime and sport data with various ratios 
which could have use in investigory data analysis */



create view Star.vw_DepIndex
as
select p.Place, p.PlaceLSOA,
Avg(d. DepIndex) [DepIndexByPlace] 
from [Star].[Deptab] d 
inner join Star.Place p 
	on d.PlaceID =p.PlaceID
group by p.Place, p.PlaceLSOA


select * from Star.vw_DepIndex

