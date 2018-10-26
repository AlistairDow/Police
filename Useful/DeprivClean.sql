--create schema Depriv

if object_id('Depriv.CleanIMD') is not null
 begin
	drop table Depriv.CleanIMD
end

SELECT [LSOA code (2011)]
      ,[LSOA name (2011)]
      ,[Local Authority District code (2013)]
      ,case 
	  when [Local Authority District name (2013)] like '%,%' then SUBSTRING([Local Authority District name (2013)],1,(charindex(',',[Local Authority District name (2013)])-1))
	  else [Local Authority District name (2013)]
	  end [LocalAuthName]
      ,[Index of Multiple Deprivation (IMD) Rank (where 1 is most depriv]
      ,[Index of Multiple Deprivation (IMD) Decile (where 1 is most depr]
into Depriv.CleanIMD
FROM [Depriv].[IMD]
order by [LocalAuthName]
GO

