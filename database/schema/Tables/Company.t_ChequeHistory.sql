CREATE TABLE [Company].[t_ChequeHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChequeHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_ChequeHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_RefF] DEFAULT ('0'),
[NumberIs] [int] NOT NULL CONSTRAINT [DF_t_ChequeHistory_NumberIs] DEFAULT ((0)),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_ChequeHistory_DateIs] DEFAULT (getdate()),
[BankID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChequeHistory_BankID] DEFAULT ([Company].[f_BankGetFirstID]()),
[Bank] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_Bank] DEFAULT ([Company].[f_BankGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChequeHistory_BeneficiaryAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChequeHistory_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChequeHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ChequeHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Amount] [float] NOT NULL CONSTRAINT [DF_t_ChequeHistory_Amount] DEFAULT ((0)),
[AmountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_AmountF] DEFAULT ('0'),
[AmountD] [float] NOT NULL CONSTRAINT [DF_t_ChequeHistory_AmountD] DEFAULT ((0)),
[AmountLL] [float] NOT NULL CONSTRAINT [DF_t_ChequeHistory_AmountLL] DEFAULT ((0)),
[AmountEuro] [float] NOT NULL CONSTRAINT [DF_t_ChequeHistory_AmountEuro] DEFAULT ((0)),
[AmountAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_AmountAR] DEFAULT (''),
[AmountEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_AmountEN] DEFAULT (''),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ChequeHistory_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[Crosscheck] [bit] NOT NULL CONSTRAINT [DF_t_ChequeHistory_Crosscheck] DEFAULT ((1)),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_ChequeHistory_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_TypeIsAR] DEFAULT (''),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_TypeIsEN] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_ChequeHistory_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[DateDue] [date] NOT NULL CONSTRAINT [DF_t_ChequeHistory_DateDue] DEFAULT (getdate()),
[DateDueMonthly] [date] NOT NULL CONSTRAINT [DF_t_ChequeHistory_DateDueMonthly] DEFAULT (getdate()),
[DateDueYearly] [date] NOT NULL CONSTRAINT [DF_t_ChequeHistory_DateDueYearly] DEFAULT (getdate()),
[NotificationBeforeDays] [tinyint] NOT NULL CONSTRAINT [DF_t_ChequeHistory_NotificationAfterDays] DEFAULT ((0)),
[NotificationDate] [date] NOT NULL CONSTRAINT [DF_t_ChequeHistory_NotificationDate] DEFAULT (getdate()),
[NotificationStop] [bit] NOT NULL CONSTRAINT [DF_t_ChequeHistory_NotificationStop] DEFAULT ((0)),
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_NotificationTextAR] DEFAULT (''),
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_NotificationTextEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ChequeHistory_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ChequeHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ChequeHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_ChequeHistory]
ON [Company].[t_ChequeHistory]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Cheque, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Company].[t_ChequeHistory] ADD CONSTRAINT [PK_t_ChequeHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_ChequeHistory] ADD CONSTRAINT [AccountFromKeyChequeHistory] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_ChequeHistory] ADD CONSTRAINT [AccountToKeyChequeHistory] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_ChequeHistory] ADD CONSTRAINT [BankKeyChequeHistory] FOREIGN KEY ([BankID]) REFERENCES [Company].[t_Bank] ([ID])
GO
ALTER TABLE [Company].[t_ChequeHistory] ADD CONSTRAINT [BuildingKeyChequeHistory] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Company].[t_ChequeHistory] ADD CONSTRAINT [CurrencyKeyChequeHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = In
1 = Out', 'SCHEMA', N'Company', 'TABLE', N't_ChequeHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'inside = 0
outside = 1', 'SCHEMA', N'Company', 'TABLE', N't_ChequeHistory', 'COLUMN', N'TypeIs'
GO
