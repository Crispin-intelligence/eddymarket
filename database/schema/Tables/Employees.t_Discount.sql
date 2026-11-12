CREATE TABLE [Employees].[t_Discount]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Discount_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Discount_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_RefF] DEFAULT ('0'),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Discount_DateIs] DEFAULT (getdate()),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Discount_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Discount_TypeID] DEFAULT ([Employees].[f_DiscountTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_TypeIs] DEFAULT ([Employees].[f_DiscountTypeGetFirstName]()),
[FromEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Discount_FromEmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[FromEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_FromEmployee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[ImplementationIn] [date] NOT NULL CONSTRAINT [DF_t_Discount_ImplementationIn] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Discount_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Discount_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ValueIs] [float] NOT NULL CONSTRAINT [DF_t_Discount_ValueIs] DEFAULT ((0)),
[ValueIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_ValueIsF] DEFAULT (''),
[ValueIsD] [float] NOT NULL CONSTRAINT [DF_t_Discount_ValueIsD] DEFAULT ((0)),
[ValueIsLL] [float] NOT NULL CONSTRAINT [DF_t_Discount_ValueIsLL] DEFAULT ((0)),
[ValueIsEuro] [float] NOT NULL CONSTRAINT [DF_t_Discount_ValueIsEuro] DEFAULT ((0)),
[ValueIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_ValueIsAR] DEFAULT (''),
[ValueIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_ValueIsEN] DEFAULT (''),
[Why] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_Note] DEFAULT (''),
[CancelIf] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Discount_CancelIf] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Discount_StatusIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Discount_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Discount_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_Discount]
ON [Employees].[t_Discount]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Declare

        DECLARE @Employee TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            DiscountAvailable FLOAT NOT NULL
        );

        DECLARE @DiscountType TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            DiscountTotalD FLOAT NOT NULL,
            DiscountTotalLL FLOAT NOT NULL,
            DiscountTotalEuro FLOAT NOT NULL,
            DiscountC BIGINT NOT NULL
        );

    END;

    BEGIN --Set info

        INSERT INTO @Employee
        (
            ID,
            DiscountAvailable
        )
        SELECT o.EmployeeID,
               COALESCE(SUM(o.DiscountAvailable), 0)
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
                   END AS DiscountAvailable
            FROM Inserted AS s
                LEFT JOIN Employees.t_Employee AS s1
                    ON s1.ID = s.EmployeeID
                LEFT JOIN Currencys.t_Currency AS s2
                    ON s2.ID = s1.CurrencyID
            WHERE s.StatusIs <= 1
            UNION ALL
            SELECT s.EmployeeID,
                   0 - CASE s2.TypeIs
                           WHEN 0 THEN
                               s.ValueIsD
                           WHEN 1 THEN
                               s.ValueIsLL
                           ELSE
                               s.ValueIsEuro
                       END AS DiscountAvailable
            FROM Deleted AS s
                LEFT JOIN Employees.t_Employee AS s1
                    ON s1.ID = s.EmployeeID
                LEFT JOIN Currencys.t_Currency AS s2
                    ON s2.ID = s1.CurrencyID
            WHERE s.StatusIs <= 2
        ) AS o
        GROUP BY o.EmployeeID;

        INSERT INTO @DiscountType
        (
            ID,
            DiscountTotalD,
            DiscountTotalLL,
            DiscountTotalEuro,
            DiscountC
        )
        SELECT o.TypeID,
               COALESCE(SUM(o.DiscountTotalD), 0),
               COALESCE(SUM(o.DiscountTotalLL), 0),
               COALESCE(SUM(o.DiscountTotalEuro), 0),
               COALESCE(SUM(o.DiscountC), 0)
        FROM
        (
            SELECT s.TypeID,
                   s.ValueIsD AS DiscountTotalD,
                   s.ValueIsLL AS DiscountTotalLL,
                   s.ValueIsEuro AS DiscountTotalEuro,
                   1 AS DiscountC
            FROM Inserted AS s
            UNION ALL
            SELECT s.TypeID,
                   0 - s.ValueIsD AS DiscountTotalD,
                   0 - s.ValueIsLL AS DiscountTotalLL,
                   0 - s.ValueIsEuro AS DiscountTotalEuro,
                   -1 AS DiscountC
            FROM Deleted AS s
        ) AS o
        GROUP BY o.TypeID;

    END;

    BEGIN --Fix t_Employee

        MERGE Employees.t_Employee AS t
        USING @Employee AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.DiscountAvailable += s.DiscountAvailable,
                       t.DiscountAvailableF = Currencys.f_Format(
                                                                    t.CurrencyID,
                                                                    t.DiscountAvailable + s.DiscountAvailable
                                                                );

    END;

    BEGIN --Fix t_DiscountType

        MERGE Employees.t_DiscountType AS t
        USING @DiscountType AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.DiscountTotalD += s.DiscountTotalD,
                       t.DiscountTotalLL += s.DiscountTotalLL,
                       t.DiscountTotalEuro += s.DiscountTotalEuro,
                       t.DiscountC += s.DiscountC;

    END;

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Discount, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Employees].[t_Discount] ADD CONSTRAINT [PK_t_Discount] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Discount_Ref] ON [Employees].[t_Discount] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_Discount] ADD CONSTRAINT [CurrencyKeyDiscount] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Employees].[t_Discount] ADD CONSTRAINT [DiscountTypeKeyDiscount] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_DiscountType] ([ID])
GO
ALTER TABLE [Employees].[t_Discount] ADD CONSTRAINT [EmployeeFromKeyDiscount] FOREIGN KEY ([FromEmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
ALTER TABLE [Employees].[t_Discount] ADD CONSTRAINT [EmployeeKeyDiscount] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Normal
1 = AskBefore
2 = Canceled
3 = IsPayment', 'SCHEMA', N'Employees', 'TABLE', N't_Discount', 'COLUMN', N'StatusIs'
GO
