CREATE TABLE [Customers].[t_Customer]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_ID] DEFAULT (newsequentialid()),
[IDNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_IDNumber] DEFAULT (''),
[IDDoor] [int] NOT NULL CONSTRAINT [DF_t_Customer_IDDoor] DEFAULT ((0)),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Name] DEFAULT (N'الزبون النقدي'),
[NameAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_NameAR] DEFAULT (''),
[Reference] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Reference] DEFAULT (''),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Phones] DEFAULT (''),
[PhonesC] [int] NOT NULL CONSTRAINT [DF_t_Customer_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Web] DEFAULT (''),
[SocialMediaC] [int] NOT NULL CONSTRAINT [DF_t_Customer_SocialMediaC] DEFAULT ((0)),
[Gender] [tinyint] NOT NULL CONSTRAINT [DF_t_Customer_Gender] DEFAULT ((2)),
[Birthday] [date] NOT NULL CONSTRAINT [DF_t_Customer_Birthday] DEFAULT (getdate()),
[AgeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AgeIs] DEFAULT (''),
[AgeRangeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_AgeRangeID] DEFAULT ([Customers].[f_AgeRangeGetFirstID]()),
[AgeRange] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AgeRange] DEFAULT ([Customers].[f_AgeRangeGetFirstName]()),
[TitleID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_TitleID] DEFAULT ([Customers].[f_TitleGetFirstID]()),
[Title] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Title] DEFAULT ([Customers].[f_TitleGetFirstName]()),
[ClassificationID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_ClassificationID] DEFAULT ([Customers].[f_ClassificationGetFirstID]()),
[Classification] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Classification] DEFAULT ([Customers].[f_ClassificationGetFirstName]()),
[SalesPersonID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_SalesPersonID] DEFAULT ([Employees].[f_SalesPersonGetFirstID]()),
[SalesPerson] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_SalesPerson] DEFAULT ([Employees].[f_SalesPersonGetFirstName]()),
[NationalityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_NationalityID] DEFAULT ([Employees].[f_NationalityGetFirstID]()),
[Nationality] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Nationality] DEFAULT ([Employees].[f_NationalityGetFirstName]()),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AddressIs] DEFAULT (''),
[AddressC] [int] NOT NULL CONSTRAINT [DF_t_Customer_AddressC] DEFAULT ((0)),
[NumberCurrency] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_NumberCurrency] DEFAULT ('0'),
[CallAfter] [time] NOT NULL CONSTRAINT [DF_t_Customer_CallAfter] DEFAULT (getdate()),
[CallAfterF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_CallAfterF] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_DescriptionIs] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Customer_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_ImagePath] DEFAULT (''),
[ImageThumbnail] [image] NOT NULL CONSTRAINT [DF_t_Customer_ImageThumbnail] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImageThumbnailFixed] [bit] NOT NULL CONSTRAINT [DF_t_Customer_ImageThumbnailFixed] DEFAULT ((0)),
[ImageID] [image] NOT NULL CONSTRAINT [DF_t_Customer_ImageID] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImageIDPath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_ImageIDPath] DEFAULT (''),
[ImageIDThumbnail] [image] NOT NULL CONSTRAINT [DF_t_Customer_ImageIDThumbnail] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_QuotationC] DEFAULT ((0)),
[RequestC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_RequestC] DEFAULT ((0)),
[FeedbackC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_FeedbackC] DEFAULT ((0)),
[CallC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_CallC] DEFAULT ((0)),
[FileStorageC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_FileStorageC] DEFAULT ((0)),
[RatingFeedback] [decimal] (3, 2) NOT NULL CONSTRAINT [DF_t_Customer_RatingIs] DEFAULT ((0)),
[AdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty1] DEFAULT (''),
[AdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty2] DEFAULT (''),
[AdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty3] DEFAULT (''),
[AdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty4] DEFAULT (''),
[AdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty5] DEFAULT (''),
[AdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty6] DEFAULT (''),
[AdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty7] DEFAULT (''),
[AdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty8] DEFAULT (''),
[AdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty9] DEFAULT (''),
[AdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_AdditionalProperty10] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Customer_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_WhyThisStatus] DEFAULT (''),
[LicenseInternet] [bit] NOT NULL CONSTRAINT [DF_t_Customer_LicenseInternet] DEFAULT ((0)),
[EmployeeIDInternet] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_EmployeeIDInternet] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[EmployeeInternet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_EmployeeInternet] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[InternetPackageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_InternetPackageID] DEFAULT ([Customers].[f_InternetPackageGetFirstID]()),
[InternetPackage] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_InternetPackage] DEFAULT ([Customers].[f_InternetPackageGetFirstName]()),
[StartFromInternet] [date] NOT NULL CONSTRAINT [DF_t_Customer_StartFromInternet] DEFAULT (getdate()),
[ActiveToInternet] [date] NOT NULL CONSTRAINT [DF_t_Customer_ActiveToInternet] DEFAULT (getdate()),
[ActiveToDayInternet] [int] NOT NULL CONSTRAINT [DF_t_Customer_ActiveToDayInternet] DEFAULT ((0)),
[NotificationBeforeDaysInternet] [tinyint] NOT NULL CONSTRAINT [DF_t_Customer_NotificationBeforeDaysInternet] DEFAULT ((5)),
[NotificationDateInternet] [date] NOT NULL CONSTRAINT [DF_t_Customer_NotificationDateInternet] DEFAULT (getdate()),
[NotificationARInternet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_NotificationARInternet] DEFAULT (''),
[NotificationENInternet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_NotificationENInternet] DEFAULT (''),
[UserNameInternet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_UserNameInternet] DEFAULT (''),
[PasswordInternet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PasswordInternet] DEFAULT (''),
[InternetSubscriptionC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_InternetSubscriptionC] DEFAULT ((0)),
[InternetSubscriptionTotal] [float] NOT NULL CONSTRAINT [DF_t_Customer_InternetSubscriptionTotal] DEFAULT ((0)),
[InternetSubscriptionTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_InternetSubscriptionTotalF] DEFAULT ('0'),
[InternetSubscriptionProfit] [float] NOT NULL CONSTRAINT [DF_t_Customer_InternetSubscriptionProfit] DEFAULT ((0)),
[InternetSubscriptionProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_InternetSubscriptionProfitF] DEFAULT ('0'),
[InternetSubscriptionLast] [date] NOT NULL CONSTRAINT [DF_t_Customer_InternetSubscriptionLast] DEFAULT (datefromparts((2000),(1),(1))),
[PricingType] [tinyint] NOT NULL CONSTRAINT [DF_t_Customer_PricingType] DEFAULT ((0)),
[PriceIncreaseRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_Customer_PriceIncreaseRate] DEFAULT ((0)),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_Customer_PaymentMethod] DEFAULT ((0)),
[MaximumDebtInvoiceCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_MaximumDebtInvoiceCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[MaximumDebtInvoiceCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_MaximumDebtInvoiceCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[MaximumDebtInvoice] [float] NOT NULL CONSTRAINT [DF_t_Customer_MaximumDebtInvoice] DEFAULT ((0)),
[MaximumDebtInvoiceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_MaximumDebtInvoiceF] DEFAULT ('0'),
[MaximumDebtInvoiceD] [float] NOT NULL CONSTRAINT [DF_t_Customer_MaximumDebtInvoiceD] DEFAULT ((0)),
[FromWFP] [bit] NOT NULL CONSTRAINT [DF_t_Customer_FromWFP] DEFAULT ((0)),
[GroupNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_GroupNames] DEFAULT (''),
[GroupCounts] [int] NOT NULL CONSTRAINT [DF_t_Customer_GroupCounts] DEFAULT ((0)),
[PrescriptionDoctorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionDoctorID] DEFAULT ([Company].[f_DoctorGetFirstID]()),
[PrescriptionDoctor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionDoctor] DEFAULT ([Company].[f_DoctorGetFirstName]()),
[PrescriptionBrandID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionBrandID] DEFAULT ([Items].[f_BrandGetFirstID]()),
[PrescriptionBrand] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionBrand] DEFAULT ([Items].[f_BrandGetFirstName]()),
[PrescriptionTypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionTypeIs] DEFAULT ('Spectacle Lenses'),
[PrescriptionFocal] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionFocal] DEFAULT (' '),
[PrescriptionWithRight] [bit] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionWithRight] DEFAULT ((1)),
[PrescriptionWithLeft] [bit] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionWithLeft] DEFAULT ((1)),
[PrescriptionSphereRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionSphereRight] DEFAULT ((0)),
[PrescriptionSphereLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionSphereLeft] DEFAULT ((0)),
[PrescriptionCylinderRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionCylinderRight] DEFAULT ((0)),
[PrescriptionCylinderLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionCylinderLeft] DEFAULT ((0)),
[PrescriptionAxisRight] [int] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionAxisRight] DEFAULT ((0)),
[PrescriptionAxisLeft] [int] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionAxisLeft] DEFAULT ((0)),
[PrescriptionPrismRight] [int] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionPrismRight] DEFAULT ((0)),
[PrescriptionPrismLeft] [int] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionPrismLeft] DEFAULT ((0)),
[PrescriptionBaseRight] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionBaseRight] DEFAULT (' '),
[PrescriptionBaseLeft] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionBaseLeft] DEFAULT (' '),
[PrescriptionAddition] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionAddition] DEFAULT ((0)),
[PrescriptionHeightRight] [int] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionHeightRight] DEFAULT ((0)),
[PrescriptionHeightLeft] [int] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionHeightLeft] DEFAULT ((0)),
[PrescriptionPDRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionPDRight] DEFAULT ((0)),
[PrescriptionPDLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionPDLeft] DEFAULT ((0)),
[PrescriptionPD] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionPD] DEFAULT ((0)),
[PrescriptionDescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionDescriptionIs] DEFAULT (''),
[PrescriptionLastDate] [date] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionLastDate] DEFAULT (datefromparts((2000),(1),(1))),
[PrescriptionC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_PrescriptionC] DEFAULT ((0)),
[FrameJobOrderC] [bigint] NOT NULL CONSTRAINT [DF_t_Customer_FrameJobOrderC] DEFAULT ((0)),
[FrameJobOrderTotal] [float] NOT NULL CONSTRAINT [DF_t_Customer_FrameJobOrderTotal] DEFAULT ((0)),
[FrameJobOrderTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_FrameJobOrderTotalF] DEFAULT ('0'),
[FrameJobOrderProfit] [float] NOT NULL CONSTRAINT [DF_t_Customer_FrameJobOrderProfit] DEFAULT ((0)),
[FrameJobOrderProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_FrameJobOrderProfitF] DEFAULT ('0'),
[FrameJobOrderLast] [date] NOT NULL CONSTRAINT [DF_t_Customer_FrameJobOrderLast] DEFAULT (datefromparts((2000),(1),(1))),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Customer_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Customer_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Customer_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_Customer_IsSyncImage] DEFAULT ((0)),
[IsSyncImageID] [bit] NOT NULL CONSTRAINT [DF_t_Customer_IsSyncImageID] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Customer_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Customers].[tr_Customer] ON [Customers].[t_Customer]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_Customer
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Customer.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'customer'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'customer'
    FROM    Inserted AS s;

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'customer_ID'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'customer_ID'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Customer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [PK_t_Customer] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_CustomerName] ON [Customers].[t_Customer] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [AgeRangeKeyCustomer] FOREIGN KEY ([AgeRangeID]) REFERENCES [Customers].[t_AgeRange] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [BuildingKeyCustomer] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [ClassificationKeyCustomer] FOREIGN KEY ([ClassificationID]) REFERENCES [Customers].[t_Classification] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [CurrencyKeyCustomerMaximumDebtInvoice] FOREIGN KEY ([MaximumDebtInvoiceCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [EmployeeKeyCustomer] FOREIGN KEY ([EmployeeIDInternet]) REFERENCES [Employees].[t_Employee] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [FloorKeyCustomer] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [InternetPackageKeyCustomer] FOREIGN KEY ([InternetPackageID]) REFERENCES [Customers].[t_InternetPackage] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [NationalityKeyCustomer] FOREIGN KEY ([NationalityID]) REFERENCES [Employees].[t_Nationality] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [PostalCodeKeyCustomer] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [PrescriptionBrandKeyCustomer] FOREIGN KEY ([PrescriptionBrandID]) REFERENCES [Items].[t_Brand] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [PrescriptionDoctorKeyCustomer] FOREIGN KEY ([PrescriptionDoctorID]) REFERENCES [Company].[t_Doctor] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [RegionkeyCustomer] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [SalesPersonKeyCustomer] FOREIGN KEY ([SalesPersonID]) REFERENCES [Employees].[t_SalesPerson] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [StatesKeyCustomer] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [StreetKeyCustomer] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
ALTER TABLE [Customers].[t_Customer] ADD CONSTRAINT [TitleKeyCustomer] FOREIGN KEY ([TitleID]) REFERENCES [Customers].[t_Title] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'From World Food Programme', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'FromWFP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'male = 0
female = 1
unknown = 2', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'Gender'
GO
EXEC sp_addextendedproperty N'MS_Description', N'cash = 0
onAccount = 1
schedulePayment = 2', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Up
Down
In
Out', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'PrescriptionBaseLeft'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Up
Down
In
Out', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'PrescriptionBaseRight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Plano
Single Distance
Single Intermediate
Single Near
Bifocal
Progressive', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'PrescriptionFocal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Lenses
Spectacle Lenses', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'PrescriptionTypeIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sale = 0
Cost = 1', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'PricingType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Customers', 'TABLE', N't_Customer', 'COLUMN', N'StatusIs'
GO
