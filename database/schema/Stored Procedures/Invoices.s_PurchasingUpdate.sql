SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_PurchasingUpdate] @RefPaper NVARCHAR(MAX) ,
  @InvoiceTitleID UNIQUEIDENTIFIER ,
  @DateIs DATETIME ,
  @VendorID UNIQUEIDENTIFIER ,
  @AccountTaxID UNIQUEIDENTIFIER ,
  @AccountIDPurchaseNonTaxable UNIQUEIDENTIFIER ,
  @AccountIDPurchaseTaxable UNIQUEIDENTIFIER ,
  @BoxID UNIQUEIDENTIFIER ,
  @PaymentMethod TINYINT ,
  @Payment FLOAT ,
  @RebuildRV BIT ,
  @Net FLOAT ,
  @NetNonTaxable FLOAT ,
  @NetTaxableWithoutTax FLOAT ,
  @Tax FLOAT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @TaxExchangeRateLL DECIMAL(18, 2) ,
  @TaxExchangeRateEuro DECIMAL(18, 2) ,
  @TaxExchangeRateEvent NVARCHAR(MAX) ,
  @DiscountIs FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @DetailIs Invoices.tt_PurchasingDetail READONLY ,
  @SerialIs Items.tt_ItemSerial READONLY ,
  @StatementIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventInsert NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    SET ANSI_WARNINGS OFF;

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @TransactionIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @Item AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          SharedID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 4) NOT NULL
        );

      DECLARE @ItemQtyOld AS TABLE
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

      DECLARE @Ref BIGINT ,
        @VendorIDOld UNIQUEIDENTIFIER ,
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @TransactionRefJV BIGINT ,
        @TransactionRefPV BIGINT ,
        @RowNumber INT ,
        @Vendor NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @return INT ,
        @LinkType TINYINT = 0 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT ,
        @VLL FLOAT ,
        @VEuro FLOAT ,
        @StatementIs_ NVARCHAR(MAX);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 ) @TransactionRefJV = s.Ref
        FROM Transactions.t_Transaction AS s
        WHERE s.LinkType = @LinkType AND s.LinkID = @ID AND s.TypeIs = N'JV' AND s.LinkTypeSub = 0
        ORDER BY s.ID;
	 
      SELECT TOP ( 1 ) @TransactionRefPV = s.Ref
        FROM Transactions.t_Transaction AS s
        WHERE s.LinkType = @LinkType AND s.LinkID = @ID AND s.TypeIs = N'PV' AND s.LinkTypeSub = 0
        ORDER BY s.ID;

      SET @Vendor = Company.f_AccountGetName(@VendorID);
      SET @Box = Company.f_AccountGetName(@BoxID);

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
      SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);
      IF @CurrencyTypeIs <> 0
      BEGIN

        SET @TaxExchangeRateLL = @ExchangeRateLL;
        SET @TaxExchangeRateEuro = @ExchangeRateEuro;

      END;

      INSERT INTO @ItemQtyOld
          ( ID ,
            SharedID ,
            Qty
          )
        SELECT s.ItemID ,
            s.ItemSharedID ,
            s.Qtys
          FROM Invoices.t_PurchasingDetail AS s
          WHERE s.PurchasingID = @ID;

      SELECT TOP ( 1 ) @Ref = s.Ref ,
          @VendorIDOld = s.AccountVendorID
        FROM Invoices.t_Purchasing AS s
        WHERE s.ID = @ID
        ORDER BY s.ID;
    
      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;

    END;

    BEGIN --Update

      SET @return = 0;

      UPDATE Invoices.t_Purchasing
        SET RefPaper = @RefPaper ,
            InvoiceTitleID = @InvoiceTitleID ,
            InvoiceTitle = Invoices.f_InvoiceTitleGetName(@InvoiceTitleID) ,
            DateIs = @DateIs ,
            DateOnly = @DateIs ,
            DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            AccountVendorID = @VendorID ,
            AccountVendor = Company.f_AccountGetName(@VendorID) ,
            AccountVendorNumber = Company.f_AccountGetNumberF(@VendorID) ,
            AccountBoxID = @BoxID ,
            AccountBox = Company.f_AccountGetName(@BoxID) ,
            AccountBoxNumber = Company.f_AccountGetNumberF(@BoxID) ,
            PaymentMethod = @PaymentMethod ,
            CurrencyID = @CurrencyID ,
            Currency = @Currency ,
            ExchangeRate = @ExchangeRate ,
            ExchangeRateLL = @ExchangeRateLL ,
            ExchangeRateEuro = @ExchangeRateEuro ,
            TaxExchangeRateLL = @TaxExchangeRateLL ,
            TaxExchangeRateEuro = @TaxExchangeRateEuro ,
            Total = ( SELECT COALESCE(SUM(s.SubTotal), 0)
                        FROM @DetailIs AS s
                    ) ,
            DiscountIs = @DiscountIs ,
            TaxValue = @Tax ,
            NetIs = ( SELECT COALESCE(SUM(s.Total), 0)
                        FROM @DetailIs AS s
                    ) ,
            Profit = ( SELECT COALESCE(SUM(s.ProfitTotal), 0)
                        FROM @DetailIs AS s
                     ) ,
            Sell = ( SELECT COALESCE(SUM(s.Sell * s.Qtys), 0)
                      FROM @DetailIs AS s
                   ) ,
            Qtys = ( SELECT COALESCE(SUM(s.Qtys), 0)
                      FROM @DetailIs AS s
                   ) ,
            DescriptionIs = @DescriptionIs ,
            FirstPayment = @Payment
        WHERE ID = @ID;

    END;

    BEGIN --Insert detail

      MERGE Invoices.t_PurchasingDetail AS t
      USING @DetailIs AS s
      ON s.ID = t.ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
                 PurchasingID ,
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
                 Sell ,
                 SellF ,
                 SellD ,
                 SellLL ,
                 SellEuro ,
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
                 SortAt
               )
        VALUES ( s.ID ,
                 @ID ,
                 s.ItemSharedID ,
                 s.ItemID ,
                 s.ItemUnityID ,
                 s.Qty ,
                 FORMAT(s.Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID) ,
                 s.Qty * Items.f_UnityItemGetQty(s.ItemUnityID) ,
                 s.Price ,
                 Currencys.f_Format(@CurrencyID, s.Price) ,
                 s.Price / @ExchangeRate ,
                 ( s.Price / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.Price / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.DiscountIs ,
                 FORMAT(s.DiscountIs, '0.##') + ' %' ,
                 s.DiscountIsValue ,
                 Currencys.f_Format(@CurrencyID, s.DiscountIsValue) ,
                 s.DiscountIsValue / @ExchangeRate ,
                 ( s.DiscountIsValue / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.DiscountIsValue / @ExchangeRate ) * @ExchangeRateEuro ,
                 ( s.Price * s.Qty ) - s.DiscountIsValue ,
                 Currencys.f_Format(@CurrencyID, ( s.Price * s.Qty ) - s.DiscountIsValue) ,
                 ( ( s.Price * s.Qty ) - s.DiscountIsValue ) / @ExchangeRate ,
                 ( ( ( s.Price * s.Qty ) - s.DiscountIsValue ) / @ExchangeRate ) * @ExchangeRateLL ,
                 ( ( ( s.Price * s.Qty ) - s.DiscountIsValue ) / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.DiscountInvoice ,
                 Currencys.f_Format(@CurrencyID, s.DiscountInvoice) ,
                 s.DiscountInvoice / @ExchangeRate ,
                 ( s.DiscountInvoice / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.DiscountInvoice / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.TaxRate ,
                 FORMAT(s.TaxRate, '0.##') + ' %' ,
                 s.TaxValue ,
                 Currencys.f_Format(@CurrencyID, s.TaxValue) ,
                 s.TaxValue / @ExchangeRate ,
                 ( s.TaxValue / @ExchangeRate ) * @TaxExchangeRateLL ,
                 ( s.TaxValue / @ExchangeRate ) * @TaxExchangeRateEuro ,
                 s.Total ,
                 Currencys.f_Format(@CurrencyID, s.Total) ,
                 s.Total / @ExchangeRate ,
                 ( s.Total / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.Total / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.Sell ,
                 Currencys.f_Format(@CurrencyID, s.Sell) ,
                 s.Sell / @ExchangeRate ,
                 ( s.Sell / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.Sell / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.Profit ,
                 Currencys.f_Format(@CurrencyID, s.Profit) ,
                 s.Profit / @ExchangeRate ,
                 ( s.Profit / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.Profit / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.Profit * s.Qty ,
                 Currencys.f_Format(@CurrencyID, s.Profit * s.Qty) ,
                 ( s.Profit * s.Qty ) / @ExchangeRate ,
                 ( ( s.Profit * s.Qty ) / @ExchangeRate ) * @ExchangeRateLL ,
                 ( ( s.Profit * s.Qty ) / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.DescriptionIs ,
                 s.SortAt
               )
      WHEN MATCHED THEN
        UPDATE SET t.ItemID = s.ItemID ,
                    t.ItemUnityID = s.ItemUnityID ,
                    t.Qty = s.Qty ,
                    t.QtyWithUnity = FORMAT(s.Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID) ,
                    t.Qtys = s.Qty * Items.f_UnityItemGetQty(s.ItemUnityID) ,
                    t.Price = s.Price ,
                    t.PriceF = Currencys.f_Format(@CurrencyID, s.Price) ,
                    t.PriceD = s.Price / @ExchangeRate ,
                    t.PriceLL = ( s.Price / @ExchangeRate ) * @ExchangeRateLL ,
                    t.PriceEuro = ( s.Price / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.DiscountIs = s.DiscountIs ,
                    t.DiscountIsF = FORMAT(s.DiscountIs, '0.##') + ' %' ,
                    t.DiscountIsValue = s.DiscountIsValue ,
                    t.DiscountIsValueF = Currencys.f_Format(@CurrencyID, s.DiscountIsValue) ,
                    t.DiscountIsValueD = s.DiscountIsValue / @ExchangeRate ,
                    t.DiscountIsValueLL = ( s.DiscountIsValue / @ExchangeRate ) * @ExchangeRateLL ,
                    t.DiscountIsValueEuro = ( s.DiscountIsValue / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.SubTotal = s.SubTotal ,
                    t.SubTotalF = Currencys.f_Format(@CurrencyID, s.SubTotal) ,
                    t.SubTotalD = s.SubTotal / @ExchangeRate ,
                    t.SubTotalLL = ( s.SubTotal / @ExchangeRate ) * @ExchangeRateLL ,
                    t.SubTotalEuro = ( s.SubTotal / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.DiscountInvoice = s.DiscountInvoice ,
                    t.DiscountInvoiceF = Currencys.f_Format(@CurrencyID, s.DiscountInvoice) ,
                    t.DiscountInvoiceD = s.DiscountInvoice / @ExchangeRate ,
                    t.DiscountInvoiceLL = ( s.DiscountInvoice / @ExchangeRate ) * @ExchangeRateLL ,
                    t.DiscountInvoiceEuro = ( s.DiscountInvoice / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.TaxRate = s.TaxRate ,
                    t.TaxRateF = FORMAT(s.TaxRate, '0.##') + ' %' ,
                    t.TaxValue = s.TaxValue ,
                    t.TaxValueF = Currencys.f_Format(@CurrencyID, s.TaxValue) ,
                    t.TaxValueD = s.TaxValue / @ExchangeRate ,
                    t.TaxValueLL = ( s.TaxValue / @ExchangeRate ) * @TaxExchangeRateLL ,
                    t.TaxValueEuro = ( s.TaxValue / @ExchangeRate ) * @TaxExchangeRateEuro ,
                    t.Total = s.Total ,
                    t.TotalF = Currencys.f_Format(@CurrencyID, s.Total) ,
                    t.TotalD = s.Total / @ExchangeRate ,
                    t.TotalLL = ( s.Total / @ExchangeRate ) * @ExchangeRateLL ,
                    t.TotalEuro = ( s.Total / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.Sell = s.Sell ,
                    t.SellF = Currencys.f_Format(@CurrencyID, s.Sell) ,
                    SellD = s.Sell / @ExchangeRate ,
                    t.SellLL = ( s.Sell / @ExchangeRate ) * @ExchangeRateLL ,
                    t.SellEuro = ( s.Sell / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.Profit = s.Profit ,
                    t.ProfitF = Currencys.f_Format(@CurrencyID, s.Profit) ,
                    t.ProfitD = s.Profit / @ExchangeRate ,
                    t.ProfitLL = ( s.Profit / @ExchangeRate ) * @ExchangeRateLL ,
                    t.ProfitEuro = ( s.Profit / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.ProfitTotal = s.Profit * s.Qty ,
                    t.ProfitTotalF = Currencys.f_Format(@CurrencyID, s.Profit * s.Qty) ,
                    t.ProfitTotalD = s.Profit * s.Qty / @ExchangeRate ,
                    t.ProfitTotalLL = ( s.Profit * s.Qty / @ExchangeRate ) * @ExchangeRateLL ,
                    t.ProfitTotalEuro = ( s.Profit * s.Qty / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.DescriptionIs = s.DescriptionIs ,
                    t.SortAt = s.SortAt
      WHEN NOT MATCHED BY SOURCE AND t.PurchasingID = @ID THEN
        DELETE;

      INSERT INTO @Item
          ( ID ,
            SharedID ,
            Qty
          )
        SELECT s.ItemID ,
            s.ItemSharedID ,
            s.Qtys
          FROM Invoices.t_PurchasingDetail AS s
          WHERE s.PurchasingID = @ID;

    END;

    BEGIN --Insert serial

      INSERT INTO Items.t_ItemSerial
          ( ID ,
            ItemSharedID ,
            ItemID ,
            SerialText ,
            SectionType ,
            LinkID
          )
        SELECT s.ID ,
            s.ItemSharedID ,
            s.ItemID ,
            s.SerialText ,
            0 ,
            @ID
          FROM @SerialIs AS s;

    END;

    BEGIN --Insert detial serial

      INSERT INTO Invoices.t_PurchasingDetailSerial
          ( PurchasingID ,
            PurchasingDetailID ,
            SerialID
          )
        SELECT @ID ,
            s.FatherID ,
            s.ID
          FROM @SerialIs AS s;

    END;

    BEGIN --Rebuild statistics

      UPDATE Invoices.t_Purchasing
        SET TotalF = Currencys.f_Format(CurrencyID, Total) ,
            TotalD = Total / ExchangeRate ,
            TotalLL = ( Total / ExchangeRate ) * @ExchangeRateLL ,
            TotalEuro = ( Total / ExchangeRate ) * @ExchangeRateEuro ,
            DiscountIsF = Currencys.f_Format(CurrencyID, DiscountIs) ,
            DiscountIsD = DiscountIs / ExchangeRate ,
            DiscountIsLL = ( DiscountIs / ExchangeRate ) * @ExchangeRateLL ,
            DiscountIsEuro = ( DiscountIs / ExchangeRate ) * @ExchangeRateEuro ,
            TaxRate = 0 ,
            TaxRateF = N'0 %' ,
            TaxValueF = Currencys.f_Format(CurrencyID, TaxValue) ,
            TaxValueD = TaxValue / ExchangeRate ,
            TaxValueLL = ( TaxValue / ExchangeRate ) * @TaxExchangeRateLL ,
            TaxValueEuro = ( TaxValue / ExchangeRate ) * @TaxExchangeRateEuro ,
            NetIsF = Currencys.f_Format(CurrencyID, NetIs) ,
            NetIsD = NetIs / ExchangeRate ,
            NetIsLL = ( ( ( NetIs - TaxValue ) / ExchangeRate ) * @ExchangeRateLL ) + ( TaxValue / @ExchangeRate ) * @TaxExchangeRateLL ,
            NetIsEuro = ( ( ( NetIs - TaxValue ) / ExchangeRate ) * @ExchangeRateEuro ) + ( TaxValue / @ExchangeRate ) * @TaxExchangeRateEuro ,
            NetIsAR = Currencys.f_ToWordAR(NetIs, CurrencyID, 1) ,
            NetIsEN = Currencys.f_ToWordEN(NetIs, CurrencyID, 1) ,
            ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
            ProfitD = Profit / ExchangeRate ,
            ProfitLL = ( Profit / ExchangeRate ) * @ExchangeRateLL ,
            ProfitEuro = ( Profit / ExchangeRate ) * @ExchangeRateEuro ,
            SellF = Currencys.f_Format(CurrencyID, Sell) ,
            SellD = Sell / ExchangeRate ,
            SellLL = ( Sell / ExchangeRate ) * @ExchangeRateLL ,
            SellEuro = ( Sell / ExchangeRate ) * @ExchangeRateEuro ,
            FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
            FirstPaymentD = FirstPayment / ExchangeRate ,
            FirstPaymentLL = ( FirstPayment / ExchangeRate ) * @ExchangeRateLL ,
            FirstPaymentEuro = ( FirstPayment / ExchangeRate ) * @ExchangeRateEuro ,
            ItemsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                          FROM @DetailIs AS t
                                          LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                       FOR
                                         XML PATH('')
                                       )) ,
            ItemHaveDiscount = CASE ( SELECT COALESCE(SUM(s.DiscountIsValue), 0)
                                        FROM @DetailIs AS s
                                    )
                                 WHEN 0 THEN 0
                                 ELSE 1
                               END
        WHERE ID = @ID;

      UPDATE Invoices.t_Purchasing
        SET TaxRate = ( TaxValue / ( NetIs - TaxValue ) ) * 100.0 ,
            TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
        WHERE ID = @ID AND NetIs > 0;

    END;

    BEGIN --Fix item qty

      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT o.ID ,
            COALESCE(SUM(o.Qty), 0)
          FROM ( SELECT s.ID ,
                    0 - COALESCE(SUM(s.Qty), 0) AS Qty
                  FROM @ItemQtyOld AS s
                  GROUP BY s.ID
                 UNION ALL
                 SELECT s.ID ,
                    COALESCE(SUM(s.Qty), 0)
                  FROM @Item AS s
                  GROUP BY s.ID
               ) AS o
          GROUP BY o.ID;

      MERGE Items.t_Item AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET t.QtyCurrent += s.Qty;

    END;

    BEGIN --Fix shared item qty

      DELETE FROM @ItemQtyNet;

      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT o.SharedID ,
            COALESCE(SUM(o.Qty), 0)
          FROM ( SELECT s.SharedID ,
                    0 - COALESCE(SUM(s.Qty), 0) AS Qty
                  FROM @ItemQtyOld AS s
                  GROUP BY s.SharedID
                 UNION ALL
                 SELECT s.SharedID ,
                    COALESCE(SUM(s.Qty), 0)
                  FROM @Item AS s
                  GROUP BY s.SharedID
               ) AS o
          GROUP BY o.SharedID;

      MERGE Items.t_ItemShared AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET t.QtyCurrent += s.Qty ,
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

    BEGIN --Insert last price

      DECLARE @DetailIsDistinct AS TABLE
        (
          ItemSharedID UNIQUEIDENTIFIER NOT NULL ,
          ItemUnityID UNIQUEIDENTIFIER NOT NULL ,
          Price FLOAT NOT NULL ,
          DiscountIs DECIMAL(4, 2) NOT NULL
        );

      DECLARE @DistinctIDs AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      INSERT INTO @DistinctIDs
          ( ID
          )
        SELECT MIN(s.ID)
          FROM @DetailIs AS s
          WHERE s.Price <> 0
          GROUP BY s.ItemUnityID;

      INSERT INTO @DetailIsDistinct
          ( ItemSharedID ,
            ItemUnityID ,
            Price ,
            DiscountIs
          )
        SELECT o1.ItemSharedID ,
            o1.ItemUnityID ,
            o1.Price ,
            o1.DiscountIs
          FROM @DistinctIDs AS o
          INNER JOIN @DetailIs AS o1 ON o1.ID = o.ID;

      MERGE Company.t_AccountItemPrice AS t
      USING @DetailIsDistinct AS s
      ON s.ItemUnityID = t.ItemUnityID AND t.AccountID = @VendorID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( AccountID ,
                 ItemSharedID ,
                 ItemUnityID ,
                 Unity ,
                 CurrencyID ,
                 Currency ,
                 Price ,
                 PriceF ,
                 PriceD ,
                 DiscountIs ,
                 DiscountIsF
               )
        VALUES ( @VendorID ,
                 s.ItemSharedID ,
                 s.ItemUnityID ,
                 Items.f_UnityItemGetName(s.ItemUnityID) ,
                 @CurrencyID ,
                 @Currency ,
                 s.Price ,
                 Currencys.f_Format(@CurrencyID, s.Price) ,
                 s.Price / @ExchangeRate ,
                 s.DiscountIs ,
                 FORMAT(s.DiscountIs, '0.##') + ' %'
               )
      WHEN MATCHED THEN
        UPDATE SET t.CurrencyID = @CurrencyID ,
                    t.Currency = @Currency ,
                    t.Price = s.Price ,
                    t.PriceF = Currencys.f_Format(@CurrencyID, s.Price) ,
                    t.PriceD = s.Price / @ExchangeRate ,
                    t.DiscountIs = s.DiscountIs ,
                    t.DiscountIsF = FORMAT(s.DiscountIs, '0.##') + ' %';

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Invoices.t_PurchasingMoving
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
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Delete old transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = @LinkType AND LinkID = @ID AND TypeIs = N'JV';
		
    END;	
	
    IF @Net > 0
    BEGIN --Transaction
	  
      SET @TransactionRef = @TransactionRefJV;
      IF @TransactionRef IS NULL
      BEGIN --Set info

        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'JV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkID ,
              UserID
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'JV' ,
              @DateIs ,
              REPLACE(@StatementIs, N'{0}', @Ref) ,
              @LinkType ,
              @ID ,
              @UserID
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail

        SET @V = @Net;
        SET @RowNumber = 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref);
        EXECUTE Transactions.s_TransactionDetailInsertCreditTax @RowNumber, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @Tax, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

        IF @NetNonTaxable > 0
        BEGIN --Insert detail 

          SET @V = @NetNonTaxable;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertDebit @RowNumber, @TransactionID, @AccountIDPurchaseNonTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
							
        END;

        IF @Tax > 0
        BEGIN --Insert detail tax
				
          SET @V = @NetTaxableWithoutTax;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertDebit @RowNumber, @TransactionID, @AccountIDPurchaseTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @V = @Tax;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref);
          EXECUTE Transactions.s_TransactionDetailInsertDebit @RowNumber, @TransactionID, @AccountTaxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

        END;

      END;

    END;
  
    IF @RebuildRV = 1
    BEGIN --Delete old transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = @LinkType AND LinkID = @ID AND TypeIs = N'PV';
		
    END;	

    IF @RebuildRV = 1 AND @Payment > 0
    BEGIN --Transaction

      SET @TransactionRef = @TransactionRefPV;
      IF @TransactionRef IS NULL
      BEGIN --Set info

        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'PV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE FROM @IDs;

        INSERT INTO Transactions.t_Transaction
            ( Ref ,
              TypeIs ,
              DateIs ,
              DescriptionIs ,
              LinkType ,
              LinkID ,
              UserID
            )
          OUTPUT Inserted.ID
            INTO @IDs ( ID )
          VALUES
            ( @TransactionRef ,
              N'PV' ,
              @DateIs ,
              REPLACE(@StatementIs, N'{0}', @Ref) ,
              @LinkType ,
              @ID ,
              @UserID
            );

        SET @TransactionID = ( SELECT TOP ( 1 ) s.ID
                                FROM @IDs AS s
                                ORDER BY s.ID
                             );

        INSERT @TransactionIDs
            ( ID ,
              RefF
            )
          VALUES
            ( @TransactionID ,
              CONVERT(NVARCHAR(MAX), @TransactionRef)
            );

      END;

      BEGIN --Insert detail
	  
        IF ( @Payment = @Net AND @ExchangeRateLL = @TaxExchangeRateLL AND @ExchangeRateEuro = @TaxExchangeRateEuro
           ) OR ( @Payment <= @Net - @Tax ) OR ( @CurrencyTypeIs <> 0 )
        BEGIN

          SET @V = @Payment;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

        END;
        ELSE
        BEGIN
		 
          SET @V = @Payment - @Tax;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @V = @Payment - @V;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertDebit 3, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertCredit 4, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

        END;

      END;

    END;

    BEGIN --Insert t_TransactionMoving

      SET @return = -1;

      INSERT INTO Transactions.t_TransactionMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        SELECT @UserID ,
            s.ID ,
            @Event + s.RefF ,
            0 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          FROM @TransactionIDs AS s;

    END;

    BEGIN --Fix t_Transaction
              
      UPDATE Transactions.t_Transaction
        SET RefF = FORMAT(Ref, 'n0') ,
            DateOnly = DateIs ,
            DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            AccountsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t.Account AS [text()]
                                              FROM Transactions.t_TransactionDetail AS t
                                              WHERE t.TransactionID = @TransactionID
                                          FOR
                                            XML PATH('')
                                          )) ,
            BalanceD = COALESCE(( SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 0 AND s.Balance > 0
                                ), 0) ,
            BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                    FROM Transactions.t_TransactionDetail AS s
                                    WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 1 AND s.Balance > 0
                                 ), 0) ,
            BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                      FROM Transactions.t_TransactionDetail AS s
                                      WHERE s.TransactionID = t_Transaction.ID AND s.CurrencyTypeIs = 2 AND s.Balance > 0
                                   ), 0) ,
            UserIs = Users.f_UserGetName(UserID)
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @TransactionIDs AS s
                        WHERE s.ID = t_Transaction.ID );

    END;

    BEGIN --Fix t_Account

      UPDATE Company.t_Account
        SET PurchasingTotal = Invoices.f_PurchasingGetTotalByAccountVendorID(ID) ,
            PurchasingProfit = Invoices.f_PurchasingGetProfitByAccountVendorID(ID) ,
            PurchasingLast = Invoices.f_PurchasingGetLastDateByAccountVendorID(ID)
        WHERE ID = @VendorID OR ID = @VendorIDOld;

      UPDATE Company.t_Account
        SET PurchasingTotalF = Currencys.f_Format(CurrencyID, PurchasingTotal) ,
            PurchasingProfitF = Currencys.f_Format(CurrencyID, PurchasingProfit)
        WHERE ID = @VendorID OR ID = @VendorIDOld;
		  
    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT @return;

  END CATCH;

END;






GO
