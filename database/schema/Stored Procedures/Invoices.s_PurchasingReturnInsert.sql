SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_PurchasingReturnInsert] @RefPaper NVARCHAR(MAX) ,
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
  @DetailIs Invoices.tt_PurchasingReturnDetail READONLY ,
  @SerialIs Items.tt_ItemSerial READONLY ,
  @StatementIs NVARCHAR(MAX) ,
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
        @TransactionID UNIQUEIDENTIFIER ,
        @TransactionRef BIGINT ,
        @RowNumber INT ,
        @Vendor NVARCHAR(MAX) ,
        @Box NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @CurrencyTypeIs INT ,
        @AccountIsVendor BIT ,
        @LinkType TINYINT = 1 ,
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

      SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
        FROM Invoices.t_PurchasingReturn AS s;

      SET @Vendor = Company.f_AccountGetName(@VendorID);
      SET @Box = Company.f_AccountGetName(@BoxID);

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
      SELECT @Profit = COALESCE(SUM(s.ProfitTotal), 0)
        FROM @DetailIs AS s;
      SET @ProfitD = @Profit / @ExchangeRate;
      
    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT INTO Invoices.t_PurchasingReturn
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
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            FORMAT(@Ref, 'n0') ,
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
            Company.f_AccountGetName(@VendorID) ,
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
            ( SELECT COALESCE(SUM(s.SubTotal), 0)
                FROM @DetailIs AS s
            ) ,
            @DiscountIs ,
            @Tax ,
            ( SELECT COALESCE(SUM(s.Total), 0)
                FROM @DetailIs AS s
            ) ,
            @Profit ,
            ( SELECT COALESCE(SUM(s.Sell * s.Qtys), 0)
                FROM @DetailIs AS s
            ) ,
            ( SELECT COALESCE(SUM(s.Qtys), 0)
                FROM @DetailIs AS s
            ) ,
            @DescriptionIs ,
            @Payment
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Insert detail

      INSERT INTO Invoices.t_PurchasingReturnDetail
          ( ID ,
            PurchasingReturnID ,
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
        OUTPUT Inserted.ItemID ,
          Inserted.ItemSharedID ,
          Inserted.Qtys
          INTO @Item
        SELECT s.ID ,
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
          FROM @DetailIs AS s
          LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
          LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID;

    END;

    BEGIN --Insert detial serial

      INSERT INTO Invoices.t_PurchasingReturnDetailSerial
          ( PurchasingReturnID ,
            PurchasingReturnDetailID ,
            SerialID
          )
        SELECT @ID ,
            s.FatherID ,
            s.ID
          FROM @SerialIs AS s;

    END;

    BEGIN --Update item serial

      UPDATE Items.t_ItemSerial
        SET IsAvailable = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @SerialIs AS s
                        WHERE s.ID = t_ItemSerial.ID );

    END;

    BEGIN --Rebuild statistics

      UPDATE Invoices.t_PurchasingReturn
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

      UPDATE Invoices.t_PurchasingReturn
        SET TaxRate = ( TaxValue / ( NetIs - TaxValue ) ) * 100.0 ,
            TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
        WHERE ID = @ID AND NetIs > 0;

    END;

    BEGIN --Fix item qty

      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT s.ID ,
            COALESCE(SUM(s.Qty), 0)
          FROM @Item AS s
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
          FROM @Item AS s
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

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Invoices.t_PurchasingReturnMoving
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
            @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref) ,
            0 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    IF @Net > 0
    BEGIN --Transaction

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
        EXECUTE Transactions.s_TransactionDetailInsertDebitTax @RowNumber, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @Tax, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

      END;

      IF @NetNonTaxable > 0
      BEGIN --Insert detail 
	   
        SET @V = @NetNonTaxable;
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @RowNumber, @TransactionID, @AccountIDPurchaseNonTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
										
      END;

      IF @Tax > 0
      BEGIN --Insert detail tax

        SET @V = @NetTaxableWithoutTax;
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @RowNumber, @TransactionID, @AccountIDPurchaseTaxable, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

        SET @V = @Tax;
        SET @RowNumber += 1;
        SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref);
        EXECUTE Transactions.s_TransactionDetailInsertCredit @RowNumber, @TransactionID, @AccountTaxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;
					
      END;

    END;

    IF @Payment > 0
    BEGIN --Transaction

      BEGIN --Set info

        SELECT @TransactionRef = ISNULL(MAX(s.Ref), 0) + 1
          FROM Transactions.t_Transaction AS s
          WHERE s.TypeIs = N'RV';

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
              N'RV' ,
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
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

        END;
        ELSE
        BEGIN
		 
          SET @V = @Payment - @Tax;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor;
          EXECUTE Transactions.s_TransactionDetailInsertDebit 1, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box;
          EXECUTE Transactions.s_TransactionDetailInsertCredit 2, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @StatementIs_;

          SET @V = @Payment - @V;
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Vendor + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertDebit 3, @TransactionID, @BoxID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;
        
          SET @StatementIs_ = REPLACE(@StatementIs, N'{0}', @Ref) + ' \ ' + @Box + N' (' + @TaxExchangeRateEvent + N': ' + FORMAT(@TaxExchangeRateLL, N'#,##0.##') + N')';
          EXECUTE Transactions.s_TransactionDetailInsertCredit 4, @TransactionID, @VendorID, @DateIs, @CID, @V, @E, @TaxExchangeRateLL, @TaxExchangeRateEuro, @StatementIs_;

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
        SET PurchasingReturnC += 1 ,
            PurchasingReturnTotal = CASE CurrencyTypeIs
                                      WHEN 0 THEN @NetD
                                      WHEN 1 THEN @NetD * @ExchangeRateLL
                                      ELSE @NetD * @ExchangeRateEuro
                                    END ,
            PurchasingReturnProfit = CASE CurrencyTypeIs
                                       WHEN 0 THEN @ProfitD
                                       WHEN 1 THEN @ProfitD * @ExchangeRateLL
                                       ELSE @ProfitD * @ExchangeRateEuro
                                     END ,
            PurchasingReturnLast = [Invoices].f_PurchasingReturnGetLastDateByAccountVendorID(ID)
        WHERE ID = @VendorID;

      UPDATE Company.t_Account
        SET PurchasingReturnTotalF = Currencys.f_Format(CurrencyID, PurchasingReturnTotal) ,
            PurchasingReturnProfitF = Currencys.f_Format(CurrencyID, PurchasingReturnProfit)
        WHERE ID = @VendorID;

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
