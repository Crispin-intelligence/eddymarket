SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Gym].[s_PersonalTrainerUpdate] @Name NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Price FLOAT ,
  @SessionIs INT ,
  @Total FLOAT ,
  @AccountEmployeeID UNIQUEIDENTIFIER ,
  @SalaryPercent DECIMAL(5, 2) ,
  @Salary FLOAT ,
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
        @PriceD FLOAT ,
        @TotalF NVARCHAR(MAX) ,
        @TotalD FLOAT ,
        @SalaryF NVARCHAR(MAX) ,
        @SalaryD FLOAT;
					
    END;

    BEGIN --Set info
	
      SET @NameOld = Gym.f_PersonalTrainerGetName(@ID);
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
    
      SET @PriceD = @Price / @ExchangeRate;
      SET @PriceF = Currencys.f_Format(@CurrencyID, @Price);
	 
      SET @TotalD = @Total / @ExchangeRate;
      SET @TotalF = Currencys.f_Format(@CurrencyID, @Total);
   
      SET @SalaryD = @Salary / @ExchangeRate;
      SET @SalaryF = Currencys.f_Format(@CurrencyID, @Salary);

    END;

    BEGIN --Insert

      SET @Return = 0;

      UPDATE Gym.t_PersonalTrainer
        SET Name = @Name ,
            NameF = Gym.f_PersonalTrainerNameFFix(@Name, @PriceF) ,
            CurrencyID = @CurrencyID ,
            Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
            Price = @Price ,
            PriceF = @PriceF ,
            PriceD = @PriceD ,
            PriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @Price, @PriceD) ,
            PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @PriceD) ,
            SessionIs = @SessionIs ,
            Total = @Total ,
            TotalF = @TotalF ,
            TotalD = @TotalD ,
            TotalLL = Currencys.f_ExchangeToLL(@CurrencyID, @Total, @TotalD) ,
            TotalEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Total, @TotalD) ,
            AccountEmployeeID = @AccountEmployeeID ,
            AccountEmployee = Company.f_AccountGetName(@AccountEmployeeID) ,
            AccountEmployeeNumber = Company.f_AccountGetNumberF(@AccountEmployeeID) ,
            SalaryPercent = @SalaryPercent ,
            Salary = @Salary ,
            SalaryF = @SalaryF ,
            SalaryD = @SalaryD ,
            SalaryLL = Currencys.f_ExchangeToLL(@CurrencyID, @Salary, @SalaryD) ,
            SalaryEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Salary, @SalaryD) ,
            DescriptionIs = @DescriptionIs
        WHERE ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Gym.t_PersonalTrainerMoving
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
          SET PersonalTrainer = @Name
          WHERE PersonalTrainerID = @ID;

        UPDATE Gym.t_GymSubscriptionHistory
          SET PersonalTrainer = @Name
          WHERE PersonalTrainerID = @ID;

        UPDATE Gym.t_GymSubscriptionDeleted
          SET PersonalTrainer = @Name
          WHERE PersonalTrainerID = @ID;

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
