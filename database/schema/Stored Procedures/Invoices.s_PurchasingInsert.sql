SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_PurchasingInsert]
  @RefPaper NVARCHAR(MAX) ,
  @InvoiceTitleID UNIQUEIDENTIFIER ,
  @DateIs DATETIME ,
  @VendorID UNIQUEIDENTIFIER ,
  @AccountTaxID UNIQUEIDENTIFIER ,
  @AccountIDPurchaseNonTaxable UNIQUEIDENTIFIER ,
  @AccountIDPurchaseTaxable UNIQUEIDENTIFIER ,
  @BoxID UNIQUEIDENTIFIER ,
  @PaymentMethod TINYINT ,
  @Payment FLOAT ,
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
  @ItemExpirationDate [Items].[tt_ItemExpirationDate] READONLY ,
  @StatementIs NVARCHAR(MAX) ,
  @Expenses Company.tt_Expenses READONLY ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY

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

      DECLARE @ItemQtyNet AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 4) NOT NULL
        );

      DECLARE @Ref BIGINT ,
        @RefF NVARCHAR(MAX) ,
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @RowNumber INT ,
        @Vendor NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @AccountIsVendor BIT ,
        @LinkType TINYINT = 0 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @VD FLOAT ,
        @VLL FLOAT ,
        @VEuro FLOAT ,
        @StatementIs_ NVARCHAR(MAX) ,
        @NetD FLOAT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT  @Ref = ISNULL(MAX(s.Ref), 0) + 1
      FROM    Invoices.t_Purchasing AS s;

	  SET @RefF = FORMAT(@Ref, 'n0');

      SET @Vendor = Company.f_AccountGetName(@VendorID);
      SET @Box = Company.f_AccountGetName(@BoxID);
      SET @AccountIsVendor = [Company].[f_AccountIsVendor](@VendorID);

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
      SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);
      IF @CurrencyTypeIs <> 0
      BEGIN

        SET @TaxExchangeRateLL = @ExchangeRateLL;
        SET @TaxExchangeRateEuro = @ExchangeRateEuro;

      END;

      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;

      SET @NetD = @Net / @ExchangeRate;
      SELECT  @Profit = COALESCE(SUM(s.ProfitTotal), 0)
      FROM    @DetailIs AS s;
      SET @ProfitD = @Profit / @ExchangeRate;
       
    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT  INTO Invoices.t_Purchasing
              ( Ref ,
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
                AccountVendorID ,
                AccountVendor ,
                AccountVendorNumber ,
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
                DiscountIs ,
                TaxValue ,
                NetIs ,
                Profit ,
                Sell ,
                Qtys ,
                DescriptionIs ,
                FirstPayment
              )
      OUTPUT  Inserted.ID
              INTO @IDs ( ID )
      VALUES  ( @Ref ,
                @RefF ,
                @RefPaper ,
                @InvoiceTitleID ,
                Invoices.f_InvoiceTitleGetName(@InvoiceTitleID) ,
                @DateIs ,
                @DateIs ,
                DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
                DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
                @UserID ,
                Users.f_UserGetName(@UserID) ,
                @VendorID ,
                @Vendor ,
                Company.f_AccountGetNumberF(@VendorID) ,
                @BoxID ,
                Company.f_AccountGetName(@BoxID) ,
                Company.f_AccountGetNumberF(@BoxID) ,
                @PaymentMethod ,
                @CurrencyID ,
                @Currency ,
                @ExchangeRate ,
                @ExchangeRateLL ,
                @ExchangeRateEuro ,
                @TaxExchangeRateLL ,
                @TaxExchangeRateEuro ,
                ( SELECT  COALESCE(SUM(s.SubTotal), 0)
                  FROM    @DetailIs AS s
                ) ,
                @DiscountIs ,
                @Tax ,
                ( SELECT  COALESCE(SUM(s.Total), 0)
                  FROM    @DetailIs AS s
                ) ,
                @Profit ,
                ( SELECT  COALESCE(SUM(s.Sell * s.Qtys), 0)
                  FROM    @DetailIs AS s
                ) ,
                ( SELECT  COALESCE(SUM(s.Qtys), 0)
                  FROM    @DetailIs AS s
                ) ,
                @DescriptionIs ,
                @Payment
              );

      SET @ID = ( SELECT TOP ( 1 )
                          s.ID
                  FROM    @IDs AS s
                  ORDER BY s.ID
                );

    END;

    BEGIN --Insert detail

      INSERT  INTO Invoices.t_PurchasingDetail
              ( ID ,
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
      OUTPUT  Inserted.ItemID ,
              Inserted.ItemSharedID ,
              Inserted.Qtys
              INTO @Item
      SELECT  s.ID ,
              @ID ,
              s.ItemSharedID ,
              s.ItemID ,
              s.ItemUnityID ,
              s.Qty ,
              FORMAT(s.Qty, '#,##0.####') + ' ' + s2.Name ,
              s.Qty * s1.Qty ,
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
      FROM    @DetailIs AS s
      LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
      LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID;

    END;

    BEGIN --Insert serial

      INSERT  INTO Items.t_ItemSerial
              ( ID ,
                ItemSharedID ,
                ItemID ,
                SerialText ,
                SectionType ,
                LinkID
              )
      SELECT  s.ID ,
              s.ItemSharedID ,
              s.ItemID ,
              s.SerialText ,
              0 ,
              @ID
      FROM    @SerialIs AS s;

    END;

    BEGIN --Insert detial serial

      INSERT  INTO Invoices.t_PurchasingDetailSerial
              ( PurchasingID ,
                PurchasingDetailID ,
                SerialID
              )
      SELECT  @ID ,
              s.FatherID ,
              s.ID
      FROM    @SerialIs AS s;

    END;

    BEGIN --t_ItemExpirationDate
		
      BEGIN --Declare

        DECLARE @ItemExpirationDate_ [Items].[tt_ItemExpirationDate] ,
          @ItemExpirationDateRef BIGINT;
				
      END;
        
      BEGIN --Set info

        SELECT  @ItemExpirationDateRef = ISNULL(MAX(s.Ref), 0)
        FROM    Items.t_ItemExpirationDate AS s;

        INSERT  INTO @ItemExpirationDate_
                ( ID ,
                  ItemSharedID ,
                  ItemID ,
                  WareHouseID ,
                  Qtys ,
                  ProductionDate ,
                  ExpirationDate ,
                  NotifyMeDaysBefore ,
                  CurrencyID ,
                  Price ,
                  DescriptionIs
                )
        SELECT  MIN(s.ID) AS ID ,
                s.ItemSharedID ,
                s.ItemID ,
                s.WareHouseID ,
                SUM(s.Qtys) AS Qtys ,
                s.ProductionDate ,
                s.ExpirationDate ,
                s.NotifyMeDaysBefore ,
                s.CurrencyID ,
                s.Price ,
                s.DescriptionIs
        FROM    @ItemExpirationDate AS s
        GROUP BY s.ItemSharedID ,
                s.ItemID ,
                s.WareHouseID ,
                s.ProductionDate ,
                s.ExpirationDate ,
                s.NotifyMeDaysBefore ,
                s.CurrencyID ,
                s.Price ,
                s.DescriptionIs;

      END;

      BEGIN --Insert

        INSERT  INTO Items.t_ItemExpirationDate
                ( ID ,
                  Ref ,
                  ItemSharedID ,
                  ItemID ,
                  WareHouseID ,
                  WareHouse ,
                  PlaceID ,
                  Place ,
                  SectionIs ,
                  SectionID ,
                  Qtys ,
                  ProductionDate ,
                  ExpirationDate ,
                  NotifyMeDaysBefore ,
                  NotificationDate ,
                  CurrencyID ,
                  Currency ,
                  Price ,
                  PriceF ,
                  PriceD ,
                  PriceLL ,
                  PriceEuro ,
                  DescriptionIs 
                )
        SELECT  s.ID ,
                @ItemExpirationDateRef + ROW_NUMBER() OVER ( ORDER BY ( SELECT  1
                                                                      ) ) ,
                s.ItemSharedID ,
                s.ItemID ,
                s.WareHouseID ,
                Company.f_WareHouseGetName(s.WareHouseID) ,
                Company.f_PlaceGetFirstID1(s.WareHouseID) ,
                Company.f_PlaceGetFirstName1(s.WareHouseID) ,
                0 ,
                @ID ,
                s.Qtys ,
                s.ProductionDate ,
                s.ExpirationDate ,
                s.NotifyMeDaysBefore ,
                DATEADD(DAY, 0 - s.NotifyMeDaysBefore, s.ExpirationDate) ,
                s.CurrencyID ,
                Currencys.f_CurrencyGetName(s.CurrencyID) ,
                s.Price ,
                Currencys.f_Format(s.CurrencyID, s.Price) ,
                s.Price / s1.ExchangeRate ,
                Currencys.f_ExchangeToLL(s.CurrencyID, s.Price, s.Price / s1.ExchangeRate) ,
                Currencys.f_ExchangeToEuro(s.CurrencyID, s.Price, s.Price / s1.ExchangeRate) ,
                s.DescriptionIs
        FROM    @ItemExpirationDate_ AS s
        LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID;

      END;
         
      BEGIN --Fix Ref

        UPDATE  Items.t_ItemExpirationDate
        SET     RefF = FORMAT(Ref, 'n0')
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @ItemExpirationDate_ AS s
                         WHERE  s.ID = t_ItemExpirationDate.ID );

      END;

      BEGIN --Insert event

        SET @return = -1;

        INSERT  INTO Items.t_ItemExpirationDateMoving
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
                @Event + N': ' + s1.RefF ,
                0 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
        FROM    @ItemExpirationDate_ AS s
        LEFT JOIN Items.t_ItemExpirationDate AS s1 ON s1.ID = s.ID;

      END;

    END;

    BEGIN --Rebuild statistics

      SET @return = 0;

      UPDATE  Invoices.t_Purchasing
      SET     TotalF = Currencys.f_Format(CurrencyID, Total) ,
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
              ItemsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                  ', ' + t1.Name AS [text()]
                                           FROM   @DetailIs AS t
                                           LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                         FOR
                                           XML PATH('')
                                         )) ,
              ItemHaveDiscount = CASE ( SELECT  COALESCE(SUM(s.DiscountIsValue), 0)
                                        FROM    @DetailIs AS s
                                      )
                                   WHEN 0 THEN 0
                                   ELSE 1
                                 END
      WHERE   ID = @ID;

      UPDATE  Invoices.t_Purchasing
      SET     TaxRate = ( TaxValue / ( NetIs - TaxValue ) ) * 100.0 ,
              TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
      WHERE   ID = @ID
              AND NetIs > 0;

    END;

    IF @AccountIsVendor = 1
    BEGIN --Insert items vendors

      DECLARE @ItemVendor AS TABLE
        (
          ItemSharedID UNIQUEIDENTIFIER NOT NULL ,
          VendorID UNIQUEIDENTIFIER NOT NULL ,
          Vendor NVARCHAR(MAX) NOT NULL ,
          Price FLOAT NOT NULL
        );

      INSERT  INTO @ItemVendor
              ( ItemSharedID ,
                VendorID ,
                Vendor ,
                Price
              )
      SELECT  s.ItemSharedID ,
              s2.LinkWithID ,
              s3.Name ,
              s.Price / s1.Qty
      FROM    @DetailIs AS s
      LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
      LEFT JOIN Company.t_Account AS s2 ON s2.ID = @VendorID
                                           AND s2.SectionID = 67
      LEFT JOIN Vendors.t_Vendor AS s3 ON s3.ID = s2.LinkWithID
      WHERE   ( s.Price / s1.Qty ) > 0;

      WITH  o AS ( SELECT ROW_NUMBER() OVER ( PARTITION BY s.ItemSharedID ORDER BY ( SELECT 0
                                                                                   ) ) AS CountRowIs
                   FROM   @ItemVendor AS s
                 )
        DELETE  FROM o
        WHERE   o.CountRowIs > 1;

      MERGE Items.t_ItemSharedVendor AS t
      USING @ItemVendor AS s
      ON s.ItemSharedID = t.SharedID
        AND s.VendorID = t.VendorID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( VendorID ,
                 Vendor ,
                 SharedID ,
                 CurrencyID ,
                 Currency ,
                 Price ,
                 PriceF ,
                 PriceD
               )
        VALUES ( s.VendorID ,
                 s.Vendor ,
                 s.ItemSharedID ,
                 @CurrencyID ,
                 @Currency ,
                 s.Price ,
                 Currencys.f_Format(@CurrencyID, s.Price) ,
                 s.Price / @ExchangeRate
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.CurrencyID = @CurrencyID ,
               t.Currency = @Currency ,
               t.Price = s.Price ,
               t.PriceF = Currencys.f_Format(@CurrencyID, s.Price) ,
               t.PriceD = s.Price / @ExchangeRate;

    END;

    BEGIN --Fix item qty

      INSERT  INTO @ItemQtyNet
              ( ID ,
                Qty
              )
      SELECT  s.ID ,
              COALESCE(SUM(s.Qty), 0)
      FROM    @Item AS s
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
      FROM    @Item AS s
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
               t.PurchaseTotalWithTax = t.PurchaseWithTax * ( t.QtyCurrent + s.Qty ) ,
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
               t.SellTotalWithTaxEuro = t.SellWithTaxEuro * ( t.QtyCurrent + s.Qty ) ,
               t.VendorC = ( SELECT COUNT(*)
                             FROM   Items.t_ItemSharedVendor AS s2
                             WHERE  s2.SharedID = t.ID
                           ) ,
               t.VendorNames = Alls.f_FixXML(( SELECT N', ' + s1.Vendor AS [text()]
                                               FROM   Items.t_ItemSharedVendor AS s1
                                               WHERE  s1.SharedID = t.ID
                                             FOR
                                               XML PATH('')
                                             ));

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

      INSERT  INTO @DistinctIDs
              ( ID
              )
      SELECT  MIN(s.ID)
      FROM    @DetailIs AS s
      WHERE   s.Price <> 0
      GROUP BY s.ItemUnityID;

      INSERT  INTO @DetailIsDistinct
              ( ItemSharedID ,
                ItemUnityID ,
                Price ,
                DiscountIs
              )
      SELECT  o1.ItemSharedID ,
              o1.ItemUnityID ,
              o1.Price ,
              o1.DiscountIs
      FROM    @DistinctIDs AS o
      INNER JOIN @DetailIs AS o1 ON o1.ID = o.ID;

      MERGE Company.t_AccountItemPrice AS t
      USING @DetailIsDistinct AS s
      ON s.ItemUnityID = t.ItemUnityID
        AND t.AccountID = @VendorID
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
        UPDATE SET
               t.CurrencyID = @CurrencyID ,
               t.Currency = @Currency ,
               t.Price = s.Price ,
               t.PriceF = Currencys.f_Format(@CurrencyID, s.Price) ,
               t.PriceD = s.Price / @ExchangeRate ,
               t.DiscountIs = s.DiscountIs ,
               t.DiscountIsF = FORMAT(s.DiscountIs, '0.##') + ' %';

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT  INTO Invoices.t_PurchasingMoving
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
                @Event + N': ' + @RefF ,
                0 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    IF @Net > 0
    BEGIN --Transaction

      BEGIN --Set info

        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'JV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE  FROM @IDs;

        INSERT  INTO Transactions.t_Transaction
                ( Ref ,
                  TypeIs ,
                  DateIs ,
                  DescriptionIs ,
                  LinkType ,
                  LinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TransactionRef ,
                  N'JV' ,
                  @DateIs ,
                  REPLACE(@StatementIs, N'{0}', @RefF) ,
                  @LinkType ,
                  @ID ,
                  @UserID
                );

        SET @TransactionID = ( SELECT TOP ( 1 )
                                      s.ID
                               FROM   @IDs AS s
                               ORDER BY s.ID
                             );

        INSERT  @TransactionIDs
                ( ID ,
                  RefF
                )
        VALUES  ( @TransactionID ,
                  CONVERT(NVARCHAR(MAX), @TransactionRef)
                );

      END;

      BEGIN --Insert detail

        SET @V = @Net;
        SET @RowNumber = 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF);
        EXECUTE Transactions.s_TransactionDetailInsertCreditTax @RowNumber, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @Tax,
          @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

        IF @NetNonTaxable > 0
        BEGIN --Insert detail 

          SET @V = @NetNonTaxable;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertDebit @RowNumber, @TransactionID, @AccountIDPurchaseNonTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro,
            @StatementIs_;
							
        END;

        IF @Tax > 0
        BEGIN --Insert detail tax
				
          SET @V = @NetTaxableWithoutTax;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertDebit @RowNumber, @TransactionID, @AccountIDPurchaseTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro,
            @StatementIs_;

          SET @V = @Tax;
          SET @RowNumber += 1;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF);
          EXECUTE Transactions.s_TransactionDetailInsertDebit @RowNumber, @TransactionID, @AccountTaxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL,
            @TaxExchangeRateEuro, @StatementIs_;

        END;

      END;

    END;

    IF @Payment > 0
    BEGIN --Transaction

      BEGIN --Set info

        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'PV';

      END;

      BEGIN --Insert transaction

        SET @return = 0;

        DELETE  FROM @IDs;

        INSERT  INTO Transactions.t_Transaction
                ( Ref ,
                  TypeIs ,
                  DateIs ,
                  DescriptionIs ,
                  LinkType ,
                  LinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TransactionRef ,
                  N'PV' ,
                  @DateIs ,
                  REPLACE(@StatementIs, N'{0}', @RefF) ,
                  @LinkType ,
                  @ID ,
                  @UserID
                );

        SET @TransactionID = ( SELECT TOP ( 1 )
                                      s.ID
                               FROM   @IDs AS s
                               ORDER BY s.ID
                             );

        INSERT  @TransactionIDs
                ( ID ,
                  RefF
                )
        VALUES  ( @TransactionID ,
                  CONVERT(NVARCHAR(MAX), @TransactionRef)
                );

      END;

      BEGIN --Insert detail
	  
        IF ( @Payment = @Net
             AND @ExchangeRateLL = @TaxExchangeRateLL
             AND @ExchangeRateEuro = @TaxExchangeRateEuro
           )
          OR ( @Payment <= @Net - @Tax )
          OR ( @CurrencyTypeIs <> 0 )
        BEGIN

          SET @V = @Payment;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

        END;
        ELSE
        BEGIN
		 
          SET @V = @Payment - @Tax;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @V = @Payment - @V;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Box + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL,
                                                                                                                                  N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertDebit 3, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro,
            @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @RefF) + ' \ ' + @Vendor + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL,
                                                                                                                                     N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertCredit 4, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro,
            @StatementIs_;

        END;

      END;

    END;
	
	--Expenses
    EXECUTE Company.s_ExpenseInsertsPART 0, @ID, @RefF, @DateIs, @Expenses, @UserID, @Event, @ComputerIP, @Computer, @ComputerAccount;

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
              @Event + s.RefF ,
              0 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @TransactionIDs AS s;

    END;

    BEGIN --Fix t_Transaction
	                  
      UPDATE  Transactions.t_Transaction
      SET     RefF = FORMAT(Ref, 'n0') ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              AccountsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t.Account AS [text()]
                                              FROM    Transactions.t_TransactionDetail AS t
                                              WHERE   t.TransactionID = @TransactionID
                                            FOR
                                              XML PATH('')
                                            )) ,
              BalanceD = COALESCE(( SELECT  SUM(s.Balance)
                                    FROM    Transactions.t_TransactionDetail AS s
                                    WHERE   s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 0
                                            AND s.Balance > 0
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                     FROM   Transactions.t_TransactionDetail AS s
                                     WHERE  s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 1
                                            AND s.Balance > 0
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                       FROM   Transactions.t_TransactionDetail AS s
                                       WHERE  s.TransactionID = t_Transaction.ID
                                              AND s.CurrencyTypeIs = 2
                                              AND s.Balance > 0
                                     ), 0) ,
              UserIs = Users.f_UserGetName(UserID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @TransactionIDs AS s
                       WHERE  s.ID = t_Transaction.ID );

    END;

    BEGIN --Fix t_Account

      UPDATE  Company.t_Account
      SET     PurchasingC += 1 ,
              PurchasingTotal = CASE CurrencyTypeIs
                                  WHEN 0 THEN @NetD
                                  WHEN 1 THEN @NetD * @ExchangeRateLL
                                  ELSE @NetD * @ExchangeRateEuro
                                END ,
              PurchasingProfit = CASE CurrencyTypeIs
                                   WHEN 0 THEN @ProfitD
                                   WHEN 1 THEN @ProfitD * @ExchangeRateLL
                                   ELSE @ProfitD * @ExchangeRateEuro
                                 END ,
              PurchasingLast = [Invoices].f_PurchasingGetLastDateByAccountVendorID(ID)
      WHERE   ID = @VendorID;

      UPDATE  Company.t_Account
      SET     PurchasingTotalF = Currencys.f_Format(CurrencyID, PurchasingTotal) ,
              PurchasingProfitF = Currencys.f_Format(CurrencyID, PurchasingProfit)
      WHERE   ID = @VendorID;

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @return;

  END CATCH;

END;





GO
