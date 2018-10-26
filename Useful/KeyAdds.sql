ALTER table [Star].[CrimeFact]
Add constraint FK_CrimeArea foreign key (AreaID)
	References [Star].[Area] (AreaID)

ALTER table [Star].[CrimeFact]
Add constraint FK_CMonth foreign key (monthID)
	References [Star].[MonthData] (MonthID)



ALTER table [Star].[CrimeFact]
Add constraint FK_PoliceForce foreign key (PoliceID)
	References [Star].[PoliceForce] (PoliceID)

ALTER table [Star].[CrimeFact]
Add constraint FK_CrimePointLoc foreign key (LocationID)
	References [Star].[PointLocation] (LocationID)

ALTER table [Star].[CrimeFact]
Add constraint FK_CrimeType foreign key (CrimeTypeID)
	References [Star].[CrimeType] (CrimeTypeID)

Alter table [Star].[Area]
Add constraint FK_Place foreign key (PlaceID)
	References [Star].[Place] (PlaceID)

ALTER table [Star].[SportFact]
Add constraint FK_SportArea foreign key (AreaID)
	References [Star].[Area] (AreaID)
	
ALTER table [Star].[SportFact]
Add constraint FK_SportPointLoc foreign key (LocationID)
	References [Star].[PointLocation] (LocationID)



ALTER table [Star].[SportFact]
Add constraint FK_SportSite foreign key (SiteKeyID)
	References [Star].[Sites] (SiteKeyID)

	ALTER table [Star].[SportFact]
Add constraint FK_Facility foreign key (FacilityKeyID)
	References [Star].[Facility] (FacilityKeyID)	

ALTER table [Star].[Facility]
Add constraint FK_FacilitySubType foreign key (FacSubTypeID)
	References [Star].[FacilitySubType] (FacSubTypeID)	

	select * from [Star].[FacilitySubType] 

ALTER table [Star].[Facility]
Add constraint FK_FacilityType foreign key (FacTypeID)
	References [Star].[FacilityType] (FacTypeID)	

Alter table Star.Deptab
Add constraint FK_DepArea foreign key ([AreaID])
	References [Star].Area ([AreaID])	

Alter table Star.Deptab
Add constraint FK_DepPlace foreign key ([PlaceID])
	References [Star].[Place] ([PlaceID])	


select top 2 * from [Star].[FacilitySubType]
select top 2 * from	[Star].[Facility]

