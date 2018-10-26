
 
 
 select CrimeID, LastOutCat from 
 Crime.[CleanedStreet]
 where [Crime type] not in ('Criminal damage and arson','Other crime','Shoplifting','Violence and sexual offences','Public disorder and weapons','Public order','Violent crime','Bicycle theft','Other theft','Burglary','Possession of weapons','Robbery','Theft from the person','Vehicle crime','Anti-social behaviour','Drugs')

 begin tran
 update c
 set c.[Crime type] = c1.[LastOutCat]
 from Crime.[CleanedStreet] c
 inner join (select CrimeID, LastOutCat from 
 Crime.[CleanedStreet]
 where [Crime type] not in ('Criminal damage and arson','Other crime','Shoplifting','Violence and sexual offences','Public disorder and weapons','Public order','Violent crime','Bicycle theft','Other theft','Burglary','Possession of weapons','Robbery','Theft from the person','Vehicle crime','Anti-social behaviour','Drugs')
 ) c1
  on c.CrimeID = c1.CrimeID

  /*This is cleaning our Crime type as some of the value are stored in incorrect columns 
  select distinct [Crime type] where Crime.[CleanedStreet] this is to ratify our data is correct*/

  commit tran 


  begin tran
  ;with cte as(
  select * from [Crime].[CleanedStreet] where [LSOA Code] not like 'E0%' 
  )
     delete cs
  from [Crime].[CleanedStreet] cs
  inner join cte c
	on cs.CrimeID=c.CrimeID 
	commit tran
		rollback tran
  /*This is removing all our non england data as this study is solely based off english areas*/


	  select distinct Left([LSOA Code],2) from [Crime].[CleanedStreet]

  ;with cte as(
  select * from [Crime].[CleanedStreet] where [LSOA Code] not like 'E0%' 
  )
  
  select * from cte where [LSOA Code] not like 'W0%'


  select distinct Left([Lower Super Output Area Code],2) from [Sport].[Geographic]
  


    ;with cte as(
  select * from [Crime].[CleanedStreet] where [LSOA Code] not like 'E0%' 
  )
     select cs.*
  from [Crime].[CleanedStreet] cs
  inner join cte c
	on cs.CrimeID=c.CrimeID 