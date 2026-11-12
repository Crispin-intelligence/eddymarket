SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftUpdateFrom]
    @FromIsMust DATETIME,
    @FromIs DATETIME,
    @CalculationEarly BIT,
    @LateX DECIMAL(2, 1),
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
            SET FromIsMust = DATETIMEFROMPARTS(
                                                  YEAR(FromIsMust),
                                                  MONTH(FromIsMust),
                                                  DAY(FromIsMust),
                                                  DATEPART(HOUR, @FromIsMust),
                                                  DATEPART(MINUTE, @FromIsMust),
                                                  DATEPART(SECOND, @FromIsMust),
                                                  DATEPART(MILLISECOND, @FromIsMust)
                                              ),
                FromIs = CASE
                             WHEN FromIs IS NOT NULL THEN
                                 DATETIMEFROMPARTS(
                                                      YEAR(FromIs),
                                                      MONTH(FromIs),
                                                      DAY(FromIs),
                                                      DATEPART(HOUR, @FromIs),
                                                      DATEPART(MINUTE, @FromIs),
                                                      DATEPART(SECOND, @FromIs),
                                                      DATEPART(MILLISECOND, @FromIs)
                                                  )
                             ELSE
                                 DATETIMEFROMPARTS(
                                                      YEAR(FromIsMust),
                                                      MONTH(FromIsMust),
                                                      DAY(FromIsMust),
                                                      DATEPART(HOUR, @FromIs),
                                                      DATEPART(MINUTE, @FromIs),
                                                      DATEPART(SECOND, @FromIs),
                                                      DATEPART(MILLISECOND, @FromIs)
                                                  )
                         END,
                CalculationEarly = @CalculationEarly,
                LateX = @LateX
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

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;







GO
