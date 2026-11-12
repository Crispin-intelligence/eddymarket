SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftUpdateTo]
    @ToIsMust DATETIME,
    @ToIs DATETIME,
    @CalculationOverTime BIT,
    @OverTimeX DECIMAL(2, 1),
    @UserID UNIQUEIDENTIFIER,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDs Alls.tt_IDAndEvent READONLY
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
            SET ToIsMust = DATETIMEFROMPARTS(
                                                YEAR(ToIsMust),
                                                MONTH(ToIsMust),
                                                DAY(ToIsMust),
                                                DATEPART(HOUR, @ToIsMust),
                                                DATEPART(MINUTE, @ToIsMust),
                                                DATEPART(SECOND, @ToIsMust),
                                                DATEPART(MILLISECOND, @ToIsMust)
                                            ),
                ToIs = CASE
                           WHEN ToIs IS NOT NULL THEN
                               DATETIMEFROMPARTS(
                                                    YEAR(ToIs),
                                                    MONTH(ToIs),
                                                    DAY(ToIs),
                                                    DATEPART(HOUR, @ToIs),
                                                    DATEPART(MINUTE, @ToIs),
                                                    DATEPART(SECOND, @ToIs),
                                                    DATEPART(MILLISECOND, @ToIs)
                                                )
                           ELSE
                               DATETIMEFROMPARTS(
                                                    YEAR(ToIsMust),
                                                    MONTH(ToIsMust),
                                                    DAY(ToIsMust),
                                                    DATEPART(HOUR, @ToIs),
                                                    DATEPART(MINUTE, @ToIs),
                                                    DATEPART(SECOND, @ToIs),
                                                    DATEPART(MILLISECOND, @ToIs)
                                                )
                       END,
                CalculationOverTime = @CalculationOverTime,
                OverTimeX = @OverTimeX
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
            );

        END;

        BEGIN --Rebuilding Statistics

            BEGIN --Declare

                DECLARE @IDs_ AS Alls.tt_Guid;

            END;

            BEGIN --Set info

                INSERT INTO @IDs_
                (
                    ID
                )
                SELECT s.ID
                FROM @IDs AS s;

            END;

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
                   s.EventIs,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDs AS s;

        END;

        COMMIT TRANSACTION;

        Select 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        Select @Return;

    END CATCH;

END;







GO
