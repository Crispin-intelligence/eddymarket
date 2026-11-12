SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldInsert]
  @RefPaper NVARCHAR(MAX) ,
  @RefPurchaseOrder NVARCHAR(MAX) ,
  @SaveFrom TINYINT ,
  @QuotationID UNIQUEIDENTIFIER ,
  @QuotationRef NVARCHAR(MAX) ,
  @InvoiceTitleID UNIQUEIDENTIFIER ,
  @DateIs DATETIME ,
  @SalespersonID UNIQUEIDENTIFIER ,
  @CommissionRate DECIMAL(18, 2) ,
  @CommissionRateType TINYINT ,
  @CommissionRateOn TINYINT ,
  @CustomerID UNIQUEIDENTIFIER ,
  @AccountTaxID UNIQUEIDENTIFIER ,
  @AccountIDSellNonTaxable UNIQUEIDENTIFIER ,
  @AccountIDSellTaxable UNIQUEIDENTIFIER ,
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
  @WFPFrom BIT ,
  @FrameJobOrderID UNIQUEIDENTIFIER ,
  @FrameJobOrderRefF NVARCHAR(MAX) ,
  @FrameJobOrderEvent NVARCHAR(MAX) ,
  @DetailIs Invoices.tt_SoldDetail READONLY ,
  @SerialIs Items.tt_ItemSerial READONLY ,
  @ItemExpirationDate Items.tt_ItemExpirationDateSold READONLY ,
  @ProductionWhenSale BIT ,
  @SoldDetailProfitPartner Invoices.tt_SoldDetailProfitPartner READONLY ,
  @StatementIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventInsert NVARCHAR(MAX) ,
  @EventInsertBySold NVARCHAR(MAX) ,
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

      DECLARE @SoldProfitPartner AS TABLE
        (
          ProfitPartnerID UNIQUEIDENTIFIER NOT NULL ,
          Profit FLOAT NOT NULL ,
          ProfitD FLOAT NOT NULL ,
          ProfitLL FLOAT NOT NULL ,
          ProfitEuro FLOAT NOT NULL
        );

      DECLARE @Ref BIGINT ,
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @RowNumber INT ,
        @Customer NVARCHAR(MAX) ,
        @AccountSalespersonID UNIQUEIDENTIFIER ,
        @AccountSalespersonSellID UNIQUEIDENTIFIER ,
        @Box NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @WFPShopID NVARCHAR(MAX) ,
        @WFPBranchID NVARCHAR(MAX) ,
        @CommissionAvailableValue FLOAT ,
        @LinkType TINYINT = 2 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @StatementIs_ NVARCHAR(MAX) ,
        @NetD FLOAT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT  @Ref = ISNULL(MAX(s.Ref), 0) + 1
      FROM    Invoices.t_Sold AS s;

      SET @Customer = Company.f_AccountGetName(@CustomerID);
      SET @AccountSalespersonID = [Company].[f_AccountSalespersonGetID](@SalespersonID);
      SET @AccountSalespersonSellID = [Company].[f_AccountSalespersonSellGetID](@SalespersonID);
      SET @Box = Company.f_AccountGetName(@BoxID);

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
      SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);
      IF @CurrencyTypeIs <> 0
      BEGIN
	                              
        SET @TaxExchangeRateLL = @ExchangeRateLL;
        SET @TaxExchangeRateEuro = @ExchangeRateEuro;

      END;
		
      SELECT TOP ( 1 )
              @WFPShopID = s.ShopID ,
              @WFPBranchID = s.BranchID
      FROM    Options.t_WorldFoodProgramme AS s
      ORDER BY s.ID;

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

      INSERT  INTO Invoices.t_Sold
              ( ID ,
                Ref ,
                RefF ,
                RefPaper ,
                RefPurchaseOrder ,
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
                SalespersonID ,
                Salesperson ,
                CommissionRate ,
                CommissionRateF ,
                CommissionRateType ,
                CommissionRateOn ,
                StatusPayment ,
                CommissionValue ,
                SalespersonTakeCommission ,
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
                DiscountIs ,
                TaxValue ,
                NetIs ,
                Profit ,
                Cost ,
                Qtys ,
                DescriptionIs ,
                WFPFrom ,
                WFPShopID ,
                WFPBranchID ,
                WFPReported ,
                FrameJobOrderID ,
                FrameJobOrderRefF ,
                FirstPayment
              )
      VALUES  ( @ID ,
                @Ref ,
                FORMAT(@Ref, 'n0') ,
                @RefPaper ,
                @RefPurchaseOrder ,
                @SaveFrom ,
                @QuotationID ,
                @QuotationRef ,
                @InvoiceTitleID ,
                Invoices.f_InvoiceTitleGetName(@InvoiceTitleID) ,
                @DateIs ,
                @DateIs ,
                @DateIs ,
                DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
                DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
                @SalespersonID ,
                Employees.f_SalesPersonGetName(@SalespersonID) ,
                @CommissionRate ,
                FORMAT(@CommissionRate, '0.##') + N' %' ,
                @CommissionRateType ,
                @CommissionRateOn ,
                IIF(@Payment = @Net, 1, 0) ,
                CASE @CommissionRateOn
                  WHEN 0 THEN IIF(@Net > 0, @Net / 100, 0)
                  WHEN 1 THEN IIF(@Profit > 0, @Profit / 100, 0)
                  ELSE IIF(( @Net - @Tax ) > 0, ( @Net - @Tax ) / 100, 0)
                END * @CommissionRate ,
                0 ,
                @UserID ,
                Users.f_UserGetName(@UserID) ,
                @CustomerID ,
                Company.f_AccountGetName(@CustomerID) ,
                Company.f_AccountGetNumberF(@CustomerID) ,
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
                ( SELECT  COALESCE(SUM(s.Cost * s.Qty), 0)
                  FROM    @DetailIs AS s
                ) ,
                ( SELECT  COALESCE(SUM(s.Qtys), 0)
                  FROM    @DetailIs AS s
                ) ,
                @DescriptionIs ,
                @WFPFrom ,
                IIF(@WFPFrom = 1, @WFPShopID, '') ,
                IIF(@WFPFrom = 1, @WFPBranchID, '') ,
                0 ,
                @FrameJobOrderID ,
                @FrameJobOrderRefF ,
                @Payment
              );

    END;

    BEGIN --Insert detail

      INSERT  INTO Invoices.t_SoldDetail
              ( ID ,
                SoldID ,
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
                RefPurchaseOrder ,
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
              s.Qtys ,
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
              s.Cost ,
              Currencys.f_Format(@CurrencyID, s.Cost) ,
              s.Cost / @ExchangeRate ,
              ( s.Cost / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.Cost / @ExchangeRate ) * @ExchangeRateEuro ,
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
              s.RefPurchaseOrder ,
              s.DescriptionIs ,
              s.SortAt
      FROM    @DetailIs AS s
      LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
      LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID;

    END;

    BEGIN --Insert detial serial

      INSERT  INTO Invoices.t_SoldDetailSerial
              ( SoldID ,
                SoldDetailID ,
                SerialID
              )
      SELECT  @ID ,
              s.FatherID ,
              s.ID
      FROM    @SerialIs AS s;

    END;

    BEGIN --Update item serial

      UPDATE  Items.t_ItemSerial
      SET     IsAvailable = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @SerialIs AS s
                       WHERE  s.ID = t_ItemSerial.ID );

    END;

    BEGIN --Insert t_SoldDetailProfitPartner

      INSERT  INTO Invoices.t_SoldDetailProfitPartner
              ( ID ,
                SoldID ,
                SoldDetailID ,
                ProfitPartnerID ,
                ProfitPartner ,
                ProfitRatio ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  s.ID ,
              @ID ,
              s.SoldDetailID ,
              s.ProfitPartnerID ,
              s1.Name ,
              s.ProfitRatio ,
              s.Profit ,
              Currencys.f_Format(@CurrencyID, s.Profit) ,
              s.Profit / @ExchangeRate ,
              ( s.Profit / @ExchangeRate ) * @ExchangeRateLL ,
              ( s.Profit / @ExchangeRate ) * @ExchangeRateEuro
      FROM    @SoldDetailProfitPartner AS s
      LEFT JOIN Items.t_ProfitPartner AS s1 ON s1.ID = s.ProfitPartnerID;

      UPDATE  Invoices.t_SoldDetailProfitPartner
      SET     SearchText = ''
      WHERE   SoldID = @ID;

    END;
  
    BEGIN --Insert t_SoldProfitPartner
		
      INSERT  INTO @SoldProfitPartner
              ( ProfitPartnerID ,
                Profit ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
	          )
      SELECT  s.ProfitPartnerID ,
              ISNULL(SUM(s.Profit), 0) ,
              ISNULL(SUM(s.ProfitD), 0) ,
              ISNULL(SUM(s.ProfitLL), 0) ,
              ISNULL(SUM(s.ProfitEuro), 0)
      FROM    Invoices.t_SoldDetailProfitPartner AS s
      WHERE   s.SoldID = @ID
      GROUP BY s.ProfitPartnerID;

      INSERT  INTO Invoices.t_SoldProfitPartner
              ( SoldID ,
                ProfitPartnerID ,
                ProfitPartner ,
                ProfitRatio ,
                Profit ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  @ID ,
              s.ProfitPartnerID ,
              s1.Name ,
              IIF(@Profit = 0, 0, s.Profit / @Profit * 100.0) ,
              s.Profit ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro
      FROM    @SoldProfitPartner AS s
      LEFT JOIN Items.t_ProfitPartner AS s1 ON s1.ID = s.ProfitPartnerID;

      UPDATE  Invoices.t_SoldProfitPartner
      SET     ProfitF = Currencys.f_Format(@CurrencyID, Profit)
      WHERE   SoldID = @ID;

    END;
	  
    BEGIN --Update t_ProfitPartner
		
      UPDATE  Items.t_ProfitPartner
      SET     SalesInvoicesCount += 1 ,
              TotalProfitD += ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                FROM    @SoldProfitPartner AS s
                                WHERE   ( s.ProfitPartnerID = t_ProfitPartner.ID )
                              ) ,
              TotalProfitLL += ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                 FROM   @SoldProfitPartner AS s
                                 WHERE  ( s.ProfitPartnerID = t_ProfitPartner.ID )
                               ) ,
              TotalProfitEuro += ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                   FROM   @SoldProfitPartner AS s
                                   WHERE  ( s.ProfitPartnerID = t_ProfitPartner.ID )
                                 )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ProfitPartnerID
                       FROM   @SoldProfitPartner AS s
                       WHERE  s.ProfitPartnerID = t_ProfitPartner.ID );

      UPDATE  Items.t_ProfitPartner
      SET     SearchText = ''
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ProfitPartnerID
                       FROM   @SoldProfitPartner AS s
                       WHERE  s.ProfitPartnerID = t_ProfitPartner.ID );

    END;

    BEGIN --Rebuild statistics

      UPDATE  Invoices.t_Sold
      SET     CommissionValueF = Currencys.f_Format(CurrencyID, CommissionValue) ,
              CommissionValueD = CommissionValue / ExchangeRate ,
              CommissionValueLL = ( CommissionValue / ExchangeRate ) * @ExchangeRateLL ,
              CommissionValueEuro = ( CommissionValue / ExchangeRate ) * @ExchangeRateEuro ,
              CommissionAvailableValue = IIF(SalespersonTakeCommission = 1, 0, IIF(CommissionRateType = 0, CommissionValue, IIF(StatusPayment = 0, 0, CommissionValue))) ,
              TotalF = Currencys.f_Format(CurrencyID, Total) ,
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
              CostF = Currencys.f_Format(CurrencyID, Cost) ,
              CostD = Cost / ExchangeRate ,
              CostLL = ( Cost / ExchangeRate ) * @ExchangeRateLL ,
              CostEuro = ( Cost / ExchangeRate ) * @ExchangeRateEuro ,
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

      UPDATE  Invoices.t_Sold
      SET     CommissionAvailableValueF = Currencys.f_Format(@CurrencyID, CommissionAvailableValue) ,
              CommissionAvailableValueD = CommissionAvailableValue / @ExchangeRate ,
              CommissionAvailableValueLL = ( CommissionAvailableValue / @ExchangeRate ) * @ExchangeRateLL ,
              CommissionAvailableValueEuro = ( CommissionAvailableValue / @ExchangeRate ) * @ExchangeRateEuro
      WHERE   ID = @ID;

      UPDATE  Invoices.t_Sold
      SET     TaxRate = ( TaxValue / ( NetIs - TaxValue ) ) * 100.0 ,
              TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
      WHERE   ID = @ID
              AND NetIs > 0;

      UPDATE  Invoices.t_Sold
      SET     SearchText = Invoices.f_SoldSearchTextGet(ID)
      WHERE   ID = @ID;
    
	  UPDATE  Invoices.t_SoldDetail
      SET     SearchText = Invoices.f_SoldDetailSearchTextGet(ID)
      WHERE   SoldID = @ID;

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
               t.QtyCurrent -= s.Qty;

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
               t.QtyCurrent -= s.Qty ,
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
               t.SellTotalWithTaxEuro = t.SellWithTaxEuro * ( t.QtyCurrent - s.Qty ) ,
               t.StatusIs = 0 ,
               t.DateLastSale = @DateIs ,
               t.DaysLastSale = 0;

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
        AND t.AccountID = @CustomerID
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
                 DiscountIsF ,
                 SectionIs
               )
        VALUES ( @CustomerID ,
                 s.ItemSharedID ,
                 s.ItemUnityID ,
                 Items.f_UnityItemGetName(s.ItemUnityID) ,
                 @CurrencyID ,
                 @Currency ,
                 s.Price ,
                 Currencys.f_Format(@CurrencyID, s.Price) ,
                 s.Price / @ExchangeRate ,
                 s.DiscountIs ,
                 FORMAT(s.DiscountIs, '0.##') + ' %' ,
                 2
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

		--Fix t_ItemExpirationDate
    IF EXISTS ( SELECT TOP ( 1 )
                        s.ID
                FROM    @ItemExpirationDate AS s )
    BEGIN
    
      BEGIN --DECLARE
	  
        DECLARE @ItemExpirationDateSum AS Items.tt_ItemExpirationDateSold;
        DECLARE @ItemExpirationDateDelete AS TABLE
          (
            ID UNIQUEIDENTIFIER NOT NULL ,
            ItemSharedID UNIQUEIDENTIFIER NOT NULL ,
            Barcode NVARCHAR(450) NOT NULL
          ); 
	    
      END;

      BEGIN --Set Info
	  
        INSERT  INTO @ItemExpirationDateSum
                ( ID ,
                  Qtys
                )
        SELECT  s.ID ,
                COALESCE(SUM(s.Qtys), 0)
        FROM    @ItemExpirationDate AS s
        GROUP BY s.ID;

      END;

      BEGIN --Update
    
        MERGE Items.t_ItemExpirationDate AS t
        USING @ItemExpirationDateSum AS s
        ON s.ID = t.ID
        WHEN MATCHED THEN
          UPDATE SET t.Qtys -= s.Qtys;

      END;

      BEGIN --Delete Empty Qtys
    
        DELETE  FROM Items.t_ItemExpirationDate
        OUTPUT  Deleted.ID ,
                Deleted.ItemSharedID ,
                Deleted.Barcode
                INTO @ItemExpirationDateDelete
        WHERE   Qtys < 1;

        DELETE  FROM @ItemExpirationDateDelete
        WHERE   Barcode = N'';

      END;

      BEGIN --Delete t_ItemSharedBarCode

        SET @return = -3;

        DELETE  FROM Items.t_ItemSharedBarCode
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @ItemExpirationDateDelete AS s
                         WHERE  s.ItemSharedID = t_ItemSharedBarCode.SharedID
                                AND t_ItemSharedBarCode.TypeIs = 3
                                AND s.Barcode = t_ItemSharedBarCode.BarCode );
	
        BEGIN --Fix t_ItemShared

          UPDATE  Items.t_ItemShared
          SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                             FROM   Items.t_ItemSharedBarCode AS t
                                             WHERE  t.SharedID = t_ItemShared.ID
                                           FOR
                                             XML PATH('')
                                           ))
          WHERE   EXISTS ( SELECT TOP ( 1 )
                                  s.ID
                           FROM   @ItemExpirationDateDelete AS s
                           WHERE  s.ItemSharedID = t_ItemShared.ID );

        END;

      END;

    END;

    BEGIN --Insert event

      SET @return = -1;

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
                @Event + CONVERT(NVARCHAR(MAX), @Ref) ,
                @EventType ,
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
                  REPLACE(@StatementIs, N'{0}', @Ref) ,
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
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref);
        EXECUTE Transactions.s_TransactionDetailInsertDebitTax @RowNumber, @TransactionID, @CustomerID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @Tax,
          @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

      END;

      IF @NetNonTaxable > 0
      BEGIN --Insert detail 
	   
        SET @V = @NetNonTaxable;
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Customer;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @RowNumber, @TransactionID, @AccountIDSellNonTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro,
          @StatementIs_;
										
      END;

      IF @Tax > 0
      BEGIN --Insert detail tax

        SET @V = @NetTaxableWithoutTax;
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Customer;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @RowNumber, @TransactionID, @AccountIDSellTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro,
          @StatementIs_;

        SET @V = @Tax;
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref);
        EXECUTE Transactions.s_TransactionDetailInsertCredit @RowNumber, @TransactionID, @AccountTaxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL,
          @TaxExchangeRateEuro, @StatementIs_;
					
      END;

    END;

    IF @Payment > 0
    BEGIN --Transaction

      BEGIN --Set info

        SELECT  @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'RV';

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
                  N'RV' ,
                  @DateIs ,
                  REPLACE(@StatementIs, N'{0}', @Ref) ,
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
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Customer;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @CustomerID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

        END;
        ELSE
        BEGIN
		 
          SET @V = @Payment - @Tax;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Customer;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @CustomerID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @V = @Payment - @V;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Customer + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL,
                                                                                                                                       N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertDebit 3, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro,
            @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL,
                                                                                                                                  N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertCredit 4, @TransactionID, @CustomerID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro,
            @StatementIs_;

        END;

      END;

    END;
  
    BEGIN --Get CommissionValue
    
      SELECT TOP ( 1 )
              @CommissionAvailableValue = t.CommissionAvailableValue
      FROM    Invoices.t_Sold AS t
      WHERE   t.ID = @ID;

    END;

    IF @CommissionAvailableValue > 0
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
                  LinkTypeSub ,
                  LinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TransactionRef ,
                  N'JV' ,
                  @DateIs ,
                  REPLACE(@StatementIs, N'{0}', @Ref) ,
                  @LinkType ,
                  7 ,
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

        SET @V = @CommissionAvailableValue;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + N' (' + Currencys.f_Format(@CID, @Net) + N' | ' + Currencys.f_FormatRate(@CommissionRate)
          + N' ' + Currencys.f_Format(@CID, @V) + N' EX: ' + FORMAT(@ExchangeRateLL, N'#,##0.##') + ') \ ' + @Customer;
        EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @AccountSalespersonSellID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @AccountSalespersonID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

      END;
	         
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
              @Event + s.RefF ,
              @EventType ,
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
      SET     SoldC += 1 ,
              SoldTotal = CASE CurrencyTypeIs
                            WHEN 0 THEN @NetD
                            WHEN 1 THEN @NetD * @ExchangeRateLL
                            ELSE @NetD * @ExchangeRateEuro
                          END ,
              SoldProfit = CASE CurrencyTypeIs
                             WHEN 0 THEN @ProfitD
                             WHEN 1 THEN @ProfitD * @ExchangeRateLL
                             ELSE @ProfitD * @ExchangeRateEuro
                           END ,
              SoldLast = [Invoices].f_SoldGetLastDateByAccountCustomerID(ID)
      WHERE   ID = @CustomerID;

      UPDATE  Company.t_Account
      SET     SoldTotalF = Currencys.f_Format(CurrencyID, SoldTotal) ,
              SoldProfitF = Currencys.f_Format(CurrencyID, SoldProfit)
      WHERE   ID = @CustomerID;

    END;

		--Close FrameJobOrder
    IF @FrameJobOrderID <> '00000000-0000-0000-0000-000000000000'
    BEGIN
    
      BEGIN --Insert t_FrameJobOrderHistory

        SET @return = -169;

        INSERT  INTO Customers.t_FrameJobOrderHistory
                ( ID ,
                  Ref ,
                  RefF ,
                  RefPaper ,
                  DateIs ,
                  DateDelivery ,
                  DateInProcess ,
                  DateInProcessNotification ,
                  DateReady ,
                  DateReadyNotification ,
                  StatusIs ,
                  PriorityLevel ,
                  CustomerID ,
                  Customer ,
                  DoctorID ,
                  Doctor ,
                  SalespersonID ,
                  Salesperson ,
                  StatesID ,
                  StatesIs ,
                  RegionID ,
                  RegionIs ,
                  StreetID ,
                  Street ,
                  AddressIs ,
                  Focal ,
                  WithRight ,
                  WithLeft ,
                  SphereRight ,
                  SphereLeft ,
                  CylinderRight ,
                  CylinderLeft ,
                  AxisRight ,
                  AxisLeft ,
                  PrismRight ,
                  PrismLeft ,
                  BaseRight ,
                  BaseLeft ,
                  Addition ,
                  HeightRight ,
                  HeightLeft ,
                  PDRight ,
                  PDLeft ,
                  PD ,
                  CurrencyID ,
                  Currency ,
                  ExchangeRate ,
                  ExchangeRateLL ,
                  ExchangeRateEuro ,
                  SubTotal ,
                  SubTotalF ,
                  SubTotalD ,
                  SubTotalLL ,
                  SubTotalEuro ,
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
                  Qtys ,
                  DescriptionIs ,
                  WhyCanceled ,
                  SoldID ,
                  SoldRefF ,
                  ItemsNames ,
                  DateCreate ,
                  IsSync ,
                  WorkStationID
                )
        SELECT  t.ID ,
                t.Ref ,
                t.RefF ,
                t.RefPaper ,
                t.DateIs ,
                t.DateDelivery ,
                t.DateInProcess ,
                t.DateInProcessNotification ,
                t.DateReady ,
                t.DateReadyNotification ,
                3 ,
                t.PriorityLevel ,
                t.CustomerID ,
                t.Customer ,
                t.DoctorID ,
                t.Doctor ,
                t.SalespersonID ,
                t.Salesperson ,
                t.StatesID ,
                t.StatesIs ,
                t.RegionID ,
                t.RegionIs ,
                t.StreetID ,
                t.Street ,
                t.AddressIs ,
                t.Focal ,
                t.WithRight ,
                t.WithLeft ,
                t.SphereRight ,
                t.SphereLeft ,
                t.CylinderRight ,
                t.CylinderLeft ,
                t.AxisRight ,
                t.AxisLeft ,
                t.PrismRight ,
                t.PrismLeft ,
                t.BaseRight ,
                t.BaseLeft ,
                t.Addition ,
                t.HeightRight ,
                t.HeightLeft ,
                t.PDRight ,
                t.PDLeft ,
                t.PD ,
                t.CurrencyID ,
                t.Currency ,
                t.ExchangeRate ,
                t.ExchangeRateLL ,
                t.ExchangeRateEuro ,
                t.SubTotal ,
                t.SubTotalF ,
                t.SubTotalD ,
                t.SubTotalLL ,
                t.SubTotalEuro ,
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
                t.Qtys ,
                t.DescriptionIs ,
                N'' ,
                @ID ,
                FORMAT(@Ref, 'n0') ,
                t.ItemsNames ,
                t.DateCreate ,
                0 ,
                t.WorkStationID
        FROM    Customers.t_FrameJobOrder AS t
        WHERE   t.ID = @FrameJobOrderID;

        INSERT  Customers.t_FrameJobOrderHistoryDetail
                ( ID ,
                  FrameJobOrderHistoryID ,
                  ItemSharedID ,
                  ItemID ,
                  ItemUnityID ,
                  Qty ,
                  QtyWithUnity ,
                  Qtys ,
                  ItemType ,
                  Sale ,
                  SaleF ,
                  SaleD ,
                  SaleLL ,
                  SaleEuro ,
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
                  DiscountOrder ,
                  DiscountOrderF ,
                  DiscountOrderD ,
                  DiscountOrderLL ,
                  DiscountOrderEuro ,
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
                  TotalCost ,
                  TotalCostF ,
                  TotalCostD ,
                  TotalCostLL ,
                  TotalCostEuro ,
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
                t.FrameJobOrderID ,
                t.ItemSharedID ,
                t.ItemID ,
                t.ItemUnityID ,
                t.Qty ,
                t.QtyWithUnity ,
                t.Qtys ,
                t.ItemType ,
                t.Sale ,
                t.SaleF ,
                t.SaleD ,
                t.SaleLL ,
                t.SaleEuro ,
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
                t.DiscountOrder ,
                t.DiscountOrderF ,
                t.DiscountOrderD ,
                t.DiscountOrderLL ,
                t.DiscountOrderEuro ,
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
                t.TotalCost ,
                t.TotalCostF ,
                t.TotalCostD ,
                t.TotalCostLL ,
                t.TotalCostEuro ,
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
                0 ,
                t.WorkStationID
        FROM    Customers.t_FrameJobOrderDetail AS t
        WHERE   t.FrameJobOrderID = @FrameJobOrderID;

      END;

      BEGIN --Delete

        DELETE  FROM Customers.t_FrameJobOrderDetail
        WHERE   FrameJobOrderID = @FrameJobOrderID;

        DELETE  FROM Customers.t_FrameJobOrder
        WHERE   ID = @FrameJobOrderID;

      END;

      BEGIN --Insert event

        INSERT  INTO Customers.t_FrameJobOrderMoving
                ( UserID ,
                  SectionID ,
                  EventIs ,
                  EventType ,
                  ComputerIP ,
                  Computer ,
                  ComputerAccount
                )
        VALUES  ( @UserID ,
                  @FrameJobOrderID ,
                  REPLACE(@FrameJobOrderEvent, N'{0}', @Ref) ,
                  IIF(@EventType = 0, 2, 11) ,
                  @ComputerIP ,
                  @Computer ,
                  @ComputerAccount
                );

      END;

    END;
	
    EXECUTE [Items].[s_ItemProductionInsertBySold] @ProductionWhenSale, @ID, @Ref, @DateIs, @CurrencyID, @Currency, @CurrencyTypeIs, @ExchangeRate,
      @ExchangeRateLL, @ExchangeRateEuro, @DetailIs, @UserID, @EventInsert, @EventInsertBySold, @ComputerIP, @Computer, @ComputerAccount; 

    IF @SaveFrom = 1
    BEGIN

      UPDATE  Quotations.t_Quotation
      SET     SaveFrom = 1 ,
              SoldID = @ID ,
              SoldRefF = FORMAT(@Ref, 'n0')
      WHERE   ID = @QuotationID;

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
