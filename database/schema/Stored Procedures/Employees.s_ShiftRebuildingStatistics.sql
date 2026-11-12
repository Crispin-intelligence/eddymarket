SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Rebuilding statistics

            BEGIN --Calculation

                UPDATE Employees.t_Shift
                SET ShiftMinuteMust = DATEDIFF(SECOND, FromIsMust, ToIsMust) / 60.0,
                    EarlyMinute = COALESCE(DATEDIFF(SECOND, FromIs, FromIsMust), 0) / 60.0,
                    LateMinute = COALESCE(DATEDIFF(SECOND, FromIsMust, FromIs), 0) / 60.0,
                    ShiftMinute = COALESCE(DATEDIFF(SECOND, FromIs, ToIs), 0) / 60.0,
                    DateIs = COALESCE(FromIs, FromIsMust);

            END;

            BEGIN --Fix

                UPDATE Employees.t_Shift
                SET ShiftHourMust = ShiftMinuteMust / 60.0,
                    ShiftHour = ShiftMinute / 60.0,
                    OverTimeMinute = ShiftMinute - ShiftMinuteMust;

                BEGIN --EarlyMinute

                    UPDATE Employees.t_Shift
                    SET EarlyMinute = 0
                    WHERE EarlyMinute < 0;

                END;

                BEGIN --LateMinute

                    UPDATE Employees.t_Shift
                    SET LateMinute = 0
                    WHERE LateMinute < 0;

                    UPDATE Employees.t_Shift
                    SET LateMinuteNet = LateMinute * LateX;

                    UPDATE Employees.t_Shift
                    SET LateMinuteExtra = LateMinuteNet - LateMinute;

                END;

                BEGIN --OverTimeMinute

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute -= IIF(CalculationEarly = 0, EarlyMinute, 0);

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute -= LateMinuteExtra;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute = 0
                    WHERE OverTimeMinute < 0;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinuteNet = OverTimeMinute * OverTimeX;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinuteExtra = OverTimeMinuteNet - OverTimeMinute;

                END;

                BEGIN --ShiftMinuteNet

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet = ShiftMinute;

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet -= IIF(CalculationEarly = 0, EarlyMinute, 0);

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet -= LateMinuteExtra;

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet += IIF(CalculationOverTime = 0, 0 - OverTimeMinute, OverTimeMinuteExtra);

                    UPDATE Employees.t_Shift
                    SET ShiftHourNet = ShiftMinuteNet / 60.0;

                END;

                BEGIN --TimeIncompleteMinute

                    UPDATE Employees.t_Shift
                    SET TimeIncompleteMinute = IIF(FromIs IS NULL OR ToIs IS NULL,
                                                   ShiftMinuteMust,
                                                   ShiftMinuteMust - ShiftMinuteNet);

                    UPDATE Employees.t_Shift
                    SET TimeIncompleteMinute = 0
                    WHERE TimeIncompleteMinute < 0;

                END;

            END;

            BEGIN --Format

                UPDATE Employees.t_Shift
                SET ShiftMustF = DateTimes.[f_FormatHHMMSS](ShiftMinuteMust, 'm'),
                    EarlyF = DateTimes.[f_FormatHHMMSS](EarlyMinute, 'm'),
                    LateF = DateTimes.[f_FormatHHMMSS](LateMinute, 'm'),
                    LateNetF = DateTimes.[f_FormatHHMMSS](LateMinuteNet, 'm'),
                    LateExtraF = DateTimes.[f_FormatHHMMSS](LateMinuteExtra, 'm'),
                    ShiftF = DateTimes.[f_FormatHHMMSS](ShiftMinute, 'm'),
                    OverTimeF = DateTimes.[f_FormatHHMMSS](OverTimeMinute, 'm'),
                    OverTimeNetF = DateTimes.[f_FormatHHMMSS](OverTimeMinuteNet, 'm'),
                    OverTimeExtraF = DateTimes.[f_FormatHHMMSS](OverTimeMinuteExtra, 'm'),
                    ShiftNetF = DateTimes.[f_FormatHHMMSS](ShiftMinuteNet, 'm'),
                    TimeIncompleteF = DateTimes.[f_FormatHHMMSS](TimeIncompleteMinute, 'm');

            END;

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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

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
