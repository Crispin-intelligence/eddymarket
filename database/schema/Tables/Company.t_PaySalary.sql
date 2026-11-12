CREATE TABLE [Company].[t_PaySalary]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PaySalary_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_PaySalary_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_PaySalary_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_PaySalary_DateOnly] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_PaySalary_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_PaySalary_DateYearly] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PaySalary_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PaySalary_FromAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[FromAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_FromAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[FromAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_FromAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PaySalary_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_ToAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[ToAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_ToAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PaySalary_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_PaySalary_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Balance] [float] NOT NULL CONSTRAINT [DF_t_PaySalary_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_PaySalary_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_PaySalary_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_PaySalary_BalanceEuro] DEFAULT ((0)),
[BalanceAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_BalanceAR] DEFAULT (''),
[BalanceEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_BalanceEN] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PaySalary_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PaySalary_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PaySalary_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Company].[tr_PaySalary]
ON [Company].[t_PaySalary]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, PaySalary, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;


GO
ALTER TABLE [Company].[t_PaySalary] ADD CONSTRAINT [PK_t_PaySalary] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_PaySalary] ADD CONSTRAINT [AccountFromKeyPaySalary] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_PaySalary] ADD CONSTRAINT [AccountToKeyPaySalary] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_PaySalary] ADD CONSTRAINT [CurrencyKeyPaySalary] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Company].[t_PaySalary] ADD CONSTRAINT [UserKeyPaySalary] FOREIGN KEY ([UserID]) REFERENCES [Users].[t_User] ([ID])
GO
