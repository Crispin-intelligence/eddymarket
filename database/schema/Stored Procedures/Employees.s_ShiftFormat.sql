SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftFormat] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Rebuilding statistics

            BEGIN --Calculation

                UPDATE Employees.t_Shift
                SET ShiftMinuteMust = DATEDIFF(SECOND, FromIsMust, ToIsMust) / 60.0,
                    EarlyMinute = COALESCE(DATEDIFF(SECOND, FromIs, FromIsMust), 0) / 60.0,
                    LateMinute = COALESCE(DATEDIFF(SECOND, FromIsMust, FromIs), 0) / 60.0,
                    ShiftMinute = COALESCE(DATEDIFF(SECOND, FromIs, ToIs), 0) / 60.0,
                    DateIs = COALESCE(FromIs, FromIsMust)
                WHERE ID = @ID;

            END;

            BEGIN --Fix

                UPDATE Employees.t_Shift
                SET ShiftHourMust = ShiftMinuteMust / 60.0,
                    ShiftHour = ShiftMinute / 60.0,
                    OverTimeMinute = ShiftMinute - ShiftMinuteMust
                WHERE ID = @ID;

                BEGIN --EarlyMinute

                    UPDATE Employees.t_Shift
                    SET EarlyMinute = 0
                    WHERE ID = @ID
                          AND EarlyMinute < 0;

                END;

                BEGIN --LateMinute

                    UPDATE Employees.t_Shift
                    SET LateMinute = 0
                    WHERE ID = @ID
                          AND LateMinute < 0;

                    UPDATE Employees.t_Shift
                    SET LateMinuteNet = LateMinute * LateX
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET LateMinuteExtra = LateMinuteNet - LateMinute
                    WHERE ID = @ID;


                END;

                BEGIN --OverTimeMinute

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute -= IIF(CalculationEarly = 0, EarlyMinute, 0)
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute -= LateMinuteExtra
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute = 0
                    WHERE ID = @ID
                          AND OverTimeMinute < 0;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinuteNet = OverTimeMinute * OverTimeX
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinuteExtra = OverTimeMinuteNet - OverTimeMinute
                    WHERE ID = @ID;

                END;

                BEGIN --TimeIncompleteMinute

                    UPDATE Employees.t_Shift
                    SET TimeIncompleteMinute = IIF(FromIs IS NULL OR ToIs IS NULL,
                                                   ShiftMinuteMust,
                                                   ShiftMinuteMust - ShiftMinuteNet)
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET TimeIncompleteMinute = 0
                    WHERE ID = @ID
                          AND TimeIncompleteMinute < 0;

                END;

                BEGIN --ShiftMinuteNet

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet = ShiftMinute
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet -= IIF(CalculationEarly = 0, EarlyMinute, 0)
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet -= LateMinuteExtra
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet += IIF(CalculationOverTime = 0, 0 - OverTimeMinute, OverTimeMinuteExtra)
                    WHERE ID = @ID;

                    UPDATE Employees.t_Shift
                    SET ShiftHourNet = ShiftMinuteNet / 60.0
                    WHERE ID = @ID;

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
                    TimeIncompleteF = DateTimes.[f_FormatHHMMSS](TimeIncompleteMinute, 'm')
                WHERE ID = @ID;

            END;

        END;

        BEGIN --Rebuilding Statistics t_Employee

            DECLARE @Employee UNIQUEIDENTIFIER;

            SELECT TOP (1)
                   @Employee = t.EmployeeID
            FROM Employees.t_Shift AS t
            WHERE t.ID = @ID
            ORDER BY t.ID;

            UPDATE Employees.t_Employee
            SET InWorkNow = Employees.f_EmployeeGetInWorkNow(ID)
            WHERE ID = @Employee;

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;








GO
