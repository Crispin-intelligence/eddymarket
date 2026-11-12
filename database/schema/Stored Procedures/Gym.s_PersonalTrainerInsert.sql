SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_PersonalTrainerInsert] @Name NVARCHAR(MAX) ,
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
        @PriceD FLOAT ,
        @TotalF NVARCHAR(MAX) ,
        @TotalD FLOAT ,
        @SalaryF NVARCHAR(MAX) ,
        @SalaryD FLOAT;
					
    END;

    BEGIN --Set info
		
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

      INSERT INTO Gym.t_PersonalTrainer
          ( Name ,
            NameF ,
            CurrencyID ,
            Currency ,
            Price ,
            PriceF ,
            PriceD ,
            PriceLL ,
            PriceEuro ,
            SessionIs ,
            Total ,
            TotalF ,
            TotalD ,
            TotalLL ,
            TotalEuro ,
            AccountEmployeeID ,
            AccountEmployee ,
            AccountEmployeeNumber ,
            SalaryPercent ,
            Salary ,
            SalaryF ,
            SalaryD ,
            SalaryLL ,
            SalaryEuro ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Name ,
            Gym.f_PersonalTrainerNameFFix(@Name, @PriceF) ,
            @CurrencyID ,
            Currencys.f_CurrencyGetName(@CurrencyID) ,
            @Price ,
            @PriceF ,
            @PriceD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @Price, @PriceD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @PriceD) ,
            @SessionIs ,
            @Total ,
            @TotalF ,
            @TotalD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @Total, @TotalD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @Total, @TotalD) ,
            @AccountEmployeeID ,
            Company.f_AccountGetName(@AccountEmployeeID) ,
            Company.f_AccountGetNumberF(@AccountEmployeeID) ,
            @SalaryPercent ,
            @Salary ,
            @SalaryF ,
            @SalaryD ,
            Currencys.f_ExchangeToLL(@CurrencyID, @Salary, @SalaryD) ,
            Currencys.f_ExchangeToEuro(@CurrencyID, @Salary, @SalaryD) ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) ID
                    FROM @IDs
                    ORDER BY ID
                );

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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;





GO
