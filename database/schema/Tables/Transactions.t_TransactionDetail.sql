CREATE TABLE [Transactions].[t_TransactionDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetail_ID] DEFAULT (newsequentialid()),
[RowNumber] [int] NOT NULL CONSTRAINT [DF_t_TransactionDetail_RowNumber] DEFAULT ((0)),
[TransactionID] [uniqueidentifier] NOT NULL,
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetail_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DateOnly] DEFAULT (getdate()),
[DateFirstDayInMonth] [date] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DateFirstDayInMonth] DEFAULT (getdate()),
[DateFirstDayInYear] [date] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DateFirstDayInYear] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetail_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[CurrencyTypeIs] [int] NOT NULL CONSTRAINT [DF_t_TransactionDetail_CurrencyTypeIs] DEFAULT ([Currencys].[f_CurrencyGetFirstTypeIs]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_TransactionDetail_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[BalanceType] [tinyint] NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceType] DEFAULT ((0)),
[Balance] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceEuro] DEFAULT ((0)),
[BalanceAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceAR] DEFAULT (''),
[BalanceEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_BalanceEN] DEFAULT (''),
[Credit] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_Credit] DEFAULT ((0)),
[CreditD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_CreditD] DEFAULT ((0)),
[CreditLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_CreditLL] DEFAULT ((0)),
[CreditEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_CreditEuro] DEFAULT ((0)),
[Debit] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_Debit] DEFAULT ((0)),
[DebitD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DebitD] DEFAULT ((0)),
[DebitLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DebitLL] DEFAULT ((0)),
[DebitEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DebitEuro] DEFAULT ((0)),
[StatementIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_StatementIs] DEFAULT (''),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_TransactionDetail_TypeIs] DEFAULT ((0)),
[ChequeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_ChequeNumber] DEFAULT (''),
[ChequeImage] [image] NOT NULL CONSTRAINT [DF_t_TransactionDetail_ChequeImage] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ChequeNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_ChequeNote] DEFAULT (''),
[ChequeDateGet] [date] NOT NULL CONSTRAINT [DF_t_TransactionDetail_ChequeDateGet] DEFAULT (getdate()),
[ChequeStopNotificationGet] [bit] NOT NULL CONSTRAINT [DF_t_TransactionDetail_ChequeStopNotificationGet] DEFAULT ((1)),
[NotificationTextAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_NotificationTextAR] DEFAULT (''),
[NotificationTextEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetail_NotificationTextEN] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransactionDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_TransactionDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransactionDetail_WorkStationID] DEFAULT ((1))
) ON [Transactions] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Transactions].[tr_TransactionDetail] ON [Transactions].[t_TransactionDetail]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Transactions.t_TransactionDetail
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_TransactionDetail.ID );

  END;

  BEGIN --DECLARE

    DECLARE @TransactionDetailDay AS TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        DateOnly DATE NOT NULL ,
        BalanceD FLOAT NOT NULL ,
        BalanceLL FLOAT NOT NULL ,
        BalanceEuro FLOAT NOT NULL ,
        CreditD FLOAT NOT NULL ,
        CreditLL FLOAT NOT NULL ,
        CreditEuro FLOAT NOT NULL ,
        DebitD FLOAT NOT NULL ,
        DebitLL FLOAT NOT NULL ,
        DebitEuro FLOAT NOT NULL
      );

    DECLARE @Account AS TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        BalanceD FLOAT NOT NULL ,
        BalanceLL FLOAT NOT NULL ,
        BalanceEuro FLOAT NOT NULL
      );

  END;

  BEGIN --Set info

    INSERT  @TransactionDetailDay
            ( ID ,
              DateOnly ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro ,
              CreditD ,
              CreditLL ,
              CreditEuro ,
              DebitD ,
              DebitLL ,
              DebitEuro
            )
    SELECT  o.AccountID ,
            o.DateOnly ,
            ISNULL(SUM(o.BalanceD), 0) AS BalanceD ,
            ISNULL(SUM(o.BalanceLL), 0) AS BalanceLL ,
            ISNULL(SUM(o.BalanceEuro), 0) AS BalanceEuro ,
            ISNULL(SUM(o.CreditD), 0) AS CreditD ,
            ISNULL(SUM(o.CreditLL), 0) AS CreditLL ,
            ISNULL(SUM(o.CreditEuro), 0) AS CreditEuro ,
            ISNULL(SUM(o.DebitD), 0) AS DebitD ,
            ISNULL(SUM(o.DebitLL), 0) AS DebitLL ,
            ISNULL(SUM(o.DebitEuro), 0) AS DebitEuro
    FROM    ( SELECT  s.AccountID ,
                      s.DateOnly ,
                      s.BalanceD ,
                      s.BalanceLL ,
                      s.BalanceEuro ,
                      s.CreditD ,
                      s.CreditLL ,
                      s.CreditEuro ,
                      s.DebitD ,
                      s.DebitLL ,
                      s.DebitEuro
              FROM    Inserted AS s
              UNION ALL
              SELECT  s.AccountID ,
                      s.DateOnly ,
                      0 - s.BalanceD ,
                      0 - s.BalanceLL ,
                      0 - s.BalanceEuro ,
                      0 - s.CreditD ,
                      0 - s.CreditLL ,
                      0 - s.CreditEuro ,
                      0 - s.DebitD ,
                      0 - s.DebitLL ,
                      0 - s.DebitEuro
              FROM    Deleted AS s
            ) AS o
    GROUP BY o.DateOnly ,
            o.AccountID;

    INSERT  @Account
            ( ID ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro
            )
    SELECT  o.ID ,
            ISNULL(SUM(o.BalanceD), 0) AS BalanceD ,
            ISNULL(SUM(o.BalanceLL), 0) AS BalanceLL ,
            ISNULL(SUM(o.BalanceEuro), 0) AS BalanceEuro
    FROM    @TransactionDetailDay AS o
    GROUP BY o.ID;

  END;

  BEGIN --Fix Account Balance

    MERGE Company.t_Account AS t
    USING @Account AS s
    ON s.ID = t.ID
    WHEN MATCHED THEN
      UPDATE SET
               t.Balance += CASE t.CurrencyTypeIs
                              WHEN 0 THEN s.BalanceD
                              WHEN 1 THEN s.BalanceLL
                              WHEN 2 THEN s.BalanceEuro
                              ELSE 0
                            END ,
               t.BalanceD += s.BalanceD ,
               t.BalanceLL += s.BalanceLL ,
               t.BalanceEuro += s.BalanceEuro;

  END;

  BEGIN --Merge Transaction Detail Day

    MERGE Transactions.t_TransactionDetailByDay AS t
    USING @TransactionDetailDay AS s
    ON s.ID = t.AccountID
      AND s.DateOnly = t.DateOnly
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( AccountID ,
               Account ,
               DateOnly ,
               BalanceD ,
               BalanceLL ,
               BalanceEuro ,
               CreditD ,
               CreditLL ,
               CreditEuro ,
               DebitD ,
               DebitLL ,
               DebitEuro
             )
      VALUES ( s.ID ,
               Company.f_AccountGetName(s.ID) ,
               s.DateOnly ,
               s.BalanceD ,
               s.BalanceLL ,
               s.BalanceEuro ,
               s.CreditD ,
               s.CreditLL ,
               s.CreditEuro ,
               s.DebitD ,
               s.DebitLL ,
               s.DebitEuro
             )
    WHEN MATCHED THEN
      UPDATE SET
               t.BalanceD += s.BalanceD ,
               t.BalanceLL += s.BalanceLL ,
               t.BalanceEuro += s.BalanceEuro ,
               t.CreditD += s.CreditD ,
               t.CreditLL += s.CreditLL ,
               t.CreditEuro += s.CreditEuro ,
               t.DebitD += s.DebitD ,
               t.DebitLL += s.DebitLL ,
               t.DebitEuro += s.DebitEuro;

  END;

  BEGIN --Merge t_ProfitDaily Expenses

    DELETE  FROM @TransactionDetailDay;

    INSERT  @TransactionDetailDay
            ( ID ,
              DateOnly ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro ,
              CreditD ,
              CreditLL ,
              CreditEuro ,
              DebitD ,
              DebitLL ,
              DebitEuro
            )
    SELECT  NEWID() ,
            o.DateOnly ,
            ISNULL(SUM(o.BalanceD), 0) AS BalanceD ,
            ISNULL(SUM(o.BalanceLL), 0) AS BalanceLL ,
            ISNULL(SUM(o.BalanceEuro), 0) AS BalanceEuro ,
            ISNULL(SUM(o.CreditD), 0) AS CreditD ,
            ISNULL(SUM(o.CreditLL), 0) AS CreditLL ,
            ISNULL(SUM(o.CreditEuro), 0) AS CreditEuro ,
            ISNULL(SUM(o.DebitD), 0) AS DebitD ,
            ISNULL(SUM(o.DebitLL), 0) AS DebitLL ,
            ISNULL(SUM(o.DebitEuro), 0) AS DebitEuro
    FROM    ( SELECT  s.DateOnly ,
                      s.BalanceD ,
                      s.BalanceLL ,
                      s.BalanceEuro ,
                      s.CreditD ,
                      s.CreditLL ,
                      s.CreditEuro ,
                      s.DebitD ,
                      s.DebitLL ,
                      s.DebitEuro
              FROM    Inserted AS s
              LEFT JOIN Company.t_Account AS s1 ON s1.ID = s.AccountID
              WHERE   s1.NumberIs BETWEEN 6260400000 AND 6269999999
              UNION ALL
              SELECT  s.DateOnly ,
                      0 - s.BalanceD ,
                      0 - s.BalanceLL ,
                      0 - s.BalanceEuro ,
                      0 - s.CreditD ,
                      0 - s.CreditLL ,
                      0 - s.CreditEuro ,
                      0 - s.DebitD ,
                      0 - s.DebitLL ,
                      0 - s.DebitEuro
              FROM    Deleted AS s
              LEFT JOIN Company.t_Account AS s1 ON s1.ID = s.AccountID
              WHERE   s1.NumberIs BETWEEN 6260400000 AND 6269999999
            ) AS o
    GROUP BY o.DateOnly;

    MERGE Invoices.t_ProfitDaily AS t
    USING @TransactionDetailDay AS s
    ON s.DateOnly = t.DateIs
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( DateIs ,
               ExpensesD ,
               ExpensesLL ,
               ExpensesEuro
             )
      VALUES ( s.DateOnly ,
               s.BalanceD ,
               s.BalanceLL ,
               s.BalanceEuro
             )
    WHEN MATCHED THEN
      UPDATE SET
               t.ExpensesD += s.BalanceD ,
               t.ExpensesLL += s.BalanceLL ,
               t.ExpensesEuro += s.BalanceEuro;

  END;

  BEGIN --Merge t_ProfitDaily Salary

    DELETE  FROM @TransactionDetailDay;

    INSERT  @TransactionDetailDay
            ( ID ,
              DateOnly ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro ,
              CreditD ,
              CreditLL ,
              CreditEuro ,
              DebitD ,
              DebitLL ,
              DebitEuro
            )
    SELECT  NEWID() ,
            o.DateOnly ,
            ISNULL(SUM(o.BalanceD), 0) AS BalanceD ,
            ISNULL(SUM(o.BalanceLL), 0) AS BalanceLL ,
            ISNULL(SUM(o.BalanceEuro), 0) AS BalanceEuro ,
            ISNULL(SUM(o.CreditD), 0) AS CreditD ,
            ISNULL(SUM(o.CreditLL), 0) AS CreditLL ,
            ISNULL(SUM(o.CreditEuro), 0) AS CreditEuro ,
            ISNULL(SUM(o.DebitD), 0) AS DebitD ,
            ISNULL(SUM(o.DebitLL), 0) AS DebitLL ,
            ISNULL(SUM(o.DebitEuro), 0) AS DebitEuro
    FROM    ( SELECT  s.DateOnly ,
                      s.BalanceD ,
                      s.BalanceLL ,
                      s.BalanceEuro ,
                      s.CreditD ,
                      s.CreditLL ,
                      s.CreditEuro ,
                      s.DebitD ,
                      s.DebitLL ,
                      s.DebitEuro
              FROM    Inserted AS s
              LEFT JOIN Company.t_Account AS s1 ON s1.ID = s.AccountID
              WHERE   s1.NumberIs BETWEEN 6310100000 AND 6310199999
              UNION ALL
              SELECT  s.DateOnly ,
                      0 - s.BalanceD ,
                      0 - s.BalanceLL ,
                      0 - s.BalanceEuro ,
                      0 - s.CreditD ,
                      0 - s.CreditLL ,
                      0 - s.CreditEuro ,
                      0 - s.DebitD ,
                      0 - s.DebitLL ,
                      0 - s.DebitEuro
              FROM    Deleted AS s
              LEFT JOIN Company.t_Account AS s1 ON s1.ID = s.AccountID
              WHERE   s1.NumberIs BETWEEN 6310100000 AND 6310199999
            ) AS o
    GROUP BY o.DateOnly;

    MERGE Invoices.t_ProfitDaily AS t
    USING @TransactionDetailDay AS s
    ON s.DateOnly = t.DateIs
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( DateIs ,
               SalaryD ,
               SalaryLL ,
               SalaryEuro
             )
      VALUES ( s.DateOnly ,
               s.BalanceD ,
               s.BalanceLL ,
               s.BalanceEuro
             )
    WHEN MATCHED THEN
      UPDATE SET
               t.SalaryD += s.BalanceD ,
               t.SalaryLL += s.BalanceLL ,
               t.SalaryEuro += s.BalanceEuro;

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'transactionDetail'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'transactionDetail'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, TransactionIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaTransaction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Transactions].[t_TransactionDetail] ADD CONSTRAINT [PK_t_TransactionDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [Transactions]
GO
CREATE NONCLUSTERED INDEX [i_t_TransactionDetail_BalanceType] ON [Transactions].[t_TransactionDetail] ([BalanceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_TransactionDetail_ChequeDateGet] ON [Transactions].[t_TransactionDetail] ([ChequeDateGet]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_TransactionDetail_ChequeStopNotificationGet] ON [Transactions].[t_TransactionDetail] ([ChequeStopNotificationGet]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_TransactionDetail_TypeIs] ON [Transactions].[t_TransactionDetail] ([TypeIs]) ON [PRIMARY]
GO
ALTER TABLE [Transactions].[t_TransactionDetail] ADD CONSTRAINT [AccountKeyTransactionDetail] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Transactions].[t_TransactionDetail] ADD CONSTRAINT [CurrencyKeyTransactionDetail] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Transactions].[t_TransactionDetail] ADD CONSTRAINT [TransactionKeyTransactionDetail] FOREIGN KEY ([TransactionID]) REFERENCES [Transactions].[t_Transaction] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Opening Balance = 1
Ending Balance = 2', 'SCHEMA', N'Transactions', 'TABLE', N't_TransactionDetail', 'COLUMN', N'BalanceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Cash
1 = Cheque
2 = Card', 'SCHEMA', N'Transactions', 'TABLE', N't_TransactionDetail', 'COLUMN', N'TypeIs'
GO
