SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarExpenseDelete]
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

      DECLARE @CarID UNIQUEIDENTIFIER ,
        @BalanceD FLOAT ,
        @BalanceLL FLOAT ,
        @BalanceEuro FLOAT ,
        @TaxValueD FLOAT ,
        @TaxValueLL FLOAT ,
        @TaxValueEuro FLOAT ,
        @NetIsD FLOAT ,
        @NetIsLL FLOAT ,
        @NetIsEuro FLOAT ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @CarID = s.CarID ,
              @BalanceD = s.BalanceD ,
              @BalanceLL = s.BalanceLL ,
              @BalanceEuro = s.BalanceEuro ,
              @TaxValueD = s.TaxValueD ,
              @TaxValueLL = s.TaxValueLL ,
              @TaxValueEuro = s.TaxValueEuro ,
              @NetIsD = s.NetIsD ,
              @NetIsLL = s.NetIsLL ,
              @NetIsEuro = s.NetIsEuro
      FROM    Cars.t_CarExpense AS s
      WHERE   s.ID = @ID;

    END;
	
    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Cars.t_CarExpense
      WHERE   ID = @ID;

    END;

    BEGIN --Delete

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = 182
              AND LinkID = @ID;

    END;

    BEGIN --Fix t_Car

      UPDATE  Cars.t_Car
      SET     ExpensesCount -= 1 ,
              TotalExpensesD -= @NetIsD ,
              TotalExpensesLL -= @NetIsLL ,
              TotalExpensesEuro -= @NetIsEuro
      WHERE   ID = @CarID;

      UPDATE  Cars.t_Car
      SET     ProfitD = ProfitCarRentsD - TotalExpensesD ,
              ProfitLL = ProfitCarRentsLL - TotalExpensesLL ,
              ProfitEuro = ProfitCarRentsEuro - TotalExpensesEuro
      WHERE   ID = @CarID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarExpenseMoving
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

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Expenses -= 1 ,
              ExpensesSubTotalD -= @BalanceD ,
              ExpensesSubTotalLL -= @BalanceLL ,
              ExpensesSubTotalEuro -= @BalanceEuro ,
              ExpensesTaxValueD -= @TaxValueD ,
              ExpensesTaxValueLL -= @TaxValueLL ,
              ExpensesTaxValueEuro -= @TaxValueEuro ,
              ExpensesTotalD -= @NetIsD ,
              ExpensesTotalLL -= @NetIsLL ,
              ExpensesTotalEuro -= @NetIsEuro;
  
      UPDATE  Cars.t_CarRentalStatistics
      SET     ProfitD = RentalsProfitD - ExpensesTotalD ,
              ProfitLL = RentalsProfitLL - ExpensesTotalLL ,
              ProfitEuro = RentalsProfitEuro - ExpensesTotalEuro;

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
