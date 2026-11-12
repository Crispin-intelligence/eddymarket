SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationUpdate] @RefPaper NVARCHAR(MAX) ,
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
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    SET ANSI_WARNINGS OFF;

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Item AS TABLE
        (
          SharedID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 2) NOT NULL
        );

      DECLARE @return INT ,
        @AccountIDOld UNIQUEIDENTIFIER ,
        @Currency NVARCHAR(MAX);

    END;

    BEGIN --Set info

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
	 
      SELECT TOP ( 1 ) @AccountIDOld = s.AccountID
        FROM Quotations.t_Quotation AS s
        WHERE s.ID = @ID;

    END;

    BEGIN --Update

      SET @return = 0;

      UPDATE Quotations.t_Quotation
        SET RefPaper = @RefPaper ,
            DateIs = @DateIs ,
            DateOnly = @DateIs ,
            DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
            DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
            AccountID = @AccountID ,
            Account = Company.f_AccountGetName(@AccountID) ,
            AccountNumberF = Company.f_AccountGetNumberF(@AccountID) ,
            SalespersonID = @SalespersonID ,
            Salesperson = Employees.f_SalesPersonGetName(@SalespersonID) ,
            CommissionRate = @CommissionRate ,
            CommissionRateF = FORMAT(@CommissionRate, '0.##') + N' %' ,
            CommissionRateType = @CommissionRateType ,
            CommissionValue = @Net / 100 * @CommissionRate ,
            AttentionTo = @AttentionTo ,
            SubjectIs = @SubjectIs ,
            WarrantyID = @WarrantyID ,
            Warranty = Quotations.f_QuotationWarrantyGetName(@WarrantyID) ,
            TypeID = @TypeID ,
            TypeIs = Quotations.f_QuotationTypeGetName(@TypeID) ,
            CurrencyID = @CurrencyID ,
            Currency = @Currency ,
            ExchangeRate = @ExchangeRate ,
            ExchangeRateLL = @ExchangeRateLL ,
            ExchangeRateEuro = @ExchangeRateEuro ,
            Total = ( SELECT COALESCE(SUM(s.SubTotal), 0)
                        FROM @DetailIs AS s
                    ) ,
            DiscountIs = @DiscountIs ,
            TaxValue = ( SELECT COALESCE(SUM(s.TaxValue), 0)
                          FROM @DetailIs AS s
                       ) ,
            NetIs = ( SELECT COALESCE(SUM(s.Total), 0)
                        FROM @DetailIs AS s
                    ) ,
            Profit = ( SELECT COALESCE(SUM(s.ProfitTotal), 0)
                        FROM @DetailIs AS s
                     ) ,
            Cost = ( SELECT COALESCE(SUM(s.Cost * s.Qtys), 0)
                      FROM @DetailIs AS s
                   ) ,
            Qtys = ( SELECT COALESCE(SUM(s.Qtys), 0)
                      FROM @DetailIs AS s
                   ) ,
            StatusIs = @StatusIs ,
            NotificationAfterDays = @NotificationAfterDays ,
            NotificationDate = DATEADD(DAY, @NotificationAfterDays, @DateIs) ,
            NotificationStop = 0 ,
            NotificationTextAR = @NotificationTextAR ,
            NotificationTextEN = @NotificationTextEN ,
            DescriptionIs = @DescriptionIs
        WHERE ID = @ID;

    END;

    BEGIN --Insert detail

      MERGE Quotations.t_QuotationDetail AS t
      USING @DetailIs AS s
      ON s.ID = t.ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
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
        VALUES ( s.ID ,
                 @ID ,
                 s.ItemSharedID ,
                 s.ItemUnityID ,
                 s.Qty ,
                 FORMAT(s.Qty, '#,##0.##') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID) ,
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
               )
      WHEN MATCHED THEN
        UPDATE SET t.ItemUnityID = s.ItemUnityID ,
                    t.Qty = s.Qty ,
                    t.QtyWithUnity = FORMAT(s.Qty, '#,##0.##') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID) ,
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
                    t.DiscountQuotation = s.DiscountQuotation ,
                    t.DiscountQuotationF = Currencys.f_Format(@CurrencyID, s.DiscountQuotation) ,
                    t.DiscountQuotationD = s.DiscountQuotation / @ExchangeRate ,
                    t.DiscountQuotationLL = ( s.DiscountQuotation / @ExchangeRate ) * @ExchangeRateLL ,
                    t.DiscountQuotationEuro = ( s.DiscountQuotation / @ExchangeRate ) * @ExchangeRateEuro ,
                    t.TaxRate = s.TaxRate ,
                    t.TaxRateF = FORMAT(s.TaxRate, '0.##') + ' %' ,
                    t.TaxValue = s.TaxValue ,
                    t.TaxValueF = Currencys.f_Format(@CurrencyID, s.TaxValue) ,
                    t.TaxValueD = s.TaxValue / @ExchangeRate ,
                    t.TaxValueLL = ( s.TaxValue / @ExchangeRate ) * @ExchangeRateLL ,
                    t.TaxValueEuro = ( s.TaxValue / @ExchangeRate ) * @ExchangeRateEuro ,
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
                    t.DescriptionIs = s.DescriptionIs ,
                    t.SortAt = s.SortAt
      WHEN NOT MATCHED BY SOURCE AND t.QuotationID = @ID THEN
        DELETE;

      INSERT INTO @Item
          ( SharedID ,
            Qty
          )
        SELECT s.ItemSharedID ,
            s.Qtys
          FROM Quotations.t_QuotationDetail AS s
          WHERE s.QuotationID = @ID;

    END;

    BEGIN --Insert Notes

      DELETE FROM Quotations.t_QuotationNoteLink
        WHERE QuotationID = @ID;

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
        SET QuotationTotal = Quotations.f_QuotationGetTotalByAccountID(ID) ,
            QuotationProfit = Quotations.f_QuotationGetProfitByAccountID(ID) ,
            QuotationLast = Quotations.f_QuotationGetLastDateByAccountID(ID)
        WHERE ID = @AccountID OR ID = @AccountIDOld;

      UPDATE Company.t_Account
        SET QuotationTotalF = Currencys.f_Format(CurrencyID, QuotationTotal) ,
            QuotationProfitF = Currencys.f_Format(CurrencyID, QuotationProfit)
        WHERE ID = @AccountID OR ID = @AccountIDOld;
		  
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
            @Event ,
            1 ,
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
