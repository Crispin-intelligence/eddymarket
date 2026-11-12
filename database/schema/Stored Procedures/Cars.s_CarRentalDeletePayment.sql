SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarRentalDeletePayment]
  @UserID UNIQUEIDENTIFIER ,
  @EventBase NVARCHAR(MAX) ,
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
	   
      DECLARE @TrnIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @PaidUp FLOAT ,
        @PaidUpD FLOAT ,
        @PaidUpLL FLOAT ,
        @PaidUpEuro FLOAT ,
        @TrnLinkType TINYINT = 185 ,
        @TrnLinkTypeSub TINYINT = 9 ,
        @return INT = 0;

    END;

    BEGIN --Set info
	    
      SELECT  @PaidUp = ISNULL(SUM(s.Balance), 0) ,
              @PaidUpD = ISNULL(SUM(s.BalanceD), 0) ,
              @PaidUpLL = ISNULL(SUM(s.BalanceLL), 0) ,
              @PaidUpEuro = ISNULL(SUM(s.BalanceEuro), 0)
      FROM    Transactions.t_TransactionDetail AS s
      INNER JOIN Transactions.t_Transaction AS s1 ON s1.ID = s.TransactionID
      WHERE   s.Balance > 0
              AND s1.LinkType = @TrnLinkType
              AND s1.LinkTypeSub = @TrnLinkTypeSub
              AND s1.LinkID = @ID;

    END;

    BEGIN --Update

      UPDATE  Cars.t_CarRental
      SET     PaidUp -= @PaidUp ,
              PaidUpD -= @PaidUpD ,
              PaidUpLL -= @PaidUpLL ,
              PaidUpEuro -= @PaidUpEuro
      WHERE   ID = @ID;
	    
      UPDATE  Cars.t_CarRental
      SET     PaidUpF = Currencys.f_Format(CurrencyID, PaidUp) ,
              Rest = Total - PaidUp ,
              RestF = Currencys.f_Format(CurrencyID, TotalD - PaidUpD) ,
              RestD = TotalD - PaidUpD ,
              RestLL = TotalLL - PaidUpLL ,
              RestEuro = TotalEuro - PaidUpEuro
      WHERE   ID = @ID;  

      UPDATE  Cars.t_CarRental
      SET     Paid = IIF(Rest = Total
              AND Total > 0, 0, IIF(Rest > 0, 1, 2))
      WHERE   ID = @ID;  
	    
    END;
	
    BEGIN --Insert t_CarRentalMoving

      SET @return = -1;

      INSERT  INTO Cars.t_CarRentalMoving
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
 
    BEGIN --Delete t_Transaction

      INSERT  INTO @TrnIDs
              ( ID ,
                RefF
              )
      SELECT  s.ID ,
              s.RefF
      FROM    Transactions.t_Transaction AS s
      WHERE   s.LinkType = @TrnLinkType
              AND s.LinkTypeSub = @TrnLinkTypeSub
              AND s.LinkID = @ID;

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = @TrnLinkType
              AND LinkTypeSub = @TrnLinkTypeSub
              AND LinkID = @ID;

    END;

    BEGIN --Insert t_TransactionMoving

      SET @return = -1;

      INSERT  INTO Transactions.t_TransactionMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s.ID ,
              @EventBase + N': ' + s.RefF ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @TrnIDs AS s;

    END;
	
    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @return;

  END CATCH;

END;


GO
