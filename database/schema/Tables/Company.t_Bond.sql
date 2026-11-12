CREATE TABLE [Company].[t_Bond]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Bond_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_RefF] DEFAULT ('0'),
[NumberIs] [int] NOT NULL CONSTRAINT [DF_t_Bond_NumberIs] DEFAULT ((0)),
[NumberOfGroup] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_NumberOfGroup] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Bond_DateIs] DEFAULT (getdate()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_BeneficiaryAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_AddressIs] DEFAULT (''),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Bond_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Amount] [float] NOT NULL CONSTRAINT [DF_t_Bond_Amount] DEFAULT ((0)),
[AmountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_AmountF] DEFAULT ('0'),
[AmountD] [float] NOT NULL CONSTRAINT [DF_t_Bond_AmountD] DEFAULT ((0)),
[AmountLL] [float] NOT NULL CONSTRAINT [DF_t_Bond_AmountLL] DEFAULT ((0)),
[AmountEuro] [float] NOT NULL CONSTRAINT [DF_t_Bond_AmountEuro] DEFAULT ((0)),
[AmountAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_AmountAR] DEFAULT (''),
[AmountEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_AmountEN] DEFAULT (''),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bond_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Bond_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_TypeIsAR] DEFAULT (''),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_TypeIsEN] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Bond_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[IsPaid] [bit] NOT NULL CONSTRAINT [DF_t_Bond_IsPaid] DEFAULT ((0)),
[DateDue] [date] NOT NULL CONSTRAINT [DF_t_Bond_DateDue] DEFAULT (getdate()),
[DateDueMonthly] [date] NOT NULL CONSTRAINT [DF_t_Bond_DateDueMonthly] DEFAULT (getdate()),
[DateDueYearly] [date] NOT NULL CONSTRAINT [DF_t_Bond_DateDueYearly] DEFAULT (getdate()),
[NotificationBeforeDays] [tinyint] NOT NULL CONSTRAINT [DF_t_Bond_NotificationAfterDays] DEFAULT ((0)),
[NotificationDate] [date] NOT NULL CONSTRAINT [DF_t_Bond_NotificationDate] DEFAULT (getdate()),
[NotificationStop] [bit] NOT NULL CONSTRAINT [DF_t_Bond_NotificationStop] DEFAULT ((0)),
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_NotificationTextAR] DEFAULT (''),
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_NotificationTextEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bond_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Bond_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Bond_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Bond]
ON [Company].[t_Bond]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Voucher, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [PK_t_Bond] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Bond_NumberIs] ON [Company].[t_Bond] ([NumberIs]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [AccountFromKeyBond] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [AccountToKeyBond] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [BuildingKeyBond] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [CurrencyKeyBond] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [RegionKeyBond] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [StatesKeyBond] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Company].[t_Bond] ADD CONSTRAINT [StreetKeyBond] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = In
1 = Out', 'SCHEMA', N'Company', 'TABLE', N't_Bond', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'inside = 0
outside = 1', 'SCHEMA', N'Company', 'TABLE', N't_Bond', 'COLUMN', N'TypeIs'
GO
