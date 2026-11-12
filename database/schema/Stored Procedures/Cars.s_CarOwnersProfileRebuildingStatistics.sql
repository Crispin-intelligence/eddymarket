SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarOwnersProfileRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
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

      UPDATE  Cars.t_CarOwnersProfile
      SET     CarsCount = ( SELECT  COUNT(*)
                            FROM    Cars.t_CarOwners AS s
                            WHERE   ( s.OwnerProfileID = t_CarOwnersProfile.ID )
                          ) ,
              CarRentalCount = ( SELECT COUNT(*)
                                 FROM   Cars.t_CarRentalOwner AS s
                                 INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                 WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                        AND s1.StatusIs <> 3
                               ) + ( SELECT COUNT(*)
                                     FROM   Cars.t_CarRentalHistoryOwner AS s
                                     INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                     WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                            AND s1.StatusIs <> 3
                                   ) ,
              TotalProfitD = ( SELECT ISNULL(SUM(s.ProfitD), 0)
                               FROM   Cars.t_CarRentalOwner AS s
                               INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                               WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                      AND s1.StatusIs <> 3
                             ) + ( SELECT ISNULL(SUM(s.ProfitD), 0)
                                   FROM   Cars.t_CarRentalHistoryOwner AS s
                                   INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                   WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                          AND s1.StatusIs <> 3
                                 ) ,
              TotalProfitLL = ( SELECT  ISNULL(SUM(s.ProfitLL), 0)
                                FROM    Cars.t_CarRentalOwner AS s
                                INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                        AND s1.StatusIs <> 3
                              ) + ( SELECT  ISNULL(SUM(s.ProfitLL), 0)
                                    FROM    Cars.t_CarRentalHistoryOwner AS s
                                    INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                    WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                            AND s1.StatusIs <> 3
                                  ) ,
              TotalProfitEuro = ( SELECT  ISNULL(SUM(s.ProfitEuro), 0)
                                  FROM    Cars.t_CarRentalOwner AS s
                                  INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                  WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                          AND s1.StatusIs <> 3
                                ) + ( SELECT  ISNULL(SUM(s.ProfitEuro), 0)
                                      FROM    Cars.t_CarRentalHistoryOwner AS s
                                      INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                      WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s1.StatusIs <> 3
                                    ) ,
              CarRentalUnpaidCount = ( SELECT COUNT(*)
                                       FROM   Cars.t_CarRentalOwner AS s
                                       INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s.Paid = 0
                                              AND s1.StatusIs <> 3
                                     ) + ( SELECT COUNT(*)
                                           FROM   Cars.t_CarRentalHistoryOwner AS s
                                           INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                           WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                                  AND s.Paid = 0
                                                  AND s1.StatusIs <> 3
                                         ) ,
              UnpaidTotalProfitD = ( SELECT ISNULL(SUM(s.ProfitD), 0)
                                     FROM   Cars.t_CarRentalOwner AS s
                                     INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                     WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                            AND s.Paid = 0
                                            AND s1.StatusIs <> 3
                                   ) + ( SELECT ISNULL(SUM(s.ProfitD), 0)
                                         FROM   Cars.t_CarRentalHistoryOwner AS s
                                         INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                         WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                                AND s.Paid = 0
                                                AND s1.StatusIs <> 3
                                       ) ,
              UnpaidTotalProfitLL = ( SELECT  ISNULL(SUM(s.ProfitLL), 0)
                                      FROM    Cars.t_CarRentalOwner AS s
                                      INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                      WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s.Paid = 0
                                              AND s1.StatusIs <> 3
                                    ) + ( SELECT  ISNULL(SUM(s.ProfitLL), 0)
                                          FROM    Cars.t_CarRentalHistoryOwner AS s
                                          INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                          WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                                  AND s.Paid = 0
                                                  AND s1.StatusIs <> 3
                                        ) ,
              UnpaidTotalProfitEuro = ( SELECT  ISNULL(SUM(s.ProfitEuro), 0)
                                        FROM    Cars.t_CarRentalOwner AS s
                                        INNER JOIN Cars.t_CarRental AS s1 ON s1.ID = s.CarRentalID
                                        WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                                AND s.Paid = 0
                                                AND s1.StatusIs <> 3
                                      ) + ( SELECT  ISNULL(SUM(s.ProfitEuro), 0)
                                            FROM    Cars.t_CarRentalHistoryOwner AS s
                                            INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                                            WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                                    AND s.Paid = 0
                                                    AND s1.StatusIs <> 3
                                          );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarOwnersProfileMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

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
