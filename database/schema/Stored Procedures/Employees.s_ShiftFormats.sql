SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftFormats] @IDs Alls.tt_Guid READONLY
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
                WHERE EXISTS
                (
                    SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                );

            END;

            BEGIN --Fix

                UPDATE Employees.t_Shift
                SET ShiftHourMust = ShiftMinuteMust / 60.0,
                    ShiftHour = ShiftMinute / 60.0,
                    OverTimeMinute = ShiftMinute - ShiftMinuteMust
                WHERE EXISTS
                (
                    SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                );

                BEGIN --EarlyMinute

                    UPDATE Employees.t_Shift
                    SET EarlyMinute = 0
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    )
                          AND EarlyMinute < 0;

                END;

                BEGIN --LateMinute

                    UPDATE Employees.t_Shift
                    SET LateMinute = 0
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    )
                          AND LateMinute < 0;

                    UPDATE Employees.t_Shift
                    SET LateMinuteNet = LateMinute * LateX
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET LateMinuteExtra = LateMinuteNet - LateMinute
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                END;

                BEGIN --OverTimeMinute

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute -= IIF(CalculationEarly = 0, EarlyMinute, 0)
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute -= LateMinuteExtra
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET OverTimeMinute = 0
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    )
                          AND OverTimeMinute < 0;

                    UPDATE Employees.t_Shift
                    SET OverTimeMinuteNet = OverTimeMinute * OverTimeX
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET OverTimeMinuteExtra = OverTimeMinuteNet - OverTimeMinute
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    BEGIN --TimeIncompleteMinute

                        UPDATE Employees.t_Shift
                        SET TimeIncompleteMinute = IIF(FromIs IS NULL OR ToIs IS NULL,
                                                       ShiftMinuteMust,
                                                       ShiftMinuteMust - ShiftMinuteNet)
                        WHERE EXISTS
                        (
                            SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                        );

                        UPDATE Employees.t_Shift
                        SET TimeIncompleteMinute = 0
                        WHERE EXISTS
                        (
                            SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                        )
                              AND TimeIncompleteMinute < 0;

                    END;

                END;

                BEGIN --ShiftMinuteNet

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet = ShiftMinute
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet -= IIF(CalculationEarly = 0, EarlyMinute, 0)
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet -= LateMinuteExtra
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET ShiftMinuteNet += IIF(CalculationOverTime = 0, 0 - OverTimeMinute, OverTimeMinuteExtra)
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET ShiftHourNet = ShiftMinuteNet / 60.0
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                END;

                BEGIN --TimeIncompleteMinute

                    UPDATE Employees.t_Shift
                    SET TimeIncompleteMinute = IIF(FromIs IS NULL OR ToIs IS NULL,
                                                   ShiftMinuteMust,
                                                   ShiftMinuteMust - ShiftMinuteNet)
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    );

                    UPDATE Employees.t_Shift
                    SET TimeIncompleteMinute = 0
                    WHERE EXISTS
                    (
                        SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                    )
                          AND TimeIncompleteMinute < 0;

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
                WHERE EXISTS
                (
                    SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_Shift.ID
                );

            END;

        END;

        BEGIN --Rebuilding Statistics t_Employee

            DECLARE @Employee AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            INSERT @Employee
            (
                ID
            )
            SELECT DISTINCT
                   t.EmployeeID
            FROM Employees.t_Shift AS t
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t.ID
            );

            UPDATE Employees.t_Employee
            SET InWorkNow = Employees.f_EmployeeGetInWorkNow(ID)
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @Employee AS s WHERE s.ID = t_Employee.ID
            );

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
