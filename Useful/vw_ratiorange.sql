create view  Star.vw_ratiorange 
as
with cte as (

select [Place], WeightCrime [Crime Amount Weighted by Population], WeightCrimeRat [Crime Ratio Weighted by Population], DENSE_RANK() over(order by WeightCrimeRat desc) [Rank] from Star.vw_weightcrimevplace)

select c.*, c.[Crime Ratio Weighted by Population]-k.[Crime Ratio Weighted by Population] [dist], avg(c.[Crime Ratio Weighted by Population]-k.[Crime Ratio Weighted by Population]) over() [AvgDist], k.[Crime Ratio Weighted by Population] [val2] , k.[Rank] [Rank2]  from cte c 
full outer join cte k
	on c.[Rank]=(k.[rank]-1)
/*Calculates the Ratios distance from the value below it*/


