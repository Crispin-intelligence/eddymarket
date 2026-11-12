SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftInsert]
    @Employee Employees.tt_Shift READONLY,
    @FromIs DATETIME,
    @ToIs DATETIME,
    @DescriptionIs NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @EventBase NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                RefF NVARCHAR(MAX) NOT NULL
            );

            DECLARE @Return INT,
                    @Ref BIGINT;

        END;

        BEGIN --Set info

            SELECT @Ref = ISNULL(MAX(o.Ref), 0)
            FROM
            (
                SELECT MAX(s.Ref) AS Ref
                FROM Employees.t_Shift AS s
                UNION ALL
                SELECT MAX(s.Ref) AS Ref
                FROM Employees.t_ShiftHistory AS s
            ) AS o;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Employees.t_Shift
            (
                Ref,
                RefF,
                EmployeeID,
                Employee,
                FromIsMust,
                FromIs,
                CalculationEarly,
                LateX,
                ToIsMust,
                ToIs,
                CalculationOverTime,
                OverTimeX,
                DescriptionIs
            )
            OUTPUT Inserted.ID,
                   Inserted.RefF
            INTO @IDs
            (
                ID,
                RefF
            )
            SELECT @Ref + ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
                   FORMAT(@Ref + ROW_NUMBER() OVER (ORDER BY (SELECT 1)), 'n0'),
                   s.EmployeeID,
                   Employees.f_EmployeeGetName(s.EmployeeID),
                   s.FromIsMust,
                   @FromIs,
                   s.CalculationEarly,
                   s.LateX,
                   s.ToIsMust,
                   @ToIs,
                   s.CalculationOverTime,
                   s.OverTimeX,
                   @DescriptionIs
            FROM @Employee AS s;

        END;

        BEGIN --Rebuilding Statistics

            DECLARE @IDs_ Alls.tt_Guid;

            INSERT INTO @IDs_
            (
                ID
            )
            SELECT s.ID
            FROM @IDs AS s;

            EXECUTE Employees.s_ShiftFormats @IDs_;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_ShiftMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   @EventBase + s.RefF,
                   0,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDs AS s;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;






GO
