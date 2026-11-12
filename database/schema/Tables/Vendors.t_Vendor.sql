CREATE TABLE [Vendors].[t_Vendor]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Name] DEFAULT (N'المورد النقدي'),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Phones] DEFAULT (''),
[PhonesC] [int] NOT NULL CONSTRAINT [DF_t_Vendor_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Web] DEFAULT (''),
[SocialMediaC] [int] NOT NULL CONSTRAINT [DF_t_Vendor_SocialMediaC] DEFAULT ((0)),
[TitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_TitleID] DEFAULT ([Customers].[f_TitleGetFirstID]()),
[Title] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Title] DEFAULT ([Customers].[f_TitleGetFirstName]()),
[ClassificationID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_ClassificationID] DEFAULT ([Customers].[f_ClassificationGetFirstID]()),
[Classification] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Classification] DEFAULT ([Customers].[f_ClassificationGetFirstName]()),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vendor_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AddressIs] DEFAULT (''),
[AddressC] [int] NOT NULL CONSTRAINT [DF_t_Vendor_AddressC] DEFAULT ((0)),
[NumberCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_NumberCurrency] DEFAULT ('0'),
[CallAfter] [time] NOT NULL CONSTRAINT [DF_t_Vendor_CallAfter] DEFAULT (getdate()),
[CallAfterF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_CallAfterF] DEFAULT (''),
[Payment] [float] NOT NULL CONSTRAINT [DF_t_Vendor_Payment] DEFAULT ((0)),
[PaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_PaymentF] DEFAULT ('0'),
[PaymentD] [float] NOT NULL CONSTRAINT [DF_t_Vendor_PaymentD] DEFAULT ((0)),
[PaymentEvery] [int] NOT NULL CONSTRAINT [DF_t_Vendor_PaymentEvery] DEFAULT ((0)),
[PaymentEveryType] [tinyint] NOT NULL CONSTRAINT [DF_t_Vendor_PaymentEveryType] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_DescriptionIs] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Vendor_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_ImagePath] DEFAULT (''),
[CallC] [bigint] NOT NULL CONSTRAINT [DF_t_Vendor_CallC] DEFAULT ((0)),
[FileStorageC] [bigint] NOT NULL CONSTRAINT [DF_t_Vendor_FileStorageC] DEFAULT ((0)),
[AdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty1] DEFAULT (''),
[AdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty2] DEFAULT (''),
[AdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty3] DEFAULT (''),
[AdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty4] DEFAULT (''),
[AdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty5] DEFAULT (''),
[AdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty6] DEFAULT (''),
[AdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty7] DEFAULT (''),
[AdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty8] DEFAULT (''),
[AdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty9] DEFAULT (''),
[AdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_AdditionalProperty10] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Vendor_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_WhyThisStatus] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vendor_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Vendor_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Vendor_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_Vendor_IsSyncImage] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Vendors_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Vendors].[tr_Vendor] ON [Vendors].[t_Vendor]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Vendors.t_Vendor
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Vendor.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'vendor'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'vendor'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Vendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaVendor, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [PK_t_Vendor] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbl_VendorsNameCompany] ON [Vendors].[t_Vendor] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [BuildingKeyVendor] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [ClassificationKeyVendor] FOREIGN KEY ([ClassificationID]) REFERENCES [Customers].[t_Classification] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [FloorKeyVendor] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [PostalCodeKeyVendor] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [RegionkeyVendor] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [StatesKeyVendor] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [StreetKeyVendor] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
ALTER TABLE [Vendors].[t_Vendor] ADD CONSTRAINT [TitleKeyVendor] FOREIGN KEY ([TitleID]) REFERENCES [Customers].[t_Title] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Daily = 0
Monthly = 1', 'SCHEMA', N'Vendors', 'TABLE', N't_Vendor', 'COLUMN', N'PaymentEveryType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Vendors', 'TABLE', N't_Vendor', 'COLUMN', N'StatusIs'
GO
