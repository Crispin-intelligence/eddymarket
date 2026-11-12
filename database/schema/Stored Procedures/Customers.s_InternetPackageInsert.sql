SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_InternetPackageInsert]
  @Name NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Cost FLOAT ,
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
        @Profit FLOAT ,
        @ExchangeRate DECIMAL(18, 2);
					
    END;

    BEGIN --Set info
		
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);

      SET @Profit = @Price - @Cost;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Customers.t_InternetPackage
              ( ID ,
                Name ,
                CurrencyID ,
                Currency ,
                Cost ,
                CostF ,
                CostD ,
                CostLL ,
                CostEuro ,
                Price ,
                PriceF ,
                PriceD ,
                PriceLL ,
                PriceEuro ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @CurrencyID ,
                Currencys.f_CurrencyGetName(@CurrencyID) ,
                @Cost ,
                Currencys.f_Format(@CurrencyID, @Cost) ,
                @Cost / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @Cost, @Cost / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @Cost, @Cost / @ExchangeRate) ,
                @Price ,
                Currencys.f_Format(@CurrencyID, @Price) ,
                @Price / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @Price, @Price / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @Price / @ExchangeRate) ,
                @Profit ,
                Currencys.f_Format(@CurrencyID, @Profit) ,
                @Profit / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @Profit, @Profit / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @Profit, @Profit / @ExchangeRate) ,
                @DescriptionIs
              );

      UPDATE  Customers.t_InternetPackage
      SET     SearchText = Customers.f_InternetPackageSearchTextGet(ID)
      WHERE   ID = @ID;
	  
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_InternetPackageMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
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
