Create VIEW [Star].[vw_ExWcrimevplaceCT]
as
With cte as(
select f.CrimeID
,t.CrimeType
,p.Place 
,p.TotalPop
,p.PlaceLSOA
,p.PlaceID
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
inner join [Star].[CrimeType] t
on f.CrimeTypeID=t.CrimeTypeID
where p.Place not in ('Westminster','City of London')
)


select count(CrimeID) [TotCrime] 
,cast(count(CrimeID) as float)/avg(count(CrimeID)) over() [CrimeRatio]
,Place,
PlaceLSOA,
PlaceID,
CrimeType
from cte Group by Place, PlaceLSOA, PlaceID, CrimeType

GO



Create VIEW [Star].[vw_ExWcrimevplaceLesserCrime]
as
With cte as(
select f.CrimeID
,t.CrimeType
,p.Place 
,p.TotalPop
,p.PlaceLSOA
,p.PlaceID
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
inner join [Star].[CrimeType] t
on f.CrimeTypeID=t.CrimeTypeID
where p.Place not in ('Westminster','City of London') and t.CrimeType in ('Anti-social behaviour','Public Order', 'Shoplifting')
)/*Is identical to vw_ExWcrimevplace but filter for a set number of Crime Types*/


select count(CrimeID) [TotCrime] 
,cast(count(CrimeID) as float)/avg(count(CrimeID)) over() [CrimeRatio]
,Place,
PlaceLSOA,
PlaceID
--CrimeType
from cte Group by Place, PlaceLSOA, PlaceID
GO




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

select * from star.vw_sportsType where Drank =1

