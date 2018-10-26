Create VIEW [Star].[vw_crimevplacespecific]
as
With cte as(
select f.CrimeID 
,p.Place 
,p.TotalPop
,p.PlaceLSOA
,p.PlaceID
,Left(m.Mnth,4) [Yr]
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
inner join [Star].[MonthData] m
on f.MonthID=m.MonthID
where p.Place in ('Barnsley','Halton','Tower Hamlets','Luton','Blackpool','Adur','Stoke-on-Trent','Tameside','Sunderland','South Tyneside')
)


select count(CrimeID) [TotCrime] 
--,cast(count(CrimeID) as float)/avg(count(CrimeID)) over() [CrimeRatio]
, count(CrimeID)/TotalPop CrimePerHead
,Place,
PlaceLSOA,
PlaceID,
Yr,
TotalPop
from cte Group by Place, PlaceLSOA, PlaceID, TotalPop, [Yr]
/*Shows the changineg Crime amount per yet for a chosen set of places*/
