SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_SubscriptionTypeInsert] @Name NVARCHAR(MAX) ,
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
  @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @Return INT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @PriceF NVARCHAR(MAX) ,
        @PriceD FLOAT;
					
    END;

    BEGIN --Set info
		
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
      SET @PriceD = @Price / @ExchangeRate;
      SET @PriceF = Currencys.f_Format(@CurrencyID, @Price);

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT INTO Gym.t_SubscriptionType
          ( Name ,
            NameF ,
            TypeIs ,
            NumberIs ,
            TimePeriodDays ,
            TimePeriodARF ,
            TimePeriodENF ,
            CurrencyID ,
            Currency ,
            Price ,
            PriceF ,
            PriceD ,
            PriceLL ,
            PriceEuro ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Name ,
            Gym.f_SubscriptionTypeNameFFix(@Name, @TypeIs, @PriceF) ,
            @TypeIs ,
            @NumberIs ,
            Gym.f_SubscriptionTypeTimePeriodDaysFix(@TypeIs, @NumberIs) ,
            Gym.f_SubscriptionTypeTimePeriodARFFix(@TypeIs, @NumberIs) ,
            Gym.f_SubscriptionTypeTimePeriodENFFix(@TypeIs, @NumberIs) ,
            @CurrencyID ,
            Currencys.f_CurrencyGetName(@CurrencyID) ,
            @Price ,
            @PriceF ,
            @PriceD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @Price, @PriceD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @PriceD) ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) ID
                    FROM @IDs
                    ORDER BY ID
                );

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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;




GO
