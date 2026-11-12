SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldRebuildingStatistics]
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

    DISABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;
    DISABLE TRIGGER Invoices.tr_SoldDetail ON Invoices.t_SoldDetail;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Invoices.t_Sold
      SET     CommissionAvailableValue = IIF(SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValue, IIF(StatusPayment = 0, 0, CommissionValue))) ,
              CommissionAvailableValueD = IIF(SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValueD, IIF(StatusPayment = 0, 0, CommissionValueD))) ,
              CommissionAvailableValueLL = IIF(SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValueLL, IIF(StatusPayment = 0, 0, CommissionValueLL))) ,
              CommissionAvailableValueEuro = IIF(SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValueEuro, IIF(StatusPayment = 0, 0, CommissionValueEuro)));

      UPDATE  Invoices.t_Sold
      SET     RefF = FORMAT(Ref, 'n0') ,
              InvoiceTitle = Invoices.f_InvoiceTitleGetName(InvoiceTitleID) ,
              UserIs = Users.f_UserGetName(UserID) ,
              Salesperson = Employees.f_SalesPersonGetName(SalespersonID) ,
              CommissionRateF = FORMAT(CommissionRate, '0.##') + N' %' ,
              CommissionValueF = Currencys.f_Format(CurrencyID, CommissionValue) ,
              CommissionAvailableValueF = Currencys.f_Format(CurrencyID, CommissionAvailableValue) ,
              AccountCustomer = Company.f_AccountGetName(AccountCustomerID) ,
              AccountBox = Company.f_AccountGetName(AccountBoxID) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              TotalF = Currencys.f_Format(CurrencyID, Total) ,
              DiscountIsF = Currencys.f_Format(CurrencyID, DiscountIs) ,
              TaxValueF = Currencys.f_Format(CurrencyID, TaxValue) ,
              NetIsF = Currencys.f_Format(CurrencyID, NetIs) ,
              NetIsAR = Currencys.f_ToWordAR(NetIs, CurrencyID, 1) ,
              NetIsEN = Currencys.f_ToWordEN(NetIs, CurrencyID, 1) ,
              ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
              FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
              CostF = Currencys.f_Format(CurrencyID, Cost) ,
              ItemsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                  ', ' + t1.Name AS [text()]
                                           FROM   Invoices.t_SoldDetail AS t
                                           LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                           WHERE  t.SoldID = t_Sold.ID
                                         FOR
                                           XML PATH('')
                                         )) ,
              ItemHaveDiscount = CASE ( SELECT  COALESCE(SUM(s.DiscountIsValue), 0)
                                        FROM    Invoices.t_SoldDetail AS s
                                        WHERE   s.SoldID = t_Sold.ID
                                      )
                                   WHEN 0 THEN 0
                                   ELSE 1
                                 END;

      UPDATE  Invoices.t_Sold
      SET     TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
      WHERE   NetIs > 0;

      UPDATE  Invoices.t_Sold
      SET     SearchText = Invoices.f_SoldSearchTextGet(ID);
  
      WITH  o AS ( SELECT s.Price ,
                          s.PriceF ,
                          s.DiscountIs ,
                          s.DiscountIsF ,
                          s.DiscountIsValue ,
                          s.DiscountIsValueF ,
                          s.SubTotal ,
                          s.SubTotalF ,
                          s.DiscountInvoice ,
                          s.DiscountInvoiceF ,
                          s.TaxRate ,
                          s.TaxRateF ,
                          s.TaxValue ,
                          s.Total ,
                          s.TotalF ,
                          s.Cost ,
                          s.CostF ,
                          s.Profit ,
                          s.ProfitF ,
                          s.ProfitTotal ,
                          s.ProfitTotalF ,
                          s1.CurrencyID ,
                          s.Qty ,
                          s.Qtys ,
                          s.QtyWithUnity ,
                          s3.Name AS Unity
                   FROM   Invoices.t_SoldDetail AS s
                   LEFT JOIN Invoices.t_Sold AS s1 ON s1.ID = s.SoldID
                   LEFT JOIN Items.t_UnityItem AS s2 ON s2.ID = s.ItemUnityID
                   LEFT JOIN Items.t_Unity AS s3 ON s3.ID = s2.UnityID
                 )
        UPDATE  o
        SET     o.PriceF = Currencys.f_Format(o.CurrencyID, o.Price) ,
                o.DiscountIsF = FORMAT(o.DiscountIs, '0.##') + ' %' ,
                o.DiscountIsValueF = Currencys.f_Format(o.CurrencyID, o.DiscountIsValue) ,
                o.SubTotalF = Currencys.f_Format(o.CurrencyID, o.SubTotal) ,
                o.DiscountInvoiceF = Currencys.f_Format(o.CurrencyID, o.DiscountInvoice) ,
                o.TaxRateF = FORMAT(o.TaxRate, '0.##') + ' %' ,
                o.TotalF = Currencys.f_Format(o.CurrencyID, o.Total) ,
                o.CostF = Currencys.f_Format(o.CurrencyID, o.Cost) ,
                o.ProfitF = Currencys.f_Format(o.CurrencyID, o.Profit) ,
                o.ProfitTotalF = Currencys.f_Format(o.CurrencyID, o.ProfitTotal) ,
                o.QtyWithUnity = FORMAT(o.Qty, '#,##0.####') + ' ' + o.Unity;
 	
      UPDATE  Invoices.t_SoldDetail
      SET     SearchText = Invoices.f_SoldDetailSearchTextGet(ID);
 
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Invoices.t_SoldMoving
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

    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Sell, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    ENABLE TRIGGER Invoices.tr_Sold ON Invoices.t_Sold;
    ENABLE TRIGGER Invoices.tr_SoldDetail ON Invoices.t_SoldDetail;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;




GO
