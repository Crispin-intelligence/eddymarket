CREATE TABLE [Company].[t_Contact]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Name] DEFAULT ('-'),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Phones] DEFAULT (''),
[PhonesC] [int] NOT NULL CONSTRAINT [DF_t_Contact_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_SocialMedia] DEFAULT (''),
[SocialMediaC] [int] NOT NULL CONSTRAINT [DF_t_Contact_SocialMediaC] DEFAULT ((0)),
[Gender] [tinyint] NOT NULL CONSTRAINT [DF_t_Contact_Gender] DEFAULT ((0)),
[NationalityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_NationalityID] DEFAULT ([Employees].[f_NationalityGetFirstID]()),
[Nationality] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Nationality] DEFAULT ([Employees].[f_NationalityGetFirstName]()),
[TitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_TitleID] DEFAULT ([Customers].[f_TitleGetFirstID]()),
[Title] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Title] DEFAULT ([Customers].[f_TitleGetFirstName]()),
[ClassificationID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_ClassificationID] DEFAULT ([Customers].[f_ClassificationGetFirstID]()),
[Classification] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Classification] DEFAULT ([Customers].[f_ClassificationGetFirstName]()),
[Birthday] [date] NOT NULL CONSTRAINT [DF_t_Contact_Birthday] DEFAULT (getdate()),
[AgeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_AgeIs] DEFAULT (''),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Contact_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_AddressIs] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Contact_DescriptionIs] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Contact_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Contact_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Contact_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Contact]
ON [Company].[t_Contact]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Contact, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [PK_t_Contact] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Contact_Name] ON [Company].[t_Contact] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [BuildingKeyContact] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [ClassificationKeyContact] FOREIGN KEY ([ClassificationID]) REFERENCES [Customers].[t_Classification] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [FloorKeyContact] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [NationalityKeyContact] FOREIGN KEY ([NationalityID]) REFERENCES [Employees].[t_Nationality] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [PostalCodeKeyContact] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [RegionkeyContact] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [StatesKeyContact] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [StreetKeyContact] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
ALTER TABLE [Company].[t_Contact] ADD CONSTRAINT [TitleKeyContact] FOREIGN KEY ([TitleID]) REFERENCES [Customers].[t_Title] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'male = 0
female = 1
unknown = 2', 'SCHEMA', N'Company', 'TABLE', N't_Contact', 'COLUMN', N'Gender'
GO
