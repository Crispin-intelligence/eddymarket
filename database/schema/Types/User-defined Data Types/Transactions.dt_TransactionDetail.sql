CREATE TYPE [Transactions].[dt_TransactionDetail] AS TABLE
(
[ID] [uniqueidentifier] NOT NULL,
[RowNumber] [int] NOT NULL,
[AccountID] [uniqueidentifier] NOT NULL,
[DateIs] [datetime] NOT NULL,
[Balance] [float] NOT NULL,
[StatementIs] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[TypeIs] [tinyint] NOT NULL,
[ChequeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ChequeImage] [image] NOT NULL,
[ChequeNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[ChequeDateGet] [date] NOT NULL,
[ChequeStopNotificationGet] [bit] NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL,
[ExchangeRate] [decimal] (18, 2) NOT NULL,
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
