SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_VacationTypeRebuildingStatistics]
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

        BEGIN --Rebuild statistics

            SET @Return = 0;

            UPDATE Employees.t_VacationType
            SET VacationAddC = COALESCE(
                               (
                                   SELECT SUM(t.DaysIs)
                                   FROM Employees.t_Vacation AS t
                                   WHERE t.TypeID = t_VacationType.ID
                                         AND t.OperationType = 0
                               ),
                               0
                                       ),
                VacationUseC = COALESCE(
                               (
                                   SELECT SUM(t.DaysIs)
                                   FROM Employees.t_Vacation AS t
                                   WHERE t.TypeID = t_VacationType.ID
                                         AND t.OperationType = 1
                               ),
                               0
                                       ),
                VacationDiscountedC = COALESCE(
                                      (
                                          SELECT SUM(t.DaysIs)
                                          FROM Employees.t_Vacation AS t
                                          WHERE t.TypeID = t_VacationType.ID
                                                AND t.OperationType = 2
                                      ),
                                      0
                                              ),
                VacationC =
                (
                    SELECT COUNT(*)
                    FROM Employees.t_Vacation AS t
                    WHERE t.TypeID = t_VacationType.ID
                );

            UPDATE Employees.t_VacationType
            SET VacationNet = VacationAddC - VacationUseC;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_VacationTypeMoving
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
