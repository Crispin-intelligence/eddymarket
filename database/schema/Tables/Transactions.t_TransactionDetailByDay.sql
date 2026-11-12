CREATE TABLE [Transactions].[t_TransactionDetailByDay]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_ID] DEFAULT (newsequentialid()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_Account] DEFAULT ([Company].[f_AccountGetFirstName]()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_DateOnly] DEFAULT (getdate()),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_BalanceEuro] DEFAULT ((0)),
[CreditD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_CreditD] DEFAULT ((0)),
[CreditLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_CreditLL] DEFAULT ((0)),
[CreditEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_CreditEuro] DEFAULT ((0)),
[DebitD] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_DebitD] DEFAULT ((0)),
[DebitLL] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_DebitLL] DEFAULT ((0)),
[DebitEuro] [float] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_DebitEuro] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransactionDetailByDay_WorkStationID] DEFAULT ((1))
) ON [Transactions] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Transactions].[tr_TransactionDetailByDay]
ON [Transactions].[t_TransactionDetailByDay]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @TransactionDetailMonth AS TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            Name NVARCHAR(MAX) NOT NULL,
            DateOnly DATE NOT NULL,
            BalanceD FLOAT NOT NULL,
            BalanceLL FLOAT NOT NULL,
            BalanceEuro FLOAT NOT NULL,
            CreditD FLOAT NOT NULL,
            CreditLL FLOAT NOT NULL,
            CreditEuro FLOAT NOT NULL,
            DebitD FLOAT NOT NULL,
            DebitLL FLOAT NOT NULL,
            DebitEuro FLOAT NOT NULL
        );

    END;

    BEGIN --Set info

        INSERT @TransactionDetailMonth
        (
            ID,
            Name,
            DateOnly,
            BalanceD,
            BalanceLL,
            BalanceEuro,
            CreditD,
            CreditLL,
            CreditEuro,
            DebitD,
            DebitLL,
            DebitEuro
        )
        SELECT o.AccountID,
               MIN(o.Account) AS Account,
               o.DateOnly,
               ISNULL(SUM(o.BalanceD), 0) AS BalanceD,
               ISNULL(SUM(o.BalanceLL), 0) AS BalanceLL,
               ISNULL(SUM(o.BalanceEuro), 0) AS BalanceEuro,
               ISNULL(SUM(o.CreditD), 0) AS CreditD,
               ISNULL(SUM(o.CreditLL), 0) AS CreditLL,
               ISNULL(SUM(o.CreditEuro), 0) AS CreditEuro,
               ISNULL(SUM(o.DebitD), 0) AS DebitD,
               ISNULL(SUM(o.DebitLL), 0) AS DebitLL,
               ISNULL(SUM(o.DebitEuro), 0) AS DebitEuro
        FROM
        (
            SELECT s.AccountID,
                   s.Account,
                   DATEFROMPARTS(YEAR(s.DateOnly), MONTH(s.DateOnly), 1) AS DateOnly,
                   s.BalanceD,
                   s.BalanceLL,
                   s.BalanceEuro,
                   s.CreditD,
                   s.CreditLL,
                   s.CreditEuro,
                   s.DebitD,
                   s.DebitLL,
                   s.DebitEuro
            FROM Inserted AS s
            UNION ALL
            SELECT s.AccountID,
                   s.Account,
                   DATEFROMPARTS(YEAR(s.DateOnly), MONTH(s.DateOnly), 1) AS DateOnly,
                   0 - s.BalanceD,
                   0 - s.BalanceLL,
                   0 - s.BalanceEuro,
                   0 - s.CreditD,
                   0 - s.CreditLL,
                   0 - s.CreditEuro,
                   0 - s.DebitD,
                   0 - s.DebitLL,
                   0 - s.DebitEuro
            FROM Deleted AS s
        ) AS o
        GROUP BY o.DateOnly,
                 o.AccountID;

    END;

    BEGIN --Merge Transaction Detail Month

        MERGE Transactions.t_TransactionDetailByMonth AS t
        USING @TransactionDetailMonth AS s
        ON s.ID = t.AccountID
           AND s.DateOnly = t.DateOnly
        WHEN NOT MATCHED BY TARGET THEN
            INSERT
            (
                AccountID,
                Account,
                DateOnly,
                BalanceD,
                BalanceLL,
                BalanceEuro,
                CreditD,
                CreditLL,
                CreditEuro,
                DebitD,
                DebitLL,
                DebitEuro
            )
            VALUES
            (s.ID, s.Name, s.DateOnly, s.BalanceD, s.BalanceLL, s.BalanceEuro, s.CreditD, s.CreditLL, s.CreditEuro,
             s.DebitD, s.DebitLL, s.DebitEuro)
        WHEN MATCHED THEN
            UPDATE SET t.BalanceD += s.BalanceD,
                       t.BalanceLL += s.BalanceLL,
                       t.BalanceEuro += s.BalanceEuro,
                       t.CreditD += s.CreditD,
                       t.CreditLL += s.CreditLL,
                       t.CreditEuro += s.CreditEuro,
                       t.DebitD += s.DebitD,
                       t.DebitLL += s.DebitLL,
                       t.DebitEuro += s.DebitEuro;

    END;

END;
GO
ALTER TABLE [Transactions].[t_TransactionDetailByDay] ADD CONSTRAINT [PK_t_TransactionDetailByDay] PRIMARY KEY CLUSTERED  ([ID]) ON [Transactions]
GO
ALTER TABLE [Transactions].[t_TransactionDetailByDay] ADD CONSTRAINT [AccountKeyTransactionDetailByDay] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
