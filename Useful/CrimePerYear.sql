/*View showing the total amount of crime occuring each year*/
Create VIEW [Star].[vw_crimeperyear]
as
With cte as(
select f.CrimeID 
,Left(m.Mnth,4) [Yr]
from [Star].[CrimeFact] f
inner join [Star].[MonthData] m
on f.MonthID=m.MonthID
)/* Creating a table of the CrimeIDs verses the year the occur in*/


select count(CrimeID) [TotCrime], 
Yr
from cte Group by [Yr]/*Aggregating our data to count the total amount of crime occuring in each year*/
