CREATE TABLE [Employees].[t_DiscountHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DiscountHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_DiscountHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_RefF] DEFAULT ('0'),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_DiscountHistory_DateIs] DEFAULT (getdate()),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DiscountHistory_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DiscountHistory_TypeID] DEFAULT ([Employees].[f_DiscountTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_TypeIs] DEFAULT ([Employees].[f_DiscountTypeGetFirstName]()),
[FromEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DiscountHistory_FromEmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[FromEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_FromEmployee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[ImplementationIn] [date] NOT NULL CONSTRAINT [DF_t_DiscountHistory_ImplementationIn] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DiscountHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_DiscountHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ValueIs] [float] NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIs] DEFAULT ((0)),
[ValueIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIsF] DEFAULT (''),
[ValueIsD] [float] NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIsD] DEFAULT ((0)),
[ValueIsLL] [float] NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIsLL] DEFAULT ((0)),
[ValueIsEuro] [float] NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIsEuro] DEFAULT ((0)),
[ValueIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIsAR] DEFAULT (''),
[ValueIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_ValueIsEN] DEFAULT (''),
[Why] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_Note] DEFAULT (''),
[CancelIf] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountHistory_CancelIf] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_DiscountHistory_StatusIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_DiscountHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_DiscountHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_DiscountHistory]
ON [Employees].[t_DiscountHistory]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Declare

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
ALTER TABLE [Employees].[t_DiscountHistory] ADD CONSTRAINT [PK_t_DiscountHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_DiscountHistory] ADD CONSTRAINT [CurrencyKeyDiscountHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Employees].[t_DiscountHistory] ADD CONSTRAINT [DiscountTypeKeyDiscountHistory] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_DiscountType] ([ID])
GO
ALTER TABLE [Employees].[t_DiscountHistory] ADD CONSTRAINT [EmployeeFromKeyDiscountHistory] FOREIGN KEY ([FromEmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
ALTER TABLE [Employees].[t_DiscountHistory] ADD CONSTRAINT [EmployeeKeyDiscountHistory] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Normal
1 = AskBefore
2 = Canceled
3 = IsPayment', 'SCHEMA', N'Employees', 'TABLE', N't_DiscountHistory', 'COLUMN', N'StatusIs'
GO
