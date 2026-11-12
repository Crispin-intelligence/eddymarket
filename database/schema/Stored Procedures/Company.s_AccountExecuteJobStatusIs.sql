SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountExecuteJobStatusIs]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check i need execute

      IF NOT EXISTS ( SELECT TOP ( 1 )
                              s.ID
                      FROM    Alls.t_LastExecuteJob AS s
                      WHERE   s.Company_Account_StatusIs < CONVERT(DATE, GETDATE()) )
      BEGIN

        COMMIT TRANSACTION;

        RETURN 1;

      END;

    END;

    DISABLE TRIGGER Company.tr_Account ON Company.t_Account;

    BEGIN; --Update 

      WITH  o AS ( SELECT s1.ID ,
                          s1.StatusIs
                   FROM   Company.t_Account AS s
                   INNER JOIN Customers.t_Customer AS s1 ON s1.ID = s.LinkWithID
                                                            AND s.IsMasterLink = 1
                                                            AND s.SectionID = 15
                   WHERE  s.StatusIs = 0
                          AND s.MakeInactiveAfter <> 0
                          AND CASE s.MakeInactiveAfterType
                                WHEN 2 THEN DATEADD(DAY, s.MakeInactiveAfter, s.LastAction)
                                WHEN 1 THEN DATEADD(MONTH, s.MakeInactiveAfter, s.LastAction)
                                ELSE DATEADD(YEAR, s.MakeInactiveAfter, s.LastAction)
                              END < GETDATE()
                 )
        UPDATE  o
        SET     o.StatusIs = 1;

      UPDATE  Company.t_Account
      SET     StatusIs = 1 ,
              IsSync = 0
      WHERE   StatusIs = 0
              AND MakeInactiveAfter <> 0
              AND CASE MakeInactiveAfterType
                    WHEN 2 THEN DATEADD(DAY, MakeInactiveAfter, LastAction)
                    WHEN 1 THEN DATEADD(MONTH, MakeInactiveAfter, LastAction)
                    ELSE DATEADD(YEAR, MakeInactiveAfter, LastAction)
                  END < GETDATE();

      UPDATE  Company.t_Account
      SET     GymSubscriptionC = [Gym].f_GymSubscriptionGetCountByAccountID(ID) ,
              GymSubscriptionLast = [Gym].f_GymSubscriptionGetLastByAccountID(ID) ,
              GymSubscriptionActiveTo = [Gym].f_GymSubscriptionGetActiveToByAccountID(ID)
      WHERE   SectionID = 15
              AND IsMasterLink = 1;
	
      UPDATE  Company.t_Account
      SET     GymSubscriptionIsActive = IIF(GymSubscriptionActiveTo >= CONVERT(DATE, GETDATE()), 1, 0)
      WHERE   SectionID = 15
              AND IsMasterLink = 1;
			  
    END;

    BEGIN --Execute is done

      UPDATE  Alls.t_LastExecuteJob
      SET     Company_Account_StatusIs = GETDATE();

    END;

    ENABLE TRIGGER Company.tr_Account ON Company.t_Account;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;







GO
