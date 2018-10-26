if object_id('Star.vw_sportvplace') is not null
 begin
	drop VIEW Star.vw_sportvplace
end

Create VIEW Star.vw_sportvplace
as
With cte as(
select f.SportFactID 
,p.Place 
,p.TotalPop
,p.PlaceLSOA
,p.PlaceID
from [Star].[SportFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
where p.Place not in ('Westminster','City of London')
)


select count(SportFactID) [TotFact] 
,cast(count(SportFactID) as float)/avg(count(SportFactID)) over() [SportRatio]
,Place,
PlaceLSOA
,PlaceID
from cte Group by Place, PlaceLSOA, PlaceID


if object_id('Star.vw_weightsportvplace') is not null
 begin
	drop VIEW Star.vw_weightsportvplace
end

Create VIEW Star.vw_weightsportvplace
as
With cte as(
select f.SportFactID 
,p.Place 
,p.TotalPop
,p.TotalPop/Avg(p.TotalPop) over () [PopRatio]
,p.PlaceLSOA
,p.PlaceID
from [Star].[SportFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
where p.Place not in ('Westminster','City of London')
)

,cte2 as (
select count(SportFactID) [TotFact] 
,[PopRatio]
,Place
,PlaceLSOA
,PlaceID
from cte 
Group by Place, PlaceLSOA,  PopRatio, PlaceID 
)


select Place
,PlaceLSOA
,PlaceID 
,[TotFact]/PopRatio [WeightSport], 
([TotFact]/PopRatio)/avg([TotFact]/PopRatio) over() [WeightSportRat] from cte2 



 view Star.vw_SportsType 
as 
with cte as (
select
s.SportFactID,
t.FacTypeDescription,
p.Place,
p.PlaceLSOA
from  Star.SportFact s
inner join [Star].[Facility] f
	on s.FacilityKeyID=f.FacilityKeyID
inner join [Star].[FacilityType] t
	on f.FacTypeID=t.FacTypeID
inner join [Star].[Area] a
	on s.[AreaID]=a.[AreaID]
inner join [Star].[Place] p
	on a.[PlaceID]=p.[PlaceID])


,cte2 as
(select distinct 
FacTypeDescription,
Place,
PlaceLSOA
,count(SportFactID) over(partition by FacTypeDescription, Place) FacTypePerArea
 from cte )


 select *, DENSE_RANK() Over(Partition by Place Order by FacTypePerArea desc) Drank from cte2
