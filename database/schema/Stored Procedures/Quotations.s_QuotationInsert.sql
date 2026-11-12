SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationInsert] @RefPaper NVARCHAR(MAX) ,
  @DateIs DATETIME ,
  @AccountID UNIQUEIDENTIFIER ,
  @SalespersonID UNIQUEIDENTIFIER ,
  @CommissionRate DECIMAL(18, 2) ,
  @CommissionRateType TINYINT ,
  @AttentionTo NVARCHAR(MAX) ,
  @SubjectIs NVARCHAR(MAX) ,
  @WarrantyID UNIQUEIDENTIFIER ,
  @TypeID UNIQUEIDENTIFIER ,
  @Net FLOAT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @DiscountIs FLOAT ,
  @StatusIs TINYINT ,
  @NotificationAfterDays TINYINT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @NotificationTextAR NVARCHAR(MAX) ,
  @NotificationTextEN NVARCHAR(MAX) ,
  @DetailIs Quotations.[tt_QuotationDetail] READONLY ,
  @Notes [Quotations].[tt_QuotationNoteLink] READONLY ,
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

      DECLARE @Item AS TABLE
        (
          SharedID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 2) NOT NULL
        );

      DECLARE @Ref BIGINT ,
        @Currency NVARCHAR(MAX) ,
        @NetD FLOAT ,
        @Profit FLOAT ,
        @ProfitD FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT @Ref = COALESCE(MAX(o.Ref), 0) + 1
        FROM ( SELECT s.Ref
                FROM Quotations.t_Quotation AS s
               UNION ALL
               SELECT s.Ref
                FROM Quotations.t_QuotationHistory AS s
             ) AS o;

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
    
      SET @NetD = @Net / @ExchangeRate;

      SELECT @Profit = COALESCE(SUM(s.ProfitTotal), 0)
        FROM @DetailIs AS s;
      SET @ProfitD = @Profit / @ExchangeRate;

    END;

    BEGIN --Insert

      SET @return = 0;

      INSERT INTO Quotations.t_Quotation
          ( Ref ,
            RefF ,
            RefPaper ,
            DateIs ,
            DateOnly ,
            DateMonthly ,
            DateYearly ,
            AccountID ,
            Account ,
            AccountNumberF ,
            SalespersonID ,
            Salesperson ,
            CommissionRate ,
            CommissionRateF ,
            CommissionRateType ,
            CommissionValue ,
            AttentionTo ,
            SubjectIs ,
            WarrantyID ,
            Warranty ,
            TypeID ,
            TypeIs ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            ExchangeRateLL ,
            ExchangeRateEuro ,
            Total ,
            DiscountIs ,
            TaxValue ,
            NetIs ,
            Profit ,
            Cost ,
            Qtys ,
            StatusIs ,
            NotificationAfterDays ,
            NotificationDate ,
            NotificationStop ,
            NotificationTextAR ,
            NotificationTextEN ,
            DescriptionIs
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            FORMAT(@Ref, 'n0') ,
            @RefPaper ,
            @DateIs ,
            @DateIs ,
            DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            @AccountID ,
            Company.f_AccountGetName(@AccountID) ,
            Company.f_AccountGetNumberF(@AccountID) ,
            @SalespersonID ,
            Employees.f_SalesPersonGetName(@SalespersonID) ,
            @CommissionRate ,
            FORMAT(@CommissionRate, '0.##') + N' %' ,
            @CommissionRateType ,
            ( @Net / 100 ) * @CommissionRate ,
            @AttentionTo ,
            @SubjectIs ,
            @WarrantyID ,
            Quotations.f_QuotationWarrantyGetName(@WarrantyID) ,
            @TypeID ,
            Quotations.f_QuotationTypeGetName(@TypeID) ,
            @CurrencyID ,
            @Currency ,
            @ExchangeRate ,
            @ExchangeRateLL ,
            @ExchangeRateEuro ,
            ( SELECT COALESCE(SUM(s.SubTotal), 0)
                FROM @DetailIs AS s
            ) ,
            @DiscountIs ,
            ( SELECT COALESCE(SUM(s.TaxValue), 0)
                FROM @DetailIs AS s
            ) ,
            ( SELECT COALESCE(SUM(s.Total), 0)
                FROM @DetailIs AS s
            ) ,
            ( SELECT COALESCE(SUM(s.ProfitTotal), 0)
                FROM @DetailIs AS s
            ) ,
            ( SELECT COALESCE(SUM(s.Cost * s.Qtys), 0)
                FROM @DetailIs AS s
            ) ,
            ( SELECT COALESCE(SUM(s.Qtys), 0)
                FROM @DetailIs AS s
            ) ,
            @StatusIs ,
            @NotificationAfterDays ,
            DATEADD(DAY, @NotificationAfterDays, @DateIs) ,
            0 ,
            @NotificationTextAR ,
            @NotificationTextEN ,
            @DescriptionIs
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Insert detail

      INSERT INTO Quotations.t_QuotationDetail
          ( ID ,
            QuotationID ,
            ItemSharedID ,
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
            DiscountQuotation ,
            DiscountQuotationF ,
            DiscountQuotationD ,
            DiscountQuotationLL ,
            DiscountQuotationEuro ,
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
            SortAt
          )
        OUTPUT Inserted.ItemSharedID ,
          Inserted.Qtys
          INTO @Item
        SELECT s.ID ,
            @ID ,
            s.ItemSharedID ,
            s.ItemUnityID ,
            s.Qty ,
            FORMAT(s.Qty, '#,##0.##') + ' ' + s2.Name ,
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
            s.DiscountQuotation ,
            Currencys.f_Format(@CurrencyID, s.DiscountQuotation) ,
            s.DiscountQuotation / @ExchangeRate ,
            ( s.DiscountQuotation / @ExchangeRate ) * @ExchangeRateLL ,
            ( s.DiscountQuotation / @ExchangeRate ) * @ExchangeRateEuro ,
            s.TaxRate ,
            FORMAT(s.TaxRate, '0.##') + ' %' ,
            s.TaxValue ,
            Currencys.f_Format(@CurrencyID, s.TaxValue) ,
            s.TaxValue / @ExchangeRate ,
            ( s.TaxValue / @ExchangeRate ) * @ExchangeRateLL ,
            ( s.TaxValue / @ExchangeRate ) * @ExchangeRateEuro ,
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
            s.DescriptionIs ,
            s.SortAt
          FROM @DetailIs AS s
          LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
          LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID;

    END;

    BEGIN --Insert Notes

      INSERT INTO Quotations.t_QuotationNoteLink
          ( QuotationID ,
            NoteID ,
            SortAt
          )
        SELECT @ID ,
            s.NoteID ,
            s.SortAt
          FROM @Notes AS s;

    END;

    BEGIN --Rebuild statistics

      UPDATE Quotations.t_Quotation
        SET CommissionValueF = Currencys.f_Format(CurrencyID, CommissionValue) ,
            CommissionValueD = CommissionValue / ExchangeRate ,
            CommissionValueLL = ( CommissionValue / ExchangeRate ) * @ExchangeRateLL ,
            CommissionValueEuro = ( CommissionValue / ExchangeRate ) * @ExchangeRateEuro ,
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
            TaxValueLL = ( TaxValue / ExchangeRate ) * @ExchangeRateLL ,
            TaxValueEuro = ( TaxValue / ExchangeRate ) * @ExchangeRateEuro ,
            NetIsF = Currencys.f_Format(CurrencyID, NetIs) ,
            NetIsD = NetIs / ExchangeRate ,
            NetIsLL = ( NetIs / ExchangeRate ) * @ExchangeRateLL ,
            NetIsEuro = ( NetIs / ExchangeRate ) * @ExchangeRateEuro ,
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
            ItemsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                          FROM Quotations.t_QuotationDetail AS t
                                          LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                          WHERE t.QuotationID = t_Quotation.ID
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

      UPDATE Quotations.t_Quotation
        SET TaxRate = ( TaxValue / ( NetIs - TaxValue ) ) * 100.0 ,
            TaxRateF = FORMAT(( TaxValue / ( NetIs - TaxValue ) ) * 100.0, '0.##') + N' %'
        WHERE ID = @ID AND NetIs > 0;

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
      ON s.ItemUnityID = t.ItemUnityID AND t.AccountID = @AccountID
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
        VALUES ( @AccountID ,
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
        UPDATE SET t.CurrencyID = @CurrencyID ,
                    t.Currency = @Currency ,
                    t.Price = s.Price ,
                    t.PriceF = Currencys.f_Format(@CurrencyID, s.Price) ,
                    t.PriceD = s.Price / @ExchangeRate ,
                    t.DiscountIs = s.DiscountIs ,
                    t.DiscountIsF = FORMAT(s.DiscountIs, '0.##') + ' %';

    END;

    BEGIN --Fix t_Account

      UPDATE Company.t_Account
        SET QuotationC += 1 ,
            QuotationTotal = CASE CurrencyTypeIs
                               WHEN 0 THEN @NetD
                               WHEN 1 THEN @NetD * Currencys.f_CurrencyGetExchangeRateLL()
                               ELSE @NetD * Currencys.f_CurrencyGetExchangeRateEuro()
                             END ,
            QuotationProfit = CASE CurrencyTypeIs
                                WHEN 0 THEN @ProfitD
                                WHEN 1 THEN @ProfitD * Currencys.f_CurrencyGetExchangeRateLL()
                                ELSE @ProfitD * Currencys.f_CurrencyGetExchangeRateEuro()
                              END ,
            SoldLast = Quotations.f_QuotationGetLastDateByAccountID(ID)
        WHERE ID = @AccountID;

      UPDATE Company.t_Account
        SET QuotationTotalF = Currencys.f_Format(CurrencyID, QuotationTotal) ,
            QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit)
        WHERE ID = @AccountID;
		  
    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Quotations.t_QuotationMoving
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

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT @return;

  END CATCH;

END;






GO
