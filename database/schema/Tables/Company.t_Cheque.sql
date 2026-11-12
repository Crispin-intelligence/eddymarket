CREATE TABLE [Company].[t_Cheque]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Cheque_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Cheque_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_RefF] DEFAULT ('0'),
[NumberIs] [int] NOT NULL CONSTRAINT [DF_t_Cheque_NumberIs] DEFAULT ((0)),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Cheque_DateIs] DEFAULT (getdate()),
[BankID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Cheque_BankID] DEFAULT ([Company].[f_BankGetFirstID]()),
[Bank] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_Bank] DEFAULT ([Company].[f_BankGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Cheque_BeneficiaryAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Cheque_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Cheque_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Cheque_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Amount] [float] NOT NULL CONSTRAINT [DF_t_Cheque_Amount] DEFAULT ((0)),
[AmountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_AmountF] DEFAULT ('0'),
[AmountD] [float] NOT NULL CONSTRAINT [DF_t_Cheque_AmountD] DEFAULT ((0)),
[AmountLL] [float] NOT NULL CONSTRAINT [DF_t_Cheque_AmountLL] DEFAULT ((0)),
[AmountEuro] [float] NOT NULL CONSTRAINT [DF_t_Cheque_AmountEuro] DEFAULT ((0)),
[AmountAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_AmountAR] DEFAULT (''),
[AmountEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_AmountEN] DEFAULT (''),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Cheque_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[Crosscheck] [bit] NOT NULL CONSTRAINT [DF_t_Cheque_Crosscheck] DEFAULT ((1)),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Cheque_TypeIs] DEFAULT ((0)),
[TypeIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_TypeIsAR] DEFAULT (''),
[TypeIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_TypeIsEN] DEFAULT (''),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_Cheque_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[DateDue] [date] NOT NULL CONSTRAINT [DF_t_Cheque_DateDue] DEFAULT (getdate()),
[DateDueMonthly] [date] NOT NULL CONSTRAINT [DF_t_Cheque_DateDueMonthly] DEFAULT (getdate()),
[DateDueYearly] [date] NOT NULL CONSTRAINT [DF_t_Cheque_DateDueYearly] DEFAULT (getdate()),
[NotificationBeforeDays] [tinyint] NOT NULL CONSTRAINT [DF_t_Cheque_NotificationAfterDays] DEFAULT ((0)),
[NotificationDate] [date] NOT NULL CONSTRAINT [DF_t_Cheque_NotificationDate] DEFAULT (getdate()),
[NotificationStop] [bit] NOT NULL CONSTRAINT [DF_t_Cheque_NotificationStop] DEFAULT ((0)),
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_NotificationTextAR] DEFAULT (''),
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_NotificationTextEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Cheque_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Cheque_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Cheque_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Cheque]
ON [Company].[t_Cheque]
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
ALTER TABLE [Company].[t_Cheque] ADD CONSTRAINT [PK_t_Cheque] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Cheque_BankID_NumberIs] ON [Company].[t_Cheque] ([BankID], [NumberIs]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Cheque] ADD CONSTRAINT [AccountFromKeyCheque] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Cheque] ADD CONSTRAINT [AccountToKeyCheque] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_Cheque] ADD CONSTRAINT [BankKeyCheque] FOREIGN KEY ([BankID]) REFERENCES [Company].[t_Bank] ([ID])
GO
ALTER TABLE [Company].[t_Cheque] ADD CONSTRAINT [BuildingKeyCheque] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Company].[t_Cheque] ADD CONSTRAINT [CurrencyKeyCheque] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = In
1 = Out', 'SCHEMA', N'Company', 'TABLE', N't_Cheque', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'inside = 0
outside = 1', 'SCHEMA', N'Company', 'TABLE', N't_Cheque', 'COLUMN', N'TypeIs'
GO
