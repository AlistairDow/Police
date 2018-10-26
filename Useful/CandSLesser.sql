
create view [Star].[vw_CrimensportLesserCrime]
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
from [Star].[vw_ExWcrimevplaceLesserCrime] c
inner join Star.vw_sportvplace s
	on c.PlaceID=s.PlaceID
inner join [Star].[Place] p
	on c.PlaceID=p.PlaceID)

select *, 
SportRatio/PopRatio SportPopRatio,
CrimeRatio/PopRatio CrimePopRatio,
[Fact/Crime]/avg([Fact/Crime]) over() FCRatio, 
cast([Crime/Fact] as float)/avg([Crime/Fact]) over() CFRatio, 
([Fact/Crime]/avg([Fact/Crime]) over())*PopRatio FCPRatio, 
(cast([Crime/Fact] as float)/avg([Crime/Fact]) over())*PopRatio CFPRatio 
from cte