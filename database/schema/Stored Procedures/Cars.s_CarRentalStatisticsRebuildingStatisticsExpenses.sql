SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarRentalStatisticsRebuildingStatisticsExpenses]
  @UserID UNIQUEIDENTIFIER ,
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

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Cars.t_CarRentalStatistics
      SET     
	  Expenses = (SELECT COUNT(*) FROM Cars.t_CarExpense),
	  ExpensesSubTotalD = (SELECT ISNULL(SUM(s.BalanceD),0) FROM Cars.t_CarExpense AS s),
	  ExpensesSubTotalLL = (SELECT ISNULL(SUM(s.BalanceLL),0) FROM Cars.t_CarExpense AS s),
	  ExpensesSubTotalEuro = (SELECT ISNULL(SUM(s.BalanceEuro),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTaxValueD = (SELECT ISNULL(SUM(s.TaxValueD),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTaxValueLL = (SELECT ISNULL(SUM(s.TaxValueLL),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTaxValueEuro = (SELECT ISNULL(SUM(s.TaxValueEuro),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTotalD = (SELECT ISNULL(SUM(s.NetIsD),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTotalLL = (SELECT ISNULL(SUM(s.NetIsLL),0) FROM Cars.t_CarExpense AS s),
	  ExpensesTotalEuro = (SELECT ISNULL(SUM(s.NetIsEuro),0) FROM Cars.t_CarExpense AS s);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarRentalStatisticsMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
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
