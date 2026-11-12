SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_SubscriptionTypeRebuildingStatistics] @UserID UNIQUEIDENTIFIER ,
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

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE Gym.t_SubscriptionType
        SET TimePeriodDays = [Gym].[f_SubscriptionTypeTimePeriodDaysFix](TypeIs, NumberIs) ,
            TimePeriodARF = [Gym].[f_SubscriptionTypeTimePeriodARFFix](TypeIs, NumberIs) ,
            TimePeriodENF = [Gym].[f_SubscriptionTypeTimePeriodENFFix](TypeIs, NumberIs) ,
            Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
            PriceF = Currencys.f_Format(CurrencyID, Price) ,
            NumberOfSubscriptions = ( SELECT COUNT(*)
                                        FROM Gym.t_GymSubscription AS s
                                        WHERE s.SubscriptionTypeID = t_SubscriptionType.ID
                                    ) + ( SELECT COUNT(*)
                                            FROM Gym.t_GymSubscriptionHistory AS s
                                            WHERE s.SubscriptionTypeID = t_SubscriptionType.ID
                                        );

      UPDATE Gym.t_SubscriptionType
        SET NameF = [Gym].[f_SubscriptionTypeNameFFix](Name, TypeIs, PriceF);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_SubscriptionTypeMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
            '00000000-0000-0000-0000-000000000000' ,
            @Event ,
            6 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;






GO
