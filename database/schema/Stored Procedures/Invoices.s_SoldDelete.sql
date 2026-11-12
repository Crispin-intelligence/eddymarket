SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldDelete]
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

      DECLARE @ItemQty AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          SharedID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 4) NOT NULL
        );

      DECLARE @ItemQtyNet AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 4) NOT NULL
        );
    
      DECLARE @SoldProfitPartnerDelete AS TABLE
        (
          ProfitPartnerID UNIQUEIDENTIFIER NOT NULL ,
          ProfitD FLOAT NOT NULL ,
          ProfitLL FLOAT NOT NULL ,
          ProfitEuro FLOAT NOT NULL
        );

      DECLARE @CustomerID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @CustomerID = s.AccountCustomerID
      FROM    Invoices.t_Sold AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Insert t_SoldDeleted

      SET @Return = 0;

      INSERT  INTO Invoices.t_SoldDeleted
              ( ID ,
                Ref ,
                RefF ,
                RefPaper ,
                SaveFrom ,
                QuotationID ,
                QuotationRef ,
                InvoiceTitleID ,
                InvoiceTitle ,
                DateIs ,
                DateOnly ,
                TimeOnly ,
                DateMonthly ,
                DateYearly ,
                UserID ,
                UserIs ,
                SalespersonID ,
                Salesperson ,
                CommissionRate ,
                CommissionRateF ,
                CommissionRateType ,
                CommissionRateOn ,
                StatusPayment ,
                CommissionValue ,
                CommissionValueF ,
                CommissionValueD ,
                CommissionValueLL ,
                CommissionValueEuro ,
                SalespersonTakeCommission ,
                CommissionAvailableValue ,
                CommissionAvailableValueF ,
                CommissionAvailableValueD ,
                CommissionAvailableValueLL ,
                CommissionAvailableValueEuro ,
                AccountCustomerID ,
                AccountCustomer ,
                AccountCustomerNumber ,
                AccountBoxID ,
                AccountBox ,
                AccountBoxNumber ,
                PaymentMethod ,
                CurrencyID ,
                Currency ,
                ExchangeRate ,
                ExchangeRateLL ,
                ExchangeRateEuro ,
                TaxExchangeRateLL ,
                TaxExchangeRateEuro ,
                Total ,
                TotalF ,
                TotalD ,
                TotalLL ,
                TotalEuro ,
                DiscountIs ,
                DiscountIsF ,
                DiscountIsD ,
                DiscountIsLL ,
                DiscountIsEuro ,
                TaxRate ,
                TaxRateF ,
                TaxValue ,
                TaxValueF ,
                TaxValueD ,
                TaxValueLL ,
                TaxValueEuro ,
                NetIs ,
                NetIsF ,
                NetIsD ,
                NetIsLL ,
                NetIsEuro ,
                NetIsAR ,
                NetIsEN ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                FirstPayment ,
                FirstPaymentF ,
                FirstPaymentD ,
                FirstPaymentLL ,
                FirstPaymentEuro ,
                Cost ,
                CostF ,
                CostD ,
                CostLL ,
                CostEuro ,
                Qtys ,
                DescriptionIs ,
                WFPFrom ,
                WFPShopID ,
                WFPBranchID ,
                WFPReported ,
                FrameJobOrderID ,
                FrameJobOrderRefF ,
                ItemsNames ,
                ItemHaveDiscount ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  t.ID ,
              t.Ref ,
              t.RefF ,
              t.RefPaper ,
              t.SaveFrom ,
              t.QuotationID ,
              t.QuotationRef ,
              t.InvoiceTitleID ,
              t.InvoiceTitle ,
              t.DateIs ,
              t.DateOnly ,
              t.TimeOnly ,
              t.DateMonthly ,
              t.DateYearly ,
              t.UserID ,
              t.UserIs ,
              t.SalespersonID ,
              t.Salesperson ,
              t.CommissionRate ,
              t.CommissionRateF ,
              t.CommissionRateType ,
              t.CommissionRateOn ,
              t.StatusPayment ,
              t.CommissionValue ,
              t.CommissionValueF ,
              t.CommissionValueD ,
              t.CommissionValueLL ,
              t.CommissionValueEuro ,
              t.SalespersonTakeCommission ,
              t.CommissionAvailableValue ,
              t.CommissionAvailableValueF ,
              t.CommissionAvailableValueD ,
              t.CommissionAvailableValueLL ,
              t.CommissionAvailableValueEuro ,
              t.AccountCustomerID ,
              t.AccountCustomer ,
              t.AccountCustomerNumber ,
              t.AccountBoxID ,
              t.AccountBox ,
              t.AccountBoxNumber ,
              t.PaymentMethod ,
              t.CurrencyID ,
              t.Currency ,
              t.ExchangeRate ,
              t.ExchangeRateLL ,
              t.ExchangeRateEuro ,
              t.TaxExchangeRateLL ,
              t.TaxExchangeRateEuro ,
              t.Total ,
              t.TotalF ,
              t.TotalD ,
              t.TotalLL ,
              t.TotalEuro ,
              t.DiscountIs ,
              t.DiscountIsF ,
              t.DiscountIsD ,
              t.DiscountIsLL ,
              t.DiscountIsEuro ,
              t.TaxRate ,
              t.TaxRateF ,
              t.TaxValue ,
              t.TaxValueF ,
              t.TaxValueD ,
              t.TaxValueLL ,
              t.TaxValueEuro ,
              t.NetIs ,
              t.NetIsF ,
              t.NetIsD ,
              t.NetIsLL ,
              t.NetIsEuro ,
              t.NetIsAR ,
              t.NetIsEN ,
              t.Profit ,
              t.ProfitF ,
              t.ProfitD ,
              t.ProfitLL ,
              t.ProfitEuro ,
              t.FirstPayment ,
              t.FirstPaymentF ,
              t.FirstPaymentD ,
              t.FirstPaymentLL ,
              t.FirstPaymentEuro ,
              t.Cost ,
              t.CostF ,
              t.CostD ,
              t.CostLL ,
              t.CostEuro ,
              t.Qtys ,
              t.DescriptionIs ,
              t.WFPFrom ,
              t.WFPShopID ,
              t.WFPBranchID ,
              t.WFPReported ,
              t.FrameJobOrderID ,
              t.FrameJobOrderRefF ,
              t.ItemsNames ,
              t.ItemHaveDiscount ,
              t.DateCreate ,
              t.IsSync ,
              t.WorkStationID
      FROM    Invoices.t_Sold AS t
      WHERE   t.ID = @ID;

      INSERT  Invoices.t_SoldDeletedDetail
              ( ID ,
                SoldDeletedID ,
                ItemSharedID ,
                ItemID ,
                ItemUnityID ,
                Qty ,
                QtyWithUnity ,
                Qtys ,
                Price ,
                PriceF ,
                PriceD ,
                PriceLL ,
                PriceEuro ,
                DiscountIs ,
                DiscountIsF ,
                DiscountIsValue ,
                DiscountIsValueF ,
                DiscountIsValueD ,
                DiscountIsValueLL ,
                DiscountIsValueEuro ,
                SubTotal ,
                SubTotalF ,
                SubTotalD ,
                SubTotalLL ,
                SubTotalEuro ,
                DiscountInvoice ,
                DiscountInvoiceF ,
                DiscountInvoiceD ,
                DiscountInvoiceLL ,
                DiscountInvoiceEuro ,
                TaxRate ,
                TaxRateF ,
                TaxValue ,
                TaxValueF ,
                TaxValueD ,
                TaxValueLL ,
                TaxValueEuro ,
                Total ,
                TotalF ,
                TotalD ,
                TotalLL ,
                TotalEuro ,
                Cost ,
                CostF ,
                CostD ,
                CostLL ,
                CostEuro ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                ProfitTotal ,
                ProfitTotalF ,
                ProfitTotalD ,
                ProfitTotalLL ,
                ProfitTotalEuro ,
                DescriptionIs ,
                SortAt ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  t.ID ,
              t.SoldID ,
              t.ItemSharedID ,
              t.ItemID ,
              t.ItemUnityID ,
              t.Qty ,
              t.QtyWithUnity ,
              t.Qtys ,
              t.Price ,
              t.PriceF ,
              t.PriceD ,
              t.PriceLL ,
              t.PriceEuro ,
              t.DiscountIs ,
              t.DiscountIsF ,
              t.DiscountIsValue ,
              t.DiscountIsValueF ,
              t.DiscountIsValueD ,
              t.DiscountIsValueLL ,
              t.DiscountIsValueEuro ,
              t.SubTotal ,
              t.SubTotalF ,
              t.SubTotalD ,
              t.SubTotalLL ,
              t.SubTotalEuro ,
              t.DiscountInvoice ,
              t.DiscountInvoiceF ,
              t.DiscountInvoiceD ,
              t.DiscountInvoiceLL ,
              t.DiscountInvoiceEuro ,
              t.TaxRate ,
              t.TaxRateF ,
              t.TaxValue ,
              t.TaxValueF ,
              t.TaxValueD ,
              t.TaxValueLL ,
              t.TaxValueEuro ,
              t.Total ,
              t.TotalF ,
              t.TotalD ,
              t.TotalLL ,
              t.TotalEuro ,
              t.Cost ,
              t.CostF ,
              t.CostD ,
              t.CostLL ,
              t.CostEuro ,
              t.Profit ,
              t.ProfitF ,
              t.ProfitD ,
              t.ProfitLL ,
              t.ProfitEuro ,
              t.ProfitTotal ,
              t.ProfitTotalF ,
              t.ProfitTotalD ,
              t.ProfitTotalLL ,
              t.ProfitTotalEuro ,
              t.DescriptionIs ,
              t.SortAt ,
              t.DateCreate ,
              t.IsSync ,
              t.WorkStationID
      FROM    Invoices.t_SoldDetail AS t
      WHERE   t.SoldID = @ID;

      INSERT  Invoices.t_SoldDeletedProfitPartner
              ( ID ,
                SoldDeletedID ,
                ProfitPartnerID ,
                ProfitPartner ,
                ProfitRatio ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                SearchText ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  t.ID ,
              t.SoldID ,
              t.ProfitPartnerID ,
              t.ProfitPartner ,
              t.ProfitRatio ,
              t.Profit ,
              t.ProfitF ,
              t.ProfitD ,
              t.ProfitLL ,
              t.ProfitEuro ,
              t.SearchText ,
              t.DateCreate ,
              t.IsSync ,
              t.WorkStationID
      FROM    Invoices.t_SoldProfitPartner AS t
      WHERE   t.SoldID = @ID;
   
      INSERT  Invoices.t_SoldDeletedDetailProfitPartner
              ( ID ,
                SoldDeletedID ,
                SoldDeletedDetailID ,
                ProfitPartnerID ,
                ProfitPartner ,
                ProfitRatio ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                SearchText ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  t.ID ,
              t.SoldID ,
              t.SoldDetailID ,
              t.ProfitPartnerID ,
              t.ProfitPartner ,
              t.ProfitRatio ,
              t.Profit ,
              t.ProfitF ,
              t.ProfitD ,
              t.ProfitLL ,
              t.ProfitEuro ,
              t.SearchText ,
              t.DateCreate ,
              t.IsSync ,
              t.WorkStationID
      FROM    Invoices.t_SoldDetailProfitPartner AS t
      WHERE   t.SoldID = @ID;

    END;

    BEGIN --Delete

      DELETE  FROM Invoices.t_SoldProfitPartner
      OUTPUT  Deleted.ProfitPartnerID ,
              Deleted.ProfitD ,
              Deleted.ProfitLL ,
              Deleted.ProfitEuro
              INTO @SoldProfitPartnerDelete
      WHERE   SoldID = @ID;

      DELETE  FROM Invoices.t_SoldDetailProfitPartner
      WHERE   SoldID = @ID;

      DELETE  FROM Invoices.t_SoldDetail
      OUTPUT  Deleted.ItemID ,
              Deleted.ItemSharedID ,
              Deleted.Qtys
              INTO @ItemQty
      WHERE   SoldID = @ID;

      DELETE  FROM Invoices.t_Sold
      WHERE   ID = @ID;

    END;

    BEGIN --Delete t_Transaction

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = 2
              AND LinkID = @ID;

    END;

    BEGIN --Fix item qty

      INSERT  INTO @ItemQtyNet
              ( ID ,
                Qty
              )
      SELECT  s.ID ,
              COALESCE(SUM(s.Qty), 0)
      FROM    @ItemQty AS s
      GROUP BY s.ID;

      MERGE Items.t_Item AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID
        AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET
               t.QtyCurrent += s.Qty;

    END;

    BEGIN --Fix shared item qty

      DELETE  FROM @ItemQtyNet;

      INSERT  INTO @ItemQtyNet
              ( ID ,
                Qty
              )
      SELECT  s.SharedID ,
              COALESCE(SUM(s.Qty), 0)
      FROM    @ItemQty AS s
      GROUP BY s.SharedID;

      MERGE Items.t_ItemShared AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID
        AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET
               t.QtyCurrent += s.Qty ,
               t.PurchaseTotal = t.Purchase * ( t.QtyCurrent + s.Qty ) ,
               t.PurchaseTotalF = Currencys.f_Format(t.CurrencyID, t.Purchase * ( t.QtyCurrent + s.Qty )) ,
               t.PurchaseTotalD = t.PurchaseD * ( t.QtyCurrent + s.Qty ) ,
               t.PurchaseTotalLL = t.PurchaseLL * ( t.QtyCurrent + s.Qty ) ,
               t.PurchaseTotalEuro = t.PurchaseEuro * ( t.QtyCurrent + s.Qty ) ,
               t.PurchaseTotalWithTaxF = Currencys.f_Format(t.CurrencyID, t.PurchaseWithTax * ( t.QtyCurrent + s.Qty )) ,
               t.PurchaseTotalWithTaxD = t.PurchaseWithTaxD * ( t.QtyCurrent + s.Qty ) ,
               t.PurchaseTotalWithTaxLL = t.PurchaseWithTaxLL * ( t.QtyCurrent + s.Qty ) ,
               t.PurchaseTotalWithTaxEuro = t.PurchaseWithTaxEuro * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotal = t.Sell * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](t.ID), t.Sell * ( t.QtyCurrent + s.Qty )) ,
               t.SellTotalD = t.SellD * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalLL = t.SellLL * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalEuro = t.SellEuro * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalWithTax = t.SellWithTax * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalWithTaxF = Currencys.f_Format(t.SellCurrencyID, t.SellWithTax * ( t.QtyCurrent + s.Qty )) ,
               t.SellTotalWithTaxD = t.SellWithTaxD * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalWithTaxLL = t.SellWithTaxLL * ( t.QtyCurrent + s.Qty ) ,
               t.SellTotalWithTaxEuro = t.SellWithTaxEuro * ( t.QtyCurrent + s.Qty );

    END;

    BEGIN --Fix t_Account

      UPDATE  Company.t_Account
      SET     SoldC -= 1 ,
              SoldTotal = [Invoices].[f_SoldGetTotalByAccountCustomerID](ID) ,
              SoldProfit = [Invoices].[f_SoldGetProfitByAccountCustomerID](ID) ,
              SoldLast = [Invoices].f_SoldGetLastDateByAccountCustomerID(ID)
      WHERE   ID = @CustomerID;

      UPDATE  Company.t_Account
      SET     SoldTotalF = Currencys.f_Format(CurrencyID, SoldTotal) ,
              SoldProfitF = Currencys.f_Format(CurrencyID, SoldProfit)
      WHERE   ID = @CustomerID;
		  
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
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN-- Delete t_ItemProduction

      BEGIN --Declare

        DECLARE @ItemID UNIQUEIDENTIFIER ,
          @ItemSharedID UNIQUEIDENTIFIER ,
          @Qtys FLOAT;

      END;

      BEGIN --Set info

        SELECT TOP ( 1 )
                @ItemID = s.ItemID ,
                @ItemSharedID = s.ItemSharedID ,
                @Qtys = s.Qtys
        FROM    Items.t_ItemProduction AS s
        WHERE   s.SoldID = @ID
        ORDER BY s.ID;

      END;

      BEGIN --Delete

        DELETE  FROM @ItemQty;

        DELETE  FROM Items.t_ItemProductionMaterial
        OUTPUT  Deleted.ItemID ,
                Deleted.ItemSharedID ,
                Deleted.Qtys
                INTO @ItemQty
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   Items.t_ItemProduction AS s
                         WHERE  s.SoldID = @ID
                                AND s.ID = t_ItemProductionMaterial.ItemProductionID );

        DELETE  FROM Items.t_ItemProduction
        WHERE   SoldID = @ID;

      END;

      BEGIN --Fix item qty

        INSERT  INTO @ItemQtyNet
                ( ID ,
                  Qty
                )
        SELECT  s.ID ,
                COALESCE(SUM(s.Qty), 0)
        FROM    @ItemQty AS s
        GROUP BY s.ID;

        MERGE Items.t_Item AS t
        USING @ItemQtyNet AS s
        ON s.ID = t.ID
          AND t.TypeIs = 0
        WHEN MATCHED THEN
          UPDATE SET t.QtyCurrent += s.Qty;

        UPDATE  Items.t_Item
        SET     QtyCurrent -= @Qtys
        WHERE   ID = @ItemID
                AND TypeIs = 0;

      END;

      BEGIN --Fix shared item qty

        DELETE  FROM @ItemQtyNet;

        INSERT  INTO @ItemQtyNet
                ( ID ,
                  Qty
                )
        SELECT  s.SharedID ,
                COALESCE(SUM(s.Qty), 0)
        FROM    @ItemQty AS s
        GROUP BY s.SharedID;

        MERGE Items.t_ItemShared AS t
        USING @ItemQtyNet AS s
        ON s.ID = t.ID
          AND t.TypeIs = 0
        WHEN MATCHED THEN
          UPDATE SET t.QtyCurrent += s.Qty;

        UPDATE  Items.t_ItemShared
        SET     QtyCurrent -= @Qtys
        WHERE   ID = @ItemSharedID
                AND TypeIs = 0;

        UPDATE  Items.t_ItemShared
        SET     PurchaseTotal = Purchase * QtyCurrent ,
                PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
                PurchaseTotalD = PurchaseD * QtyCurrent ,
                PurchaseTotalLL = PurchaseLL * QtyCurrent ,
                PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
                PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
                PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
                PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
                PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
                PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent ,
                SellTotal = Sell * QtyCurrent ,
                SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](ID), Sell * QtyCurrent) ,
                SellTotalD = SellD * QtyCurrent ,
                SellTotalLL = SellLL * QtyCurrent ,
                SellTotalEuro = SellEuro * QtyCurrent ,
                SellTotalWithTax = SellWithTax * QtyCurrent ,
                SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent) ,
                SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
                SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
                SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
        WHERE   ID = @ItemSharedID
                OR EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                            FROM    @ItemQtyNet AS s
                            WHERE   s.ID = t_ItemShared.ID );

      END;

    END;

    BEGIN --Update t_ProfitPartner
    
      MERGE Items.t_ProfitPartner AS t
      USING @SoldProfitPartnerDelete AS s
      ON s.ProfitPartnerID = t.ID
      WHEN MATCHED THEN
        UPDATE SET
               t.SalesInvoicesCount -= 1 ,
               t.TotalProfitD -= s.ProfitD ,
               t.TotalProfitLL -= s.ProfitLL ,
               t.TotalProfitEuro -= s.ProfitEuro;

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
