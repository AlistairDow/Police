if object_id('Star.CrimeTypePlacePivot') is not null
 begin
	drop table Star.CrimeTypePlacePivot
end


select 
* 
into Star.CrimeTypePlacePivot
from
(
select
t.CrimeType,
f.CFactID,
p.Place,
p.PlaceLSOA
from [Star].[CrimeFact] f
inner join [Star].[CrimeType] t
	on f.CrimeTypeID=t.CrimeTypeID
inner join [Star].[Area] a
	on f.[AreaID]=a.[AreaID]
inner join [Star].[Place] p
	on a.[PlaceID]=p.[PlaceID]
)c
pivot(
count(CFactID) for CrimeType in (
[Bicycle theft]
,[Burglary]
,[Other theft]
,[Possession of weapons]
,[Robbery]
,[Theft from the person]
,[Vehicle crime]
,[Criminal damage and arson]
,[Other crime]
,[Shoplifting]
,[Violence and sexual offences]
,[Public disorder and weapons]
,[Public order]
,[Violent crime]
,[Anti-social behaviour]
,[Drugs])
) p

