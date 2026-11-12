CREATE TABLE [Transactions].[t_TransactionDetailByYear]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_ID] DEFAULT (newsequentialid()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_DateOnly] DEFAULT (getdate()),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_BalanceEuro] DEFAULT ((0)),
[CreditD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_CreditD] DEFAULT ((0)),
[CreditLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_CreditLL] DEFAULT ((0)),
[CreditEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_CreditEuro] DEFAULT ((0)),
[DebitD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_DebitD] DEFAULT ((0)),
[DebitLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_DebitLL] DEFAULT ((0)),
[DebitEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_DebitEuro] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransactionDetailByYear_WorkStationID] DEFAULT ((1))
) ON [Transactions] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Transactions].[t_TransactionDetailByYear] ADD CONSTRAINT [PK_t_TransactionDetailByYear] PRIMARY KEY CLUSTERED  ([ID]) ON [Transactions]
GO
ALTER TABLE [Transactions].[t_TransactionDetailByYear] ADD CONSTRAINT [AccountKeyTransactionDetailByYear] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
