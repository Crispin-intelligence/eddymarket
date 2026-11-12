CREATE TABLE [Cars].[t_CarDriver]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Name] DEFAULT ('-'),
[DrivingLicense] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_DrivingLicense] DEFAULT (''),
[DrivingLicenseIssuanceDate] [date] NOT NULL CONSTRAINT [DF_t_CarDriver_DrivingLicenseIssuanceDate] DEFAULT (datefromparts((2000),(1),(1))),
[LicenseExpirationDate] [date] NOT NULL CONSTRAINT [DF_t_CarDriver_LicenseExpirationDate] DEFAULT (getdate()),
[ValidDriverLicense] [bit] NOT NULL CONSTRAINT [DF_t_CarDriver_ValidDriverLicense] DEFAULT ((0)),
[DrivingLicenseStatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_DrivingLicenseStatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[DrivingLicenseStates] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_DrivingLicenseStates] DEFAULT ([Location].[f_StatesGetFirstName]()),
[DrivingLicenseRegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_DrivingLicenseRegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[DrivingLicenseRegion] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_DrivingLicenseRegion] DEFAULT ([Location].[f_RegionGetFirstName]()),
[BloodType] [tinyint] NOT NULL CONSTRAINT [DF_t_CarDriver_BloodType] DEFAULT ((0)),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Phones] DEFAULT (''),
[PhonesC] [int] NOT NULL CONSTRAINT [DF_t_CarDriver_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_SocialMedia] DEFAULT (''),
[SocialMediaC] [int] NOT NULL CONSTRAINT [DF_t_CarDriver_SocialMediaC] DEFAULT ((0)),
[Gender] [tinyint] NOT NULL CONSTRAINT [DF_t_CarDriver_Gender] DEFAULT ((0)),
[NationalityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_NationalityID] DEFAULT ([Employees].[f_NationalityGetFirstID]()),
[Nationality] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Nationality] DEFAULT ([Employees].[f_NationalityGetFirstName]()),
[TitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_TitleID] DEFAULT ([Customers].[f_TitleGetFirstID]()),
[Title] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Title] DEFAULT ([Customers].[f_TitleGetFirstName]()),
[ClassificationID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_ClassificationID] DEFAULT ([Customers].[f_ClassificationGetFirstID]()),
[Classification] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Classification] DEFAULT ([Customers].[f_ClassificationGetFirstName]()),
[Birthday] [date] NOT NULL CONSTRAINT [DF_t_CarDriver_Birthday] DEFAULT (getdate()),
[BirthdayStatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_BirthdayStatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[BirthdayStates] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_BirthdayStates] DEFAULT ([Location].[f_StatesGetFirstName]()),
[BirthdayRegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_BirthdayRegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[BirthdayRegion] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_BirthdayRegion] DEFAULT ([Location].[f_RegionGetFirstName]()),
[AgeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_AgeIs] DEFAULT (''),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarDriver_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_AddressIs] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_DescriptionIs] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_CarDriver_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImageThumbnail] [image] NOT NULL CONSTRAINT [DF_t_CarDriver_ImageThumbnail] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_ImagePath] DEFAULT (''),
[CarRentalCount] [bigint] NOT NULL CONSTRAINT [DF_t_CarDriver_CarRentalCount] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarDriver_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarDriver_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarDriver_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_CarDriver_IsSyncImage] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarDriver_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarDriver] ON [Cars].[t_CarDriver]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
    AND NOT UPDATE(IsSyncImage)
  BEGIN 

    UPDATE  Cars.t_CarDriver
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarDriverSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarDriver.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'carDriver'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'carDriver'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarDriver, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [PK_t_CarDriver] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [BuildingKeyCarDriver] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [ClassificationKeyCarDriver] FOREIGN KEY ([ClassificationID]) REFERENCES [Customers].[t_Classification] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [FloorKeyCarDriver] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [NationalityKeyCarDriver] FOREIGN KEY ([NationalityID]) REFERENCES [Employees].[t_Nationality] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [PostalCodeKeyCarDriver] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [RegionkeyCarDriver] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [RegionKeyCarDriverBirthday] FOREIGN KEY ([BirthdayRegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [RegionKeyCarDriverDrivingLicense] FOREIGN KEY ([DrivingLicenseRegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [StatesKeyCarDriver] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [StatesKeyCarDriverBirthday] FOREIGN KEY ([BirthdayStatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [StatesKeyCarDriverDrivingLicense] FOREIGN KEY ([DrivingLicenseStatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [StreetKeyCarDriver] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
ALTER TABLE [Cars].[t_CarDriver] ADD CONSTRAINT [TitleKeyCarDriver] FOREIGN KEY ([TitleID]) REFERENCES [Customers].[t_Title] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'unknown = 0
A+ = 1
A- = 2
B+ = 3
B- = 4
O+ = 5
O- = 6
AB+ = 7
AB- = 8', 'SCHEMA', N'Cars', 'TABLE', N't_CarDriver', 'COLUMN', N'BloodType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'male = 0
female = 1
unknown = 2', 'SCHEMA', N'Cars', 'TABLE', N't_CarDriver', 'COLUMN', N'Gender'
GO
