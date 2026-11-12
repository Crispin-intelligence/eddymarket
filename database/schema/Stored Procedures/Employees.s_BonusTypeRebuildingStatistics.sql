SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_BonusTypeRebuildingStatistics]
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

            UPDATE Employees.t_BonusType
            SET BonusTotalD = COALESCE(
                              (
                                  SELECT SUM(t.ValueIsD)
                                  FROM Employees.t_Bonus AS t
                                  WHERE t.TypeID = t_BonusType.ID
                              ),
                              0
                                      ) + COALESCE(
                                          (
                                              SELECT SUM(t.ValueIsD)
                                              FROM Employees.t_BonusHistory AS t
                                              WHERE t.TypeID = t_BonusType.ID
                                          ),
                                          0
                                                  ),
                BonusTotalLL = COALESCE(
                               (
                                   SELECT SUM(t.ValueIsLL)
                                   FROM Employees.t_Bonus AS t
                                   WHERE t.TypeID = t_BonusType.ID
                               ),
                               0
                                       ) + COALESCE(
                                           (
                                               SELECT SUM(t.ValueIsLL)
                                               FROM Employees.t_BonusHistory AS t
                                               WHERE t.TypeID = t_BonusType.ID
                                           ),
                                           0
                                                   ),
                BonusTotalEuro = COALESCE(
                                 (
                                     SELECT SUM(t.ValueIsEuro)
                                     FROM Employees.t_Bonus AS t
                                     WHERE t.TypeID = t_BonusType.ID
                                 ),
                                 0
                                         ) + COALESCE(
                                             (
                                                 SELECT SUM(t.ValueIsEuro)
                                                 FROM Employees.t_BonusHistory AS t
                                                 WHERE t.TypeID = t_BonusType.ID
                                             ),
                                             0
                                                     ),
                BonusC = COALESCE(
                         (
                             SELECT COUNT_BIG(*)
                             FROM Employees.t_Bonus AS t
                             WHERE t.TypeID = t_BonusType.ID
                         ),
                         0
                                 ) + COALESCE(
                                     (
                                         SELECT COUNT_BIG(*)
                                         FROM Employees.t_BonusHistory AS t
                                         WHERE t.TypeID = t_BonusType.ID
                                     ),
                                     0
                                             );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_BonusTypeMoving
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
