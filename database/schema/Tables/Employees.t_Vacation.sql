CREATE TABLE [Employees].[t_Vacation]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vacation_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Vacation_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vacation_RefF] DEFAULT ('0'),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Vacation_DateIs] DEFAULT (getdate()),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vacation_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vacation_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Vacation_TypeID] DEFAULT ([Employees].[f_VacationTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vacation_TypeIs] DEFAULT ([Employees].[f_VacationTypeGetFirstName]()),
[DaysIs] [int] NOT NULL CONSTRAINT [DF_t_Vacation_DaysIs] DEFAULT ((0)),
[OperationType] [tinyint] NOT NULL CONSTRAINT [DF_t_Vacation_OperationType] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Vacation_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Vacation_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Vacation_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_Vacation]
ON [Employees].[t_Vacation]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Declare

        DECLARE @Employee TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            DaysIs INT NOT NULL
        );

        DECLARE @VacationType TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL,
            VacationAddC BIGINT NOT NULL,
            VacationUseC BIGINT NOT NULL,
            VacationDiscountedC BIGINT NOT NULL,
            VacationC BIGINT NOT NULL
        );

    END;

    BEGIN --Set info

        INSERT INTO @Employee
        (
            ID,
            DaysIs
        )
        SELECT o.EmployeeID,
               COALESCE(SUM(o.DaysIs), 0)
        FROM
        (
            SELECT s.EmployeeID,
                   s.DaysIs
            FROM Inserted AS s
            WHERE s.OperationType <> 2
            UNION ALL
            SELECT s.EmployeeID,
                   0 - s.DaysIs
            FROM Deleted AS s
            WHERE s.OperationType <> 2
        ) AS o
        GROUP BY o.EmployeeID;

        INSERT INTO @VacationType
        (
            ID,
            VacationAddC,
            VacationUseC,
            VacationDiscountedC,
            VacationC
        )
        SELECT o.TypeID,
               COALESCE(SUM(o.VacationAddC), 0),
               COALESCE(SUM(o.VacationUseC), 0),
               COALESCE(SUM(o.VacationDiscountedC), 0),
               COALESCE(SUM(o.VacationC), 0)
        FROM
        (
            SELECT s.TypeID,
                   IIF(s.OperationType = 0, s.DaysIs, 0) AS VacationAddC,
                   IIF(s.OperationType = 1, s.DaysIs, 0) AS VacationUseC,
                   IIF(s.OperationType = 2, s.DaysIs, 0) AS VacationDiscountedC,
                   1 AS VacationC
            FROM Inserted AS s
            UNION ALL
            SELECT s.TypeID,
                   IIF(s.OperationType = 0, 0 - s.DaysIs, 0) AS VacationAddC,
                   IIF(s.OperationType = 1, 0 - s.DaysIs, 0) AS VacationUseC,
                   IIF(s.OperationType = 2, 0 - s.DaysIs, 0) AS VacationDiscountedC,
                   -1 AS VacationC
            FROM Deleted AS s
        ) AS o
        GROUP BY o.TypeID;

    END;

    BEGIN --Fix vacation of employee

        MERGE Employees.t_Employee AS t
        USING @Employee AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.VacationAvailableC += s.DaysIs;

    END;

    BEGIN --Fix vacation of type

        MERGE Employees.t_VacationType AS t
        USING @VacationType AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
            UPDATE SET t.VacationAddC += s.VacationAddC,
                       t.VacationUseC += s.VacationUseC,
                       t.VacationNet += (s.VacationAddC + s.VacationUseC),
                       t.VacationDiscountedC += s.VacationDiscountedC,
                       t.VacationC += s.VacationC;

    END;

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Vacation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Employees].[t_Vacation] ADD CONSTRAINT [PK_t_Vacation] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Vacation_Ref] ON [Employees].[t_Vacation] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_Vacation] ADD CONSTRAINT [EmployeeKeyVacation] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
ALTER TABLE [Employees].[t_Vacation] ADD CONSTRAINT [VacationTypeKeyVacation] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_VacationType] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'- or +', 'SCHEMA', N'Employees', 'TABLE', N't_Vacation', 'COLUMN', N'DaysIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Add Vacations
1 = Use Vacations
2 = Discounted Vacations', 'SCHEMA', N'Employees', 'TABLE', N't_Vacation', 'COLUMN', N'OperationType'
GO
