SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationDelete]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @AccountID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @AccountID = s.AccountID
      FROM    Quotations.t_Quotation AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Quotations.t_QuotationNoteLink
      WHERE   QuotationID = @ID;

      DELETE  FROM Quotations.t_QuotationDetail
      WHERE   QuotationID = @ID;

      DELETE  FROM Quotations.t_Quotation
      WHERE   ID = @ID;

    END;

    BEGIN --Fix t_Account

      UPDATE  Company.t_Account
      SET     QuotationC -= 1 ,
              QuotationTotal = Quotations.[f_QuotationGetTotalByAccountID](ID) ,
              QuotationProfit = Quotations.[f_QuotationGetProfitByAccountID](ID) ,
              QuotationLast = Quotations.f_QuotationGetLastDateByAccountID(ID)
      WHERE   ID = @AccountID;

      UPDATE  Company.t_Account
      SET     QuotationTotalF = Currencys.f_Format(CurrencyID, QuotationTotal) ,
              QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit)
      WHERE   ID = @AccountID;
		  
    END;
   
    BEGIN --Update t_Sold

      UPDATE  Invoices.t_Sold
      SET     SaveFrom = 0 ,
              QuotationID = '00000000-0000-0000-0000-000000000000' ,
              QuotationRef = ''
      WHERE   QuotationID = @ID;

      UPDATE  Invoices.t_SoldDeleted
      SET     SaveFrom = 0 ,
              QuotationID = '00000000-0000-0000-0000-000000000000' ,
              QuotationRef = ''
      WHERE   QuotationID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Quotations.t_QuotationMoving
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
                2 ,
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
