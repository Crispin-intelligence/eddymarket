SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_InternetPackageRebuildingStatistics]
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

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE  Customers.t_InternetPackage
      SET     Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              CostF = Currencys.f_Format(CurrencyID, CostF) ,
              PriceF = Currencys.f_Format(CurrencyID, Price) ,
              ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
              TotalCustomers = ( SELECT COUNT(*)
                                 FROM   Customers.t_Customer AS s
                                 WHERE  s.InternetPackageID = t_InternetPackage.ID
                               ) ,
              TotalSubscriptions = ( SELECT COUNT(*)
                                     FROM   Invoices.t_InternetSubscription AS s
                                     WHERE  s.InternetPackageID = t_InternetPackage.ID
                                   );

      UPDATE  Customers.t_InternetPackage
      SET     SearchText = Customers.f_InternetPackageSearchTextGet(ID);
	  
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
