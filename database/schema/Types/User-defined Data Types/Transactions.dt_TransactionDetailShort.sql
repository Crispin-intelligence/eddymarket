CREATE TYPE [Transactions].[dt_TransactionDetailShort] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[RowNumber] [int] NOT NULL,
[AccountID] [uniqueidentifier] NOT NULL,
[Balance] [float] NOT NULL,
[StatementIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL
)
GO
