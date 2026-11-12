CREATE TABLE [Company].[t_OpenBox]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_OpenBox_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_OpenBox_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_OpenBox_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_OpenBox_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_OpenBox_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_OpenBox_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_OpenBox_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_OpenBox_FromAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[FromAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_FromAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[FromAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_FromAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_OpenBox_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_ToAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[ToAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_ToAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_OpenBox_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_OpenBox_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Balance] [float] NOT NULL CONSTRAINT [DF_t_OpenBox_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_OpenBox_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_OpenBox_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_OpenBox_BalanceEuro] DEFAULT ((0)),
[BalanceAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_BalanceAR] DEFAULT (''),
[BalanceEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_BalanceEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_OpenBox_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_OpenBox_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_OpenBox_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_OpenBox]
ON [Company].[t_OpenBox]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, OpenBox, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;


GO
ALTER TABLE [Company].[t_OpenBox] ADD CONSTRAINT [PK_t_OpenBox] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_OpenBox] ADD CONSTRAINT [AccountFromKeyOpenBox] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_OpenBox] ADD CONSTRAINT [AccountToKeyOpenBox] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_OpenBox] ADD CONSTRAINT [CurrencyKeyOpenBox] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Company].[t_OpenBox] ADD CONSTRAINT [UserKeyOpenBox] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
