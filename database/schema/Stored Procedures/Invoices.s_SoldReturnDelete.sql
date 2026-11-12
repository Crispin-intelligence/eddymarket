SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldReturnDelete] @UserID UNIQUEIDENTIFIER ,
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

      DECLARE @CustomerID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 ) @CustomerID = s.AccountCustomerID
        FROM Invoices.t_SoldReturn AS s
        WHERE s.ID = @ID;

    END;

    BEGIN --Delete

      INSERT INTO Invoices.t_SoldReturnDeleted
          ( ID ,
            Ref ,
            RefF ,
            RefPaper ,
            InvoiceTitleID ,
            InvoiceTitle ,
            DateIs ,
            DateOnly ,
            DateMonthly ,
            DateYearly ,
            UserID ,
            UserIs ,
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
            ItemsNames ,
            ItemHaveDiscount ,
            DateCreate ,
            IsSync ,
            WorkStationID
          )
        SELECT t.ID ,
            t.Ref ,
            t.RefF ,
            t.RefPaper ,
            t.InvoiceTitleID ,
            t.InvoiceTitle ,
            t.DateIs ,
            t.DateOnly ,
            t.DateMonthly ,
            t.DateYearly ,
            t.UserID ,
            t.UserIs ,
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
            t.ItemsNames ,
            t.ItemHaveDiscount ,
            t.DateCreate ,
            t.IsSync ,
            t.WorkStationID
          FROM Invoices.t_SoldReturn AS t
          WHERE t.ID = @ID;

      INSERT INTO Invoices.t_SoldReturnDeletedDetail
          ( ID ,
            SoldReturnDeletedID ,
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
        SELECT t.ID ,
            t.SoldReturnID ,
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
          FROM Invoices.t_SoldReturnDetail AS t
          WHERE t.SoldReturnID = @ID;

    END;

    BEGIN --Delete

      DELETE FROM Invoices.t_SoldReturnDetail
        OUTPUT Deleted.ItemID ,
          Deleted.ItemSharedID ,
          Deleted.Qtys
          INTO @ItemQty
        WHERE SoldReturnID = @ID;

      DELETE FROM Invoices.t_SoldReturn
        WHERE ID = @ID;

    END;

    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = 3 AND LinkID = @ID;

    END;

    BEGIN --Fix item qty

      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT s.ID ,
            COALESCE(SUM(s.Qty), 0)
          FROM @ItemQty AS s
          GROUP BY s.ID;

      MERGE Items.t_Item AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET t.QtyCurrent -= s.Qty;

    END;

    BEGIN --Fix shared item qty

      DELETE FROM @ItemQtyNet;

      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT s.SharedID ,
            COALESCE(SUM(s.Qty), 0)
          FROM @ItemQty AS s
          GROUP BY s.SharedID;

      MERGE Items.t_ItemShared AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET t.QtyCurrent -= s.Qty ,
                    t.PurchaseTotal = t.Purchase * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalF = Currencys.f_Format(t.CurrencyID, t.Purchase * ( t.QtyCurrent - s.Qty )) ,
                    t.PurchaseTotalD = t.PurchaseD * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalLL = t.PurchaseLL * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalEuro = t.PurchaseEuro * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalWithTax = t.PurchaseWithTax * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalWithTaxF = Currencys.f_Format(t.CurrencyID, t.PurchaseWithTax * ( t.QtyCurrent - s.Qty )) ,
                    t.PurchaseTotalWithTaxD = t.PurchaseWithTaxD * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalWithTaxLL = t.PurchaseWithTaxLL * ( t.QtyCurrent - s.Qty ) ,
                    t.PurchaseTotalWithTaxEuro = t.PurchaseWithTaxEuro * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotal = t.Sell * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](t.ID), t.Sell * ( t.QtyCurrent - s.Qty )) ,
                    t.SellTotalD = t.SellD * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalLL = t.SellLL * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalEuro = t.SellEuro * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalWithTax = t.SellWithTax * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalWithTaxF = Currencys.f_Format(t.SellCurrencyID, t.SellWithTax * ( t.QtyCurrent - s.Qty )) ,
                    t.SellTotalWithTaxD = t.SellWithTaxD * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalWithTaxLL = t.SellWithTaxLL * ( t.QtyCurrent - s.Qty ) ,
                    t.SellTotalWithTaxEuro = t.SellWithTaxEuro * ( t.QtyCurrent - s.Qty );
    END;

    BEGIN --Fix t_Account

      UPDATE Company.t_Account
        SET SoldReturnC -= 1 ,
            SoldReturnTotal = [Invoices].[f_SoldReturnGetTotalByAccountCustomerID](ID) ,
            SoldReturnProfit = [Invoices].[f_SoldReturnGetProfitByAccountCustomerID](ID) ,
            SoldReturnLast = [Invoices].f_SoldReturnGetLastDateByAccountCustomerID(ID)
        WHERE ID = @CustomerID;

      UPDATE Company.t_Account
        SET SoldReturnTotalF = Currencys.f_Format(CurrencyID, SoldReturnTotal) ,
            SoldReturnProfitF = Currencys.f_Format(CurrencyID, SoldReturnProfit)
        WHERE ID = @CustomerID;
		  
    END;
  
    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Invoices.t_SoldReturnMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
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
