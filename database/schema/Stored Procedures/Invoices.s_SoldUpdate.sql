SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldUpdate]
  @RefPaper NVARCHAR(MAX) ,
  @RefPurchaseOrder NVARCHAR(MAX) ,
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
  @WFPFrom BIT ,
  @DetailIs Invoices.tt_SoldDetail READONLY ,
  @SerialIs Items.tt_ItemSerial READONLY ,
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
        @TransactionRefJV BIGINT ,
        @TransactionRefJVSalesperson BIGINT ,
        @TransactionRefRV BIGINT ,
        @RowNumber INT ,
        @CustomerIDOld UNIQUEIDENTIFIER ,
        @Customer NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @AccountSalespersonID UNIQUEIDENTIFIER ,
        @AccountSalespersonSellID UNIQUEIDENTIFIER ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @WFPShopID NVARCHAR(MAX) ,
        @WFPBranchID NVARCHAR(MAX) ,
        @CommissionAvailableValue FLOAT ,
        @return INT ,
        @LinkType TINYINT = 2 ,
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

      SELECT TOP ( 1 )
              @TransactionRefJV = s.Ref
      FROM    Transactions.t_Transaction AS s
      WHERE   s.LinkType = @LinkType
              AND s.LinkID = @ID
              AND s.TypeIs = N'JV'
              AND s.LinkTypeSub = 0
      ORDER BY s.ID;
	 
      SELECT TOP ( 1 )
              @TransactionRefRV = s.Ref
      FROM    Transactions.t_Transaction AS s
      WHERE   s.LinkType = @LinkType
              AND s.LinkID = @ID
              AND s.TypeIs = N'RV'
              AND s.LinkTypeSub = 0
      ORDER BY s.ID;

      SELECT TOP ( 1 )
              @TransactionRefJVSalesperson = s.Ref
      FROM    Transactions.t_Transaction AS s
      WHERE   s.LinkType = @LinkType
              AND s.LinkID = @ID
              AND s.TypeIs = N'JV'
              AND s.LinkTypeSub = 7
      ORDER BY s.ID;

      SET @Customer = Company.f_AccountGetName(@CustomerID);
      SET @Box = Company.f_AccountGetName(@BoxID);

      SET @AccountSalespersonID = [Company].[f_AccountSalespersonGetID](@SalespersonID);
      SET @AccountSalespersonSellID = [Company].[f_AccountSalespersonSellGetID](@SalespersonID);

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
      SET @CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(@CurrencyID);
      IF @CurrencyTypeIs <> 0
      BEGIN

        SET @TaxExchangeRateLL = @ExchangeRateLL;
        SET @TaxExchangeRateEuro = @ExchangeRateEuro;

      END;
	  			
      INSERT  INTO @ItemQtyOld
              ( ID ,
                SharedID ,
                Qty
              )
      SELECT  s.ItemID ,
              s.ItemSharedID ,
              s.Qtys
      FROM    Invoices.t_SoldDetail AS s
      WHERE   s.SoldID = @ID;

      SELECT TOP ( 1 )
              @Ref = s.Ref ,
              @CustomerIDOld = s.AccountCustomerID
      FROM    Invoices.t_Sold AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      SELECT  @Profit = COALESCE(SUM(s.ProfitTotal), 0)
      FROM    @DetailIs AS s;
      SET @ProfitD = @Profit / @ExchangeRate;

      SELECT TOP ( 1 )
              @WFPShopID = s.ShopID ,
              @WFPBranchID = s.BranchID
      FROM    Options.t_WorldFoodProgramme AS s
      ORDER BY s.ID;

      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;

    END;

    BEGIN --Update

      SET @return = 0;

      UPDATE  Invoices.t_Sold
      SET     RefPaper = @RefPaper ,
              RefPurchaseOrder = @RefPurchaseOrder ,
              InvoiceTitleID = @InvoiceTitleID ,
              InvoiceTitle = Invoices.f_InvoiceTitleGetName(@InvoiceTitleID) ,
              DateIs = @DateIs ,
              DateOnly = @DateIs ,
              TimeOnly = @DateIs ,
              DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
              DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
              SalespersonID = @SalespersonID ,
              Salesperson = Employees.f_SalesPersonGetName(@SalespersonID) ,
              CommissionRate = @CommissionRate ,
              CommissionRateF = FORMAT(@CommissionRate, '0.##') + N' %' ,
              CommissionRateType = @CommissionRateType ,
              CommissionRateOn = @CommissionRateOn ,
              StatusPayment = IIF(@Payment = @Net, 1, 0) ,
              CommissionValue = CASE @CommissionRateOn
                                  WHEN 0 THEN IIF(@Net > 0, @Net / 100, 0)
                                  WHEN 1 THEN IIF(@Profit > 0, @Profit / 100, 0)
                                  ELSE IIF(( @Net - @Tax ) > 0, ( @Net - @Tax ) / 100, 0)
                                END * @CommissionRate ,
              AccountCustomerID = @CustomerID ,
              AccountCustomer = Company.f_AccountGetName(@CustomerID) ,
              AccountCustomerNumber = Company.f_AccountGetNumberF(@CustomerID) ,
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
              Total = ( SELECT  COALESCE(SUM(s.SubTotal), 0)
                        FROM    @DetailIs AS s
                      ) ,
              DiscountIs = @DiscountIs ,
              TaxValue = @Tax ,
              NetIs = ( SELECT  COALESCE(SUM(s.Total), 0)
                        FROM    @DetailIs AS s
                      ) ,
              Profit = @Profit ,
              Cost = ( SELECT COALESCE(SUM(s.Cost * s.Qty), 0)
                       FROM   @DetailIs AS s
                     ) ,
              Qtys = ( SELECT COALESCE(SUM(s.Qtys), 0)
                       FROM   @DetailIs AS s
                     ) ,
              DescriptionIs = @DescriptionIs ,
              WFPFrom = @WFPFrom ,
              WFPShopID = IIF(@WFPFrom = 1, @WFPShopID, '') ,
              WFPBranchID = IIF(@WFPFrom = 1, @WFPBranchID, '') ,
              WFPReported = 0 ,
              FirstPayment = @Payment
      WHERE   ID = @ID;

    END;
	
    BEGIN --Update t_ProfitPartner
		
      UPDATE  Items.t_ProfitPartner
      SET     SalesInvoicesCount -= 1 ,
              TotalProfitD -= ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                FROM    Invoices.t_SoldDetailProfitPartner AS s
                                WHERE   s.SoldID = @ID
                                        AND s.ProfitPartnerID = t_ProfitPartner.ID
                              ) ,
              TotalProfitLL -= ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                 FROM   Invoices.t_SoldDetailProfitPartner AS s
                                 WHERE  s.SoldID = @ID
                                        AND s.ProfitPartnerID = t_ProfitPartner.ID
                               ) ,
              TotalProfitEuro -= ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                   FROM   Invoices.t_SoldDetailProfitPartner AS s
                                   WHERE  s.SoldID = @ID
                                          AND s.ProfitPartnerID = t_ProfitPartner.ID
                                 )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ProfitPartnerID
                       FROM   Invoices.t_SoldDetailProfitPartner AS s
                       WHERE  s.SoldID = @ID
                              AND s.ProfitPartnerID = t_ProfitPartner.ID );

    END;

    BEGIN --Insert t_SoldDetailProfitPartner

      MERGE Invoices.t_SoldDetailProfitPartner AS t
      USING @SoldDetailProfitPartner AS s
      ON s.ID = t.ID
      WHEN MATCHED THEN
        UPDATE SET
               t.ProfitRatio = s.ProfitRatio ,
               t.Profit = s.Profit ,
               t.ProfitF = Currencys.f_Format(@CurrencyID, s.Profit) ,
               t.ProfitD = s.Profit / @ExchangeRate ,
               t.ProfitLL = ( s.Profit / @ExchangeRate ) * @ExchangeRateLL ,
               t.ProfitEuro = ( s.Profit / @ExchangeRate ) * @ExchangeRateEuro
      WHEN NOT MATCHED BY SOURCE AND t.SoldID = @ID THEN
        DELETE;

    END;

    BEGIN --Insert detail

      MERGE Invoices.t_SoldDetail AS t
      USING @DetailIs AS s
      ON s.ID = t.ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
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
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.ItemID = s.ItemID ,
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
               t.SubTotalEuro = ( s.SubTotal / @ExchangeRate ) * @ExchangeRateLL ,
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
               t.Cost = s.Cost ,
               t.CostF = Currencys.f_Format(@CurrencyID, s.Cost) ,
               t.CostD = s.Cost / @ExchangeRate ,
               t.CostLL = ( s.Cost / @ExchangeRate ) * @ExchangeRateLL ,
               t.CostEuro = ( s.Cost / @ExchangeRate ) * @ExchangeRateEuro ,
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
               t.RefPurchaseOrder = s.RefPurchaseOrder ,
               t.DescriptionIs = s.DescriptionIs ,
               t.SortAt = s.SortAt
      WHEN NOT MATCHED BY SOURCE AND t.SoldID = @ID THEN
        DELETE;

      INSERT  INTO @Item
              ( ID ,
                SharedID ,
                Qty
              )
      SELECT  s.ItemID ,
              s.ItemSharedID ,
              s.Qtys
      FROM    Invoices.t_SoldDetail AS s
      WHERE   s.SoldID = @ID;

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

      MERGE Invoices.t_SoldDetailProfitPartner AS t
      USING @SoldDetailProfitPartner AS s
      ON s.ID = t.ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
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
        VALUES ( s.ID ,
                 @ID ,
                 s.SoldDetailID ,
                 s.ProfitPartnerID ,
                 Items.f_ProfitPartnerGetName(s.ProfitPartnerID) ,
                 s.ProfitRatio ,
                 s.Profit ,
                 Currencys.f_Format(@CurrencyID, s.Profit) ,
                 s.Profit / @ExchangeRate ,
                 ( s.Profit / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.Profit / @ExchangeRate ) * @ExchangeRateEuro
			   );

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

      DELETE  FROM Invoices.t_SoldProfitPartner
      WHERE   SoldID = @ID;

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
      SELECT  o.ID ,
              COALESCE(SUM(o.Qty), 0)
      FROM    ( SELECT  s.ID ,
                        COALESCE(SUM(s.Qty), 0) AS Qty
                FROM    @ItemQtyOld AS s
                GROUP BY s.ID
                UNION ALL
                SELECT  s.ID ,
                        0 - COALESCE(SUM(s.Qty), 0)
                FROM    @Item AS s
                GROUP BY s.ID
              ) AS o
      GROUP BY o.ID;

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
      SELECT  o.SharedID ,
              COALESCE(SUM(o.Qty), 0)
      FROM    ( SELECT  s.SharedID ,
                        COALESCE(SUM(s.Qty), 0) AS Qty
                FROM    @ItemQtyOld AS s
                GROUP BY s.SharedID
                UNION ALL
                SELECT  s.SharedID ,
                        0 - COALESCE(SUM(s.Qty), 0)
                FROM    @Item AS s
                GROUP BY s.SharedID
              ) AS o
      GROUP BY o.SharedID;

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
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Delete old transaction

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = @LinkType
              AND LinkID = @ID
              AND TypeIs = N'JV';
		
    END;	

    IF @Net > 0
    BEGIN --Transaction
	
      SET @TransactionRef = @TransactionRefJV;
      IF @TransactionRef IS NULL
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

    IF @RebuildRV = 1
    BEGIN --Delete old transaction

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = @LinkType
              AND LinkID = @ID
              AND TypeIs = N'RV';
		
    END;	

    IF @RebuildRV = 1
      AND @Payment > 0
    BEGIN --Transaction
   
      SET @TransactionRef = @TransactionRefRV;
      IF @TransactionRef IS NULL
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
   
      SET @TransactionRef = @TransactionRefJVSalesperson;
      IF @TransactionRef IS NULL
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
              IIF(@EventType = 1, 0, 9) ,
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
      SET     SoldTotal = Invoices.f_SoldGetTotalByAccountCustomerID(ID) ,
              SoldProfit = Invoices.f_SoldGetProfitByAccountCustomerID(ID) ,
              SoldLast = Invoices.f_SoldGetLastDateByAccountCustomerID(ID)
      WHERE   ID = @CustomerID
              OR ID = @CustomerIDOld;

      UPDATE  Company.t_Account
      SET     SoldTotalF = Currencys.f_Format(CurrencyID, SoldTotal) ,
              SoldProfitF = Currencys.f_Format(CurrencyID, SoldProfit)
      WHERE   ID = @CustomerID
              OR ID = @CustomerIDOld;
		  
    END;

    BEGIN-- Delete t_ItemProduction

      BEGIN --Declare

        DECLARE @ItemQty AS TABLE
          (
            ID UNIQUEIDENTIFIER NOT NULL ,
            SharedID UNIQUEIDENTIFIER NOT NULL ,
            Qty DECIMAL(18, 4) NOT NULL
          );

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

        SET @return = 0;

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

    --IF @ProductionWhenSale = 1
    --BEGIN
                               
    --  BEGIN --Declare

    --    DECLARE @ItemProductionIDs TABLE
    --      (
    --        ID UNIQUEIDENTIFIER NOT NULL ,
    --        RefF NVARCHAR(MAX) NOT NULL
    --      );

    --    DECLARE @ItemDetailID UNIQUEIDENTIFIER ,
    --      @ItemProductionID UNIQUEIDENTIFIER ,
    --      @ItemProductionRef BIGINT ,
    --      @ItemProductionEmployeeID UNIQUEIDENTIFIER ,
    --      @ItemProductionEmployee NVARCHAR(MAX) ,
    --      @ItemProductionUser NVARCHAR(MAX) ,
    --      @ItemProductionItemSharedID UNIQUEIDENTIFIER ,
    --      @ItemProductionItemID UNIQUEIDENTIFIER ,
    --      @ItemProductionItemUnityID UNIQUEIDENTIFIER ,
    --      @ItemProductionQty DECIMAL(18, 4) ,
    --      @ItemProductionQtys DECIMAL(18, 4) ,
    --      @ItemProductionWarehouseID UNIQUEIDENTIFIER ,
    --      @ItemProductionCost FLOAT ,
    --      @ItemProductionCostD FLOAT ,
    --      @ItemProductionCostTotal FLOAT ,
    --      @ItemProductionCostTotalD FLOAT;

    --  END;

    --  BEGIN --Set info

    --    SELECT @ItemProductionEmployeeID = Employees.f_EmployeeGetFirstID();
    --    SELECT @ItemProductionEmployee = Employees.f_EmployeeGetName(@ItemProductionEmployeeID);
    --    SELECT @ItemProductionUser = Users.f_UserGetName(@UserID);
	  
    --  END;

    --  DECLARE i CURSOR FORWARD_ONLY
    --  FOR
    --  SELECT s.ID
    --    FROM @DetailIs AS s
    --    INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
    --    WHERE s1.IsSerial = 0;

    --  OPEN i;
    --  FETCH NEXT FROM i
    --INTO @ItemDetailID;
    --  WHILE @@FETCH_STATUS = 0
    --  BEGIN
	
    --    BEGIN --Set info

    --      SELECT @ItemProductionRef = ISNULL(MAX(s.Ref), 0) + 1
    --        FROM Items.t_ItemProduction AS s;
	  
    --      SELECT TOP ( 1 ) @ItemProductionItemSharedID = s.ItemSharedID ,
    --          @ItemProductionItemID = s.ItemID ,
    --          @ItemProductionItemUnityID = s.ItemUnityID ,
    --          @ItemProductionQty = s.Qty ,
    --          @ItemProductionQtys = s.Qtys ,
    --          @ItemProductionWarehouseID = s1.WareHouseID ,
    --          @ItemProductionCost = s.Cost
    --        FROM @DetailIs AS s
    --        INNER JOIN Items.t_Item AS s1 ON s1.ID = s.ItemID
    --        WHERE s.ID = @ItemDetailID;
		
    --      SET @ItemProductionCostD = @ItemProductionCost / @ExchangeRate;
    --      SET @ItemProductionCostTotal = @ItemProductionCost * @ItemProductionQty;
    --      SET @ItemProductionCostTotalD = @ItemProductionCostTotal / @ExchangeRate;

    --    END;

    --    BEGIN --Insert t_ItemProduction

    --      DELETE FROM @IDs;

    --      INSERT INTO Items.t_ItemProduction
    --          ( Ref ,
    --            SoldID ,
    --            SoldRef ,
    --            SoldDetailID ,
    --            DateIs ,
    --            EmployeeID ,
    --            Employee ,
    --            ItemSharedID ,
    --            ItemID ,
    --            ItemUnityID ,
    --            Qty ,
    --            Qtys ,
    --            WarehouseID ,
    --            CurrencyID ,
    --            Currency ,
    --            ExchangeRate ,
    --            ExchangeRateLL ,
    --            ExchangeRateEuro ,
    --            Cost ,
    --            CostD ,
    --            CostLL ,
    --            CostEuro ,
    --            TotalCost ,
    --            TotalCostD ,
    --            TotalCostLL ,
    --            TotalCostEuro ,
    --            CreateByID ,
    --            CreateBy ,
    --            HaveSerial
    --          )
    --        OUTPUT Inserted.ID
    --          INTO @IDs ( ID )
    --        VALUES
    --          ( @ItemProductionRef ,
    --            @ID ,
    --            @Ref ,
    --            @ItemDetailID ,
    --            @DateIs ,
    --            @ItemProductionEmployeeID ,
    --            @ItemProductionEmployee ,
    --            @ItemProductionItemSharedID ,
    --            @ItemProductionItemID ,
    --            @ItemProductionItemUnityID ,
    --            @ItemProductionQty ,
    --            @ItemProductionQtys ,
    --            @ItemProductionWarehouseID ,
    --            @CurrencyID ,
    --            @Currency ,
    --            @ExchangeRate ,
    --            @ExchangeRateLL ,
    --            @ExchangeRateEuro ,
    --            @ItemProductionCost ,
    --            @ItemProductionCostD ,
    --            @ItemProductionCostD * @ExchangeRateLL ,
    --            @ItemProductionCostD * @ExchangeRateEuro ,
    --            @ItemProductionCostTotal ,
    --            @ItemProductionCostTotalD ,
    --            @ItemProductionCostTotalD * @ExchangeRateLL ,
    --            @ItemProductionCostTotalD * @ExchangeRateEuro ,
    --            @UserID ,
    --            @ItemProductionUser ,
    --            0
    --          );

    --      SET @ItemProductionID = ( SELECT TOP ( 1 ) s.ID
    --                                  FROM @IDs AS s
    --                                  ORDER BY s.ID
    --                              );

    --      INSERT INTO @ItemProductionIDs
    --          ( ID ,
    --            RefF
    --          )
    --        VALUES
    --          ( @ItemProductionID ,
    --            FORMAT(@ItemProductionRef, 'n0')
    --          );
   
    --    END;
	
    --    BEGIN --Fix t_Item, t_ItemShared +
       
    --      UPDATE Items.t_Item
    --        SET QtyCurrent += @ItemProductionQtys
    --        WHERE ID = @ItemProductionItemID AND TypeIs = 0;
    
    --      UPDATE Items.t_ItemShared
    --        SET QtyCurrent += @ItemProductionQtys
    --        WHERE ID = @ItemProductionItemSharedID AND TypeIs = 0;

    --    END; 
   
    --    BEGIN --Insert t_ItemProductionMaterial

    --      DELETE FROM @Item;

    --      INSERT INTO Items.t_ItemProductionMaterial
    --          ( ItemProductionID ,
    --            ItemSharedID ,
    --            ItemID ,
    --            ItemUnityID ,
    --            Qty ,
    --            Qtys ,
    --            WarehouseID ,
    --            Cost ,
    --            TotalCost ,
    --            SortAt
    --          )
    --        OUTPUT Inserted.ItemID ,
    --          Inserted.ItemSharedID ,
    --          Inserted.Qtys
    --          INTO @Item
    --        SELECT @ItemProductionID ,
    --            s.ItemSharedID ,
    --            s2.ID ,
    --            s.ItemUnityID ,
    --            s.Qty * @ItemProductionQtys ,
    --            s.Qtys * @ItemProductionQtys ,
    --            @ItemProductionWarehouseID ,
    --            CASE @CurrencyTypeIs
    --              WHEN 0 THEN s1.PurchaseD
    --              WHEN 1 THEN s1.PurchaseLL
    --              ELSE s1.PurchaseEuro
    --            END * s3.Qty ,
    --            (CASE @CurrencyTypeIs
    --              WHEN 0 THEN s1.PurchaseD
    --              WHEN 1 THEN s1.PurchaseLL
    --              ELSE s1.PurchaseEuro
    --            END  * s3.Qty) * (s.Qty * @ItemProductionQtys) ,
    --            ROW_NUMBER() OVER ( ORDER BY ( SELECT 1
    --                                         ) )
    --          FROM Items.t_ItemSharedMaterial AS s
    --          INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
    --          INNER JOIN Items.t_Item AS s2 ON s2.SharedID = s1.ID AND s2.WareHouseID = @ItemProductionWarehouseID
    --          LEFT JOIN Items.t_UnityItem AS s3 ON s3.ID = s.ItemUnityID
    --          WHERE s.ItemSharedFatherID = @ItemProductionItemSharedID;

    --    END;

    --    BEGIN --Fix item qty

    --      DELETE FROM @ItemQtyNet;

    --      INSERT INTO @ItemQtyNet
    --          ( ID ,
    --            Qty
    --          )
    --        SELECT s.ID ,
    --            COALESCE(SUM(s.Qty), 0)
    --          FROM @Item AS s
    --          GROUP BY s.ID;

    --      MERGE Items.t_Item AS t
    --      USING @ItemQtyNet AS s
    --      ON s.ID = t.ID AND t.TypeIs = 0
    --      WHEN MATCHED THEN
    --        UPDATE SET t.QtyCurrent -= s.Qty;

    --    END;

    --    BEGIN --Fix shared item qty
		
    --      INSERT INTO @ItemQtyNet
    --          ( ID ,
    --            Qty
    --          )
    --        SELECT s.SharedID ,
    --            COALESCE(SUM(s.Qty), 0)
    --          FROM @Item AS s
    --          GROUP BY s.SharedID;

    --      MERGE Items.t_ItemShared AS t
    --      USING @ItemQtyNet AS s
    --      ON s.ID = t.ID AND t.TypeIs = 0
    --      WHEN MATCHED THEN
    --        UPDATE SET t.QtyCurrent -= s.Qty;

    --    END;
	
    --    FETCH NEXT FROM i
    --    INTO @ItemDetailID;
    --  END;
    --  CLOSE i;
    --  DEALLOCATE i;

    --  BEGIN --Fix t_ItemShared
	  
    --    UPDATE Items.t_ItemShared
    --      SET PurchaseTotal = Purchase * QtyCurrent ,
    --          PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
    --          PurchaseTotalD = PurchaseD * QtyCurrent ,
    --          PurchaseTotalLL = PurchaseLL * QtyCurrent ,
    --          PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
    --          PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
    --          PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
    --          PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
    --          PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
    --          PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent ,
    --          SellTotal = Sell * QtyCurrent ,
    --          SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](ID), Sell * QtyCurrent) ,
    --          SellTotalD = SellD * QtyCurrent ,
    --          SellTotalLL = SellLL * QtyCurrent ,
    --          SellTotalEuro = SellEuro * QtyCurrent ,
    --          SellTotalWithTax = SellWithTax * QtyCurrent ,
    --          SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent) ,
    --          SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
    --          SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
    --          SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
    --      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
    --                      FROM @DetailIs AS s
    --                      WHERE s.ItemSharedID = t_ItemShared.ID );

    --  END;

    --  BEGIN --Fix t_ItemProduction, t_ItemProductionMaterial
	     
    --    UPDATE Items.t_ItemProduction
    --      SET RefF = FORMAT(Ref, 'n0') ,
    --          SoldRefF = FORMAT(SoldRef, 'n0') ,
    --          DateOnly = DateIs ,
    --          DateMonthly = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
    --          DateYearly = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
    --          QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(ItemUnityID) ,
    --          Warehouse = Company.f_WareHouseGetName(WarehouseID) ,
    --          CostF = Currencys.f_Format(CurrencyID, Cost) ,
    --          TotalCostF = Currencys.f_Format(CurrencyID, TotalCost) ,
    --          ItemsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
    --                                        FROM Items.t_ItemProductionMaterial AS t
    --                                        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
    --                                        WHERE t.ItemProductionID = t_ItemProduction.ID
    --                                     FOR
    --                                       XML PATH('')
    --                                     )) ,
    --          ItemsCounts = ( SELECT COUNT(*)
    --                            FROM Items.t_ItemProductionMaterial AS t
    --                            WHERE t.ItemProductionID = t_ItemProduction.ID
    --                        )
    --      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
    --                      FROM @ItemProductionIDs AS s
    --                      WHERE s.ID = t_ItemProduction.ID );
   
    --    UPDATE Items.t_ItemProductionMaterial
    --      SET QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(ItemUnityID) ,
    --          Warehouse = Company.f_WareHouseGetName(WarehouseID) ,
    --          CostF = Currencys.f_Format(@CurrencyID, Cost) ,
    --          CostD = Cost / @ExchangeRate ,
    --          TotalCostF = Currencys.f_Format(@CurrencyID, TotalCost) ,
    --          TotalCostD = TotalCost / @ExchangeRate
    --      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
    --                      FROM @ItemProductionIDs AS s
    --                      WHERE s.ID = Items.t_ItemProductionMaterial.ItemProductionID );
     
    --    UPDATE Items.t_ItemProductionMaterial
    --      SET CostLL = CostD * @ExchangeRateLL ,
    --          CostEuro = CostD * @ExchangeRateEuro ,
    --          TotalCostLL = TotalCostD * @ExchangeRateLL ,
    --          TotalCostEuro = TotalCostD * @ExchangeRateEuro
    --      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
    --                      FROM @ItemProductionIDs AS s
    --                      WHERE s.ID = Items.t_ItemProductionMaterial.ItemProductionID );

    --  END;
	 
    --END;

    EXECUTE [Items].[s_ItemProductionInsertBySold] @ProductionWhenSale, @ID, @Ref, @DateIs, @CurrencyID, @Currency, @CurrencyTypeIs, @ExchangeRate,
      @ExchangeRateLL, @ExchangeRateEuro, @DetailIs, @UserID, @EventInsert, @EventInsertBySold, @ComputerIP, @Computer, @ComputerAccount; 

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @return;

  END CATCH;

END;







GO
