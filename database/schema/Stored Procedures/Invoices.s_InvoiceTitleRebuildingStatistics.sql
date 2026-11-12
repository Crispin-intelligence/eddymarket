SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_InvoiceTitleRebuildingStatistics]
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

      UPDATE  Invoices.t_InvoiceTitle
      SET     PurchaseC = ( SELECT  COUNT(*) AS Total
                            FROM    Invoices.t_Purchasing AS t
                            WHERE   ( t.InvoiceTitleID = t_InvoiceTitle.ID )
                          ) ,
              PurchaseReturnC = ( SELECT  COUNT(*) AS Total
                                  FROM    Invoices.t_PurchasingReturn AS t
                                  WHERE   ( t.InvoiceTitleID = t_InvoiceTitle.ID )
                                ) ,
              SellC = ( SELECT  COUNT(*) AS Total
                        FROM    Invoices.t_Sold AS t
                        WHERE   ( t.InvoiceTitleID = t_InvoiceTitle.ID )
                      ) ,
              SellReturnC = ( SELECT  COUNT(*) AS Total
                              FROM    Invoices.t_SoldReturn AS t
                              WHERE   ( t.InvoiceTitleID = t_InvoiceTitle.ID )
                            );

      UPDATE  Invoices.t_InvoiceTitle
      SET     SearchText = Invoices.f_InvoiceTitleSearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Invoices.t_InvoiceTitleMoving
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
