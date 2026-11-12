SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_SubscriptionTypeUpdate] @Name NVARCHAR(MAX) ,
  @TypeIs TINYINT ,
  @NumberIs INT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Price FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450) ,
        @ExchangeRate DECIMAL(18, 2) ,
        @PriceF NVARCHAR(MAX) ,
        @PriceD FLOAT;
					
    END;

    BEGIN --Set info
	
      SET @NameOld = Gym.f_SubscriptionTypeGetName(@ID);
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
      SET @PriceD = @Price / @ExchangeRate;
      SET @PriceF = Currencys.f_Format(@CurrencyID, @Price);

    END;

    BEGIN --Insert

      SET @Return = 0;

      UPDATE Gym.t_SubscriptionType
        SET Name = @Name ,
            NameF = Gym.f_SubscriptionTypeNameFFix(@Name, @TypeIs, @PriceF) ,
            TypeIs = @TypeIs ,
            NumberIs = @NumberIs ,
            TimePeriodDays = Gym.f_SubscriptionTypeTimePeriodDaysFix(@TypeIs, @NumberIs) ,
            TimePeriodARF = Gym.f_SubscriptionTypeTimePeriodARFFix(@TypeIs, @NumberIs) ,
            TimePeriodENF = Gym.f_SubscriptionTypeTimePeriodENFFix(@TypeIs, @NumberIs) ,
            CurrencyID = @CurrencyID ,
            Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
            Price = @Price ,
            PriceF = @PriceF ,
            PriceD = @PriceD ,
            PriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @Price, @PriceD) ,
            PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @PriceD) ,
            DescriptionIs = @DescriptionIs
        WHERE ID = @ID;

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
            @ID ,
            @Event ,
            @EventType ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_GymSubscription

        UPDATE Gym.t_GymSubscription
          SET SubscriptionType = @Name
          WHERE SubscriptionTypeID = @ID;

        UPDATE Gym.t_GymSubscriptionHistory
          SET SubscriptionType = @Name
          WHERE SubscriptionTypeID = @ID;

        UPDATE Gym.t_GymSubscriptionDeleted
          SET SubscriptionType = @Name
          WHERE SubscriptionTypeID = @ID;

      END;

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
