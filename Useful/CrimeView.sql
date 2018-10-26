use Police


if object_id('Star.vw_crimevplace') is not null
 begin
	drop VIEW Star.vw_crimevplace
end

Create VIEW Star.vw_crimevplace
as
With cte as(
select f.CrimeID 
,p.Place 
,p.TotalPop
,p.PlaceLSOA
,p.PlaceID
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
)


select count(CrimeID) [TotCrime] 
,cast(count(CrimeID) as float)/avg(count(CrimeID)) over() [CrimeRatio]
,Place,
PlaceLSOA
,PlaceID
from cte Group by Place, PlaceLSOA, PlaceID
go


if object_id('star.vw_weightcrimevplace') is not null
 begin
	drop VIEW star.vw_weightcrimevplace
end

Create VIEW star.vw_weightcrimevplace
as
with cte as(
select f.CrimeID 
,p.Place 
,p.TotalPop
,p.TotalPop/Avg(p.TotalPop) over () [PopRatio]
,p.PlaceLSOA
,p.PlaceID
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
)

,cte2 as(
select count(CrimeID) 
[TotCrime] 
,Place
,PopRatio 
,PlaceLSOA
,PlaceID
from cte Group by Place, PlaceLSOA, PopRatio, PlaceID
 )

select Place, PlaceLSOA, PlaceID, [TotCrime]/PopRatio [WeightCrime], ([TotCrime]/PopRatio)/avg([TotCrime]/PopRatio) over() [WeightCrimeRat] from cte2



if object_id('Star.vw_ExWcrimevplace') is not null
 begin
	drop VIEW Star.vw_ExWcrimevplace
end


Create VIEW Star.vw_ExWcrimevplace
as
With cte as(
select f.CrimeID 
,p.Place 
,p.TotalPop
,p.PlaceLSOA
,p.PlaceID
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
where p.Place not in ('Westminster','City of London')
)


select count(CrimeID) [TotCrime] 
,cast(count(CrimeID) as float)/avg(count(CrimeID)) over() [CrimeRatio]
,Place,
PlaceLSOA,
PlaceID
from cte Group by Place, PlaceLSOA, PlaceID
go


if object_id('star.vw_exWweightcrimevplace') is not null
 begin
	drop VIEW star.vw_exWweightcrimevplace
end

Create VIEW star.vw_exWweightcrimevplace
as
with cte as(
select f.CrimeID 
,p.Place 
,p.TotalPop
,p.TotalPop/Avg(p.TotalPop) over () [PopRatio]
,p.PlaceLSOA
,p.PlaceID
from [Star].[CrimeFact] f
inner join [Star].[Area] a
on f.AreaID=a.AreaID
inner join [Star].[Place] p
on a.PlaceID=p.PlaceID
where p.Place not in ('Westminster','City of London')
)

,cte2 as(
select count(CrimeID) 
[TotCrime] 
,Place
,PopRatio
,PlaceLSOA
,PlaceID
from cte Group by Place, PlaceLSOA, PopRatio, PlaceID)

select Place, PlaceLSOA, PlaceID, [TotCrime]/PopRatio [WeightCrime], ([TotCrime]/PopRatio)/avg([TotCrime]/PopRatio) over() [WeightCrimeRat] from cte2 


Create view Star.vw_CrimeType
as
select distinct 
t.CrimeType,
count(f.CFactID) Over (partition by p.Place, t.CrimeType) [CrimeTypeNumbers],
p.Place,
p.PlaceLSOA
from [Star].[CrimeFact] f
inner join [Star].[CrimeType] t
	on f.CrimeTypeID=t.CrimeTypeID
inner join [Star].[Area] a
	on f.[AreaID]=a.[AreaID]
inner join [Star].[Place] p
	on a.[PlaceID]=p.[PlaceID]

	

