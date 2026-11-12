CREATE TABLE [Employees].[t_Bonus]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bonus_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Bonus_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_RefF] DEFAULT ('0'),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Bonus_DateIs] DEFAULT (getdate()),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bonus_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bonus_TypeID] DEFAULT ([Employees].[f_BonusTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_TypeIs] DEFAULT ([Employees].[f_BonusTypeGetFirstName]()),
[FromEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bonus_FromEmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[FromEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_FromEmployee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[ImplementationIn] [date] NOT NULL CONSTRAINT [DF_t_Bonus_ImplementationIn] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bonus_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Bonus_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ValueIs] [float] NOT NULL CONSTRAINT [DF_t_Bonus_ValueIs] DEFAULT ((0)),
[ValueIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_ValueIsF] DEFAULT (''),
[ValueIsD] [float] NOT NULL CONSTRAINT [DF_t_Bonus_ValueIsD] DEFAULT ((0)),
[ValueIsLL] [float] NOT NULL CONSTRAINT [DF_t_Bonus_ValueIsLL] DEFAULT ((0)),
[ValueIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Bonus_ValueIsEuro] DEFAULT ((0)),
[ValueIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_ValueIsAR] DEFAULT (''),
[ValueIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_ValueIsEN] DEFAULT (''),
[Why] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bonus_Note] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Bonus_StatusIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Bonus_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Bonus_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_Bonus]
ON [Employees].[t_Bonus]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Declare

        DECLARE @Employee TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            BonusAvailable FLOAT NOT NULL
        );

        DECLARE @BonusType TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            BonusTotalD FLOAT NOT NULL,
            BonusTotalLL FLOAT NOT NULL,
            BonusTotalEuro FLOAT NOT NULL,
            BonusC BIGINT NOT NULL
        );

    END;

    BEGIN --Set info

        INSERT INTO @Employee
        (
            ID,
            BonusAvailable
        )
        SELECT o.EmployeeID,
               COALESCE(SUM(o.BonusAvailable), 0)
        FROM
        (
            SELECT s.EmployeeID,
                   CASE s2.TypeIs
                       WHEN 0 THEN
                           s.ValueIsD
                       WHEN 1 THEN
                           s.ValueIsLL
                       ELSE
                           s.ValueIsEuro
                   END AS BonusAvailable
            FROM Inserted AS s
                LEFT JOIN Employees.t_Employee AS s1
                    ON s1.ID = s.EmployeeID
                LEFT JOIN Currencys.t_Currency AS s2
                    ON s2.ID = s1.CurrencyID
            WHERE s.StatusIs = 0
            UNION ALL
            SELECT s.EmployeeID,
                   0 - CASE s2.TypeIs
                           WHEN 0 THEN
                               s.ValueIsD
                           WHEN 1 THEN
                               s.ValueIsLL
                           ELSE
                               s.ValueIsEuro
                       END AS BonusAvailable
            FROM Deleted AS s
                LEFT JOIN Employees.t_Employee AS s1
                    ON s1.ID = s.EmployeeID
                LEFT JOIN Currencys.t_Currency AS s2
                    ON s2.ID = s1.CurrencyID
            WHERE s.StatusIs = 0
        ) AS o
        GROUP BY o.EmployeeID;

        INSERT INTO @BonusType
        (
            ID,
            BonusTotalD,
            BonusTotalLL,
            BonusTotalEuro,
            BonusC
        )
        SELECT o.TypeID,
               COALESCE(SUM(o.BonusTotalD), 0),
               COALESCE(SUM(o.BonusTotalLL), 0),
               COALESCE(SUM(o.BonusTotalEuro), 0),
               COALESCE(SUM(o.BonusC), 0)
        FROM
        (
            SELECT s.TypeID,
                   s.ValueIsD AS BonusTotalD,
                   s.ValueIsLL AS BonusTotalLL,
                   s.ValueIsEuro AS BonusTotalEuro,
                   1 AS BonusC
            FROM Inserted AS s
            UNION ALL
            SELECT s.TypeID,
                   0 - s.ValueIsD AS BonusTotalD,
                   0 - s.ValueIsLL AS BonusTotalLL,
                   0 - s.ValueIsEuro AS BonusTotalEuro,
                   -1 AS BonusC
            FROM Deleted AS s
        ) AS o
        GROUP BY o.TypeID;

    END;

    BEGIN --Fix t_Employee

        MERGE Employees.t_Employee AS t
        USING @Employee AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.BonusAvailable += s.BonusAvailable,
                       t.BonusAvailableF = Currencys.f_Format(t.CurrencyID, t.BonusAvailable + s.BonusAvailable);

    END;

    BEGIN --Fix t_BonusType

        MERGE Employees.t_BonusType AS t
        USING @BonusType AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.BonusTotalD += s.BonusTotalD,
                       t.BonusTotalLL += s.BonusTotalLL,
                       t.BonusTotalEuro += s.BonusTotalEuro,
                       t.BonusC += s.BonusC;

    END;

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, EmployeeBonus, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;

GO
ALTER TABLE [Employees].[t_Bonus] ADD CONSTRAINT [PK_t_Bonus] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Bonus_Ref] ON [Employees].[t_Bonus] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_Bonus] ADD CONSTRAINT [BonusTypeKeyBonus] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_BonusType] ([ID])
GO
ALTER TABLE [Employees].[t_Bonus] ADD CONSTRAINT [CurrencyKeyBonus] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Employees].[t_Bonus] ADD CONSTRAINT [EmployeeFromKeyBonus] FOREIGN KEY ([FromEmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
ALTER TABLE [Employees].[t_Bonus] ADD CONSTRAINT [EmployeeKeyBonus] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Normal
1 = Canceled
2 = IsPayment', 'SCHEMA', N'Employees', 'TABLE', N't_Bonus', 'COLUMN', N'StatusIs'
GO
