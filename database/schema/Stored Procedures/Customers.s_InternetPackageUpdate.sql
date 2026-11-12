SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_InternetPackageUpdate]
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
        @ExchangeRate DECIMAL(18, 2) ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Customers.t_InternetPackage AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
				 
      SET @Profit = @Price - @Cost;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Customers.t_InternetPackage
      SET     Name = @Name ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              Cost = @Cost ,
              CostF = Currencys.f_Format(@CurrencyID, @Cost) ,
              CostD = @Cost / @ExchangeRate ,
              CostLL = Currencys.f_ExchangeToLL(@CurrencyID, @Cost, @Cost / @ExchangeRate) ,
              CostEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Cost, @Cost / @ExchangeRate) ,
              Price = @Price ,
              PriceF = Currencys.f_Format(@CurrencyID, @Price) ,
              PriceD = @Price / @ExchangeRate ,
              PriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @Price, @Price / @ExchangeRate) ,
              PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @Price / @ExchangeRate) ,
              Profit = @Profit ,
              ProfitF = Currencys.f_Format(@CurrencyID, @Profit) ,
              ProfitD = @Profit / @ExchangeRate ,
              ProfitLL = Currencys.f_ExchangeToLL(@CurrencyID, @Profit, @Profit / @ExchangeRate) ,
              ProfitEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Profit, @Profit / @ExchangeRate) ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_Customer

        UPDATE  Customers.t_Customer
        SET     InternetPackage = @Name
        WHERE   InternetPackageID = @ID;

      END;

      BEGIN --t_InternetSubscription

        UPDATE  Invoices.t_InternetSubscription
        SET     InternetPackage = @Name
        WHERE   InternetPackageID = @ID;

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
