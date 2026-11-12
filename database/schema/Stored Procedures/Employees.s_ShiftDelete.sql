SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftDelete]
    @StatusIs TINYINT,
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

        BEGIN --Insert History

            INSERT INTO Employees.t_ShiftHistory
            (
                ID,
                Ref,
                RefF,
                EmployeeID,
                Employee,
                DateIs,
                FromIsMust,
                FromIs,
                ShiftMinuteMust,
                ShiftHourMust,
                ShiftMustF,
                EarlyMinute,
                EarlyF,
                CalculationEarly,
                LateMinute,
                LateF,
                LateX,
                LateMinuteNet,
                LateNetF,
                LateMinuteExtra,
                LateExtraF,
                ToIsMust,
                ToIs,
                ShiftMinute,
                ShiftHour,
                ShiftF,
                OverTimeMinute,
                OverTimeF,
                CalculationOverTime,
                OverTimeX,
                OverTimeMinuteNet,
                OverTimeNetF,
                OverTimeMinuteExtra,
                OverTimeExtraF,
                ShiftMinuteNet,
                ShiftHourNet,
                ShiftNetF,
                TimeIncompleteMinute,
                TimeIncompleteF,
                DescriptionIs,
                StatusIs,
                DateCreate,
                WorkStationID
            )
            SELECT t.ID,
                   t.Ref,
                   t.RefF,
                   t.EmployeeID,
                   t.Employee,
                   t.DateIs,
                   t.FromIsMust,
                   t.FromIs,
                   t.ShiftMinuteMust,
                   t.ShiftHourMust,
                   t.ShiftMustF,
                   t.EarlyMinute,
                   t.EarlyF,
                   t.CalculationEarly,
                   t.LateMinute,
                   t.LateF,
                   t.LateX,
                   t.LateMinuteNet,
                   t.LateNetF,
                   t.LateMinuteExtra,
                   t.LateExtraF,
                   t.ToIsMust,
                   t.ToIs,
                   t.ShiftMinute,
                   t.ShiftHour,
                   t.ShiftF,
                   t.OverTimeMinute,
                   t.OverTimeF,
                   t.CalculationOverTime,
                   t.OverTimeX,
                   t.OverTimeMinuteNet,
                   t.OverTimeNetF,
                   t.OverTimeMinuteExtra,
                   t.OverTimeExtraF,
                   t.ShiftMinuteNet,
                   t.ShiftHourNet,
                   t.ShiftNetF,
                   t.TimeIncompleteMinute,
                   t.TimeIncompleteF,
                   t.DescriptionIs,
                   @StatusIs,
                   t.DateCreate,
                   t.WorkStationID
            FROM Employees.t_Shift AS t
            WHERE t.ID = @ID;

        END;

        BEGIN --Delete

            DELETE FROM Employees.t_Shift
            WHERE ID = @ID;

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
            (@UserID, @ID, @Event, 2, @ComputerIP, @Computer, @ComputerAccount);

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
