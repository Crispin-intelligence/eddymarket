SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_VacationInsert]
    @TypeID UNIQUEIDENTIFIER,
    @OperationType TINYINT,
    @DescriptionIs NVARCHAR(MAX),
    @Vacation Employees.tt_Vacation READONLY,
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

            SELECT @Ref = ISNULL(MAX(s.Ref), 0)
            FROM Employees.t_Vacation AS s;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Employees.t_Vacation
            (
                Ref,
                RefF,
                DateIs,
                EmployeeID,
                Employee,
                TypeID,
                TypeIs,
                DaysIs,
                OperationType,
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
                   s.DateIs,
                   s.EmployeeID,
                   Employees.f_EmployeeGetName(s.EmployeeID),
                   @TypeID,
                   Employees.f_VacationTypeGetName(@TypeID),
                   s.DaysIs,
                   @OperationType,
                   @DescriptionIs
            FROM @Vacation AS s;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_VacationMoving
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
