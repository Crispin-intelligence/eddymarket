SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_SubscriptionTypeInsertDefaultData]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Check

      IF EXISTS ( SELECT TOP ( 1 ) ID
                    FROM Gym.t_SubscriptionType )
      BEGIN
			
        COMMIT TRAN;

        RETURN 1;

      END;

    END;

    BEGIN --Insert
		
      INSERT INTO Gym.t_SubscriptionType
          DEFAULT VALUES;

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
