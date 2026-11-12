SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftUpdate]
    @FromIsMust DATETIME,
    @FromIs DATETIME,
    @CalculationEarly BIT,
    @LateX DECIMAL(2, 1),
    @ToIsMust DATETIME,
    @ToIs DATETIME,
    @CalculationOverTime BIT,
    @OverTimeX DECIMAL(2, 1),
    @DescriptionIs NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update

            SET @Return = 0;

            UPDATE Employees.t_Shift
            SET FromIsMust = @FromIsMust,
                FromIs = @FromIs,
                CalculationEarly = @CalculationEarly,
                LateX = @LateX,
                ToIsMust = @ToIsMust,
                ToIs = @ToIs,
                CalculationOverTime = @CalculationOverTime,
                OverTimeX = @OverTimeX,
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

        END;

        BEGIN --Rebuilding Statistics

            EXECUTE Employees.s_ShiftFormat @ID;

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
            VALUES
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;






GO
