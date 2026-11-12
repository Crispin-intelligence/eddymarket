SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedRebuildingStatistics]
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

    DISABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;
    DISABLE TRIGGER Items.tr_Item ON Items.t_Item;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      WITH  o AS ( SELECT COALESCE(t2.DateIs, t.DateCreate) AS DateIs ,
                          t.LastStockTakeDate
                   FROM   Items.t_Item AS t
                   FULL JOIN Items.t_StockTakeDetail AS t1 ON t1.ItemID = t.ID
                   LEFT JOIN Items.t_StockTake AS t2 ON t2.ID = t1.StockTakeID
                 )
        UPDATE  o
        SET     o.LastStockTakeDate = o.DateIs;

      WITH  o AS ( SELECT t.ID ,
                          t.QtyCurrent
                   FROM   Items.t_Item AS t
                   WHERE  t.TypeIs = 0
                 )
        UPDATE  o
        SET     o.QtyCurrent = Items.f_ItemGetQty(o.ID);

      WITH  o AS ( SELECT t.ID ,
                          t.QtyCurrent
                   FROM   Items.t_Item AS t
                   WHERE  t.TypeIs = 1
                 )
        UPDATE  o
        SET     o.QtyCurrent = 0;

      UPDATE  Items.t_Item
      SET     WareHouse = Company.f_WareHouseGetName(WareHouseID) ,
              Place = Company.f_PlaceGetName(PlaceID) ,
              StockTakeEveryARF = FORMAT(StockTakeEvery, '0') + CASE StockTakeEveryType
                                                                  WHEN 2 THEN N' أيام'
                                                                  WHEN 1 THEN N' شهور'
                                                                  ELSE N' سنوات'
                                                                END ,
              StockTakeEveryENF = FORMAT(StockTakeEvery, '0') + CASE StockTakeEveryType
                                                                  WHEN 2 THEN N' Days'
                                                                  WHEN 1 THEN N' Months'
                                                                  ELSE N' Years'
                                                                END ,
              StockTakeEveryNotificationDate = CASE StockTakeEveryType
                                                 WHEN 2 THEN DATEADD(DAY, StockTakeEvery, LastStockTakeDate)
                                                 WHEN 1 THEN DATEADD(MONTH, StockTakeEvery, LastStockTakeDate)
                                                 ELSE DATEADD(YEAR, StockTakeEvery, LastStockTakeDate)
                                               END;

      UPDATE  Items.t_Item
      SET     QtyCurrentByUnit = Alls.f_FixXML(( SELECT DISTINCT
                                                        ', ' + FORMAT(t_Item.QtyCurrent / t.Qty, '#,##0.##') + N' ' + t1.Name AS [text()]
                                                 FROM   Items.t_UnityItem AS t
                                                 LEFT JOIN Items.t_Unity AS t1 ON t1.ID = t.UnityID
                                                 WHERE  t.SharedID = t_Item.SharedID
                                                        AND t.Qty > 1
                                               FOR
                                                 XML PATH('')
                                               ));

      UPDATE  Items.t_ItemShared
      SET     QtyCurrent = ( SELECT COALESCE(SUM(s.QtyCurrent), 0)
                             FROM   Items.t_Item AS s
                             WHERE  s.SharedID = t_ItemShared.ID
                           ) ,
              Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
                                       FOR
                                         XML PATH('')
                                       )) ,
              MainCategory = Items.f_MainCategoryGetName(MainCategoryID) ,
              SubCategory = Items.f_SubCategoryGetName(SubCategoryID) ,
              Brand = Items.f_BrandGetName(BrandID) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              PurchaseF = Currencys.f_Format(CurrencyID, Purchase) ,
              PurchaseWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax) ,
              SellCurrency = Currencys.f_CurrencyGetName(SellCurrencyID) ,
              SellF = Currencys.f_Format(SellCurrencyID, Sell) ,
              SellWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax) ,
              DiscountF = FORMAT(Discount, 'n') + ' %' ,
              UnityC = ( SELECT COUNT(t.ID)
                         FROM   Items.t_UnityItem AS t
                         WHERE  t.SharedID = t_ItemShared.ID
                       ) ,
              UnityNames = Alls.f_FixXML(( SELECT N', ' + t.Unity AS [text()]
                                           FROM   Items.t_UnityItem AS t
                                           WHERE  t.SharedID = t_ItemShared.ID
                                         FOR
                                           XML PATH('')
                                         )) ,
              VendorC = ( SELECT  COUNT(t.ID)
                          FROM    Items.t_ItemSharedVendor AS t
                          WHERE   t.SharedID = t_ItemShared.ID
                        ) ,
              VendorNames = Alls.f_FixXML(( SELECT  N', ' + t.Vendor AS [text()]
                                            FROM    Items.t_ItemSharedVendor AS t
                                            WHERE   t.SharedID = t_ItemShared.ID
                                          FOR
                                            XML PATH('')
                                          )) ,
              PlacesNames = Alls.f_FixXML(( SELECT  N', ' + t.Place AS [text()]
                                            FROM    Items.t_Item AS t
                                            WHERE   t.SharedID = t_ItemShared.ID
                                          FOR
                                            XML PATH('')
                                          )) ,
              FileStorageC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_FileStorageLinked AS t
                               WHERE  t.SectionID = 10
                                      AND t.OwnerID = t_ItemShared.ID
                             ) ,
              DaysLastSale = DATEDIFF(DAY, DateLastSale, GETDATE()) ,
              MaterialsNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                               FROM   Items.t_ItemSharedMaterial AS t
                                               LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                               WHERE  t.ItemSharedFatherID = t_ItemShared.ID
                                             FOR
                                               XML PATH('')
                                             )) ,
              MaterialsCounts = ( SELECT  COUNT(t.ID)
                                  FROM    Items.t_ItemSharedMaterial AS t
                                  WHERE   t.ItemSharedFatherID = t_ItemShared.ID
                                ) ,
              ProfitPartnersCount = ( SELECT  COUNT(s.ID)
                                      FROM    Items.t_ItemSharedProfitPartner AS s
                                      WHERE   s.ItemSharedID = t_ItemShared.ID
                                    ) ,
              ProfitPartners = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + s1.Name AS [text()]
                                               FROM   Items.t_ItemSharedProfitPartner AS s
                                               INNER JOIN Items.t_ProfitPartner AS s1 ON s1.ID = s.ProfitPartnerID
                                               WHERE  s.ItemSharedID = t_ItemShared.ID
                                             FOR
                                               XML PATH('')
                                             ));

      UPDATE  Items.t_ItemShared
      SET     StatusIs = 1
      WHERE   StatusIs = 0
              AND MakeInactiveAfter <> 0
              AND CASE MakeInactiveAfterType
                    WHEN 2 THEN DATEADD(DAY, MakeInactiveAfter, DateLastSale)
                    WHEN 1 THEN DATEADD(MONTH, MakeInactiveAfter, DateLastSale)
                    ELSE DATEADD(YEAR, MakeInactiveAfter, DateLastSale)
                  END < GETDATE();

      WITH  o AS ( SELECT s.CurrencyID ,
                          s.Purchase ,
                          s.PurchaseD ,
                          s.PurchaseLL ,
                          s.PurchaseEuro ,
                          s.PurchaseWithTax ,
                          s.PurchaseWithTaxD ,
                          s.PurchaseWithTaxLL ,
                          s.PurchaseWithTaxEuro ,
                          s.SellCurrencyID ,
                          s.Sell ,
                          s.SellD ,
                          s.SellLL ,
                          s.SellEuro ,
                          s.SellWithTax ,
                          s.SellWithTaxD ,
                          s.SellWithTaxLL ,
                          s.SellWithTaxEuro ,
                          s1.ExchangeRate ,
                          s2.ExchangeRate AS ExchangeRateSell
                   FROM   Items.t_ItemShared AS s
                   LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   LEFT JOIN Currencys.t_Currency AS s2 ON s2.ID = s.SellCurrencyID
                 )
        UPDATE  o
        SET     o.PurchaseD = o.Purchase / o.ExchangeRate ,
                o.PurchaseLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                o.PurchaseEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Purchase, o.Purchase / o.ExchangeRate) ,
                o.PurchaseWithTaxD = o.PurchaseWithTax / o.ExchangeRate ,
                o.PurchaseWithTaxLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PurchaseWithTax, o.PurchaseWithTax / o.ExchangeRate) ,
                o.PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PurchaseWithTax, o.PurchaseWithTax / o.ExchangeRate) ,
                o.SellD = o.Sell / o.ExchangeRateSell ,
                o.SellLL = Currencys.f_ExchangeToLL(o.SellCurrencyID, o.Sell, o.Sell / o.ExchangeRateSell) ,
                o.SellEuro = Currencys.f_ExchangeToEuro(o.SellCurrencyID, o.Sell, o.Sell / o.ExchangeRateSell) ,
                o.SellWithTaxD = o.SellWithTax / o.ExchangeRateSell ,
                o.SellWithTaxLL = Currencys.f_ExchangeToLL(o.SellCurrencyID, o.SellWithTax, o.SellWithTax / o.ExchangeRateSell) ,
                o.SellWithTaxEuro = Currencys.f_ExchangeToEuro(o.SellCurrencyID, o.SellWithTax, o.SellWithTax / o.ExchangeRateSell);

      WITH  o AS ( SELECT s.Qty ,
                          s.CurrencyID ,
                          s.Price ,
                          s.PriceF ,
                          s.PriceD ,
                          s.PriceLL ,
                          s.PriceEuro ,
                          s.PriceWithTax ,
                          s.PriceWithTaxF ,
                          s.PriceWithTaxD ,
                          s.PriceWithTaxLL ,
                          s.PriceWithTaxEuro ,
                          s1.ExchangeRate ,
                          s.CurrencyIDCost ,
                          s.CurrencyCost ,
                          s.Cost ,
                          s.CostF ,
                          s.CostD ,
                          s.CostLL ,
                          s.CostEuro ,
                          s.CostWithTax ,
                          s.CostWithTaxF ,
                          s.CostWithTaxD ,
                          s.CostWithTaxLL ,
                          s.CostWithTaxEuro ,
                          s2.CurrencyID AS CurrencyIDCost_ ,
                          s2.Currency AS CurrencyCost_ ,
                          s2.Purchase AS Cost_ ,
                          s2.PurchaseD AS CostD_ ,
                          s2.PurchaseLL AS CostLL_ ,
                          s2.PurchaseEuro AS CostEuro_ ,
                          s2.PurchaseWithTax AS CostWithTax_ ,
                          s2.PurchaseWithTaxD AS CostWithTaxD_ ,
                          s2.PurchaseWithTaxLL AS CostWithTaxLL_ ,
                          s2.PurchaseWithTaxEuro AS CostWithTaxEuro_ ,
                          s.QtyCurrent ,
                          s2.QtyCurrent AS QtyCurrent_
                   FROM   Items.t_UnityItem AS s
                   LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = s.CurrencyID
                   LEFT JOIN Items.t_ItemShared AS s2 ON s2.ID = s.SharedID
                 )
        UPDATE  o
        SET     o.PriceF = Currencys.f_Format(o.CurrencyID, o.Price) ,
                o.PriceD = o.Price / o.ExchangeRate ,
                o.PriceLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.Price, o.Price / o.ExchangeRate) ,
                o.PriceEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.Price, o.Price / o.ExchangeRate) ,
                o.PriceWithTaxF = Currencys.f_Format(o.CurrencyID, o.PriceWithTax) ,
                o.PriceWithTaxD = o.PriceWithTax / o.ExchangeRate ,
                o.PriceWithTaxLL = Currencys.f_ExchangeToLL(o.CurrencyID, o.PriceWithTax, o.PriceWithTax / o.ExchangeRate) ,
                o.PriceWithTaxEuro = Currencys.f_ExchangeToEuro(o.CurrencyID, o.PriceWithTax, o.PriceWithTax / o.ExchangeRate) ,
                o.CurrencyIDCost = o.CurrencyIDCost_ ,
                o.CurrencyCost = o.CurrencyCost_ ,
                o.Cost = o.Cost_ * o.Qty ,
                o.CostF = Currencys.f_Format(o.CurrencyIDCost_, o.Cost_ * o.Qty) ,
                o.CostD = o.CostD_ * o.Qty ,
                o.CostLL = o.CostLL_ * o.Qty ,
                o.CostEuro = o.CostEuro_ * o.Qty ,
                o.CostWithTax = o.CostWithTax_ * o.Qty ,
                o.CostWithTaxF = Currencys.f_Format(o.CurrencyIDCost_, o.CostWithTax_ * o.Qty) ,
                o.CostWithTaxD = o.CostWithTaxD_ * o.Qty ,
                o.CostWithTaxLL = o.CostWithTaxLL_ * o.Qty ,
                o.CostWithTaxEuro = o.CostWithTaxEuro_ * o.Qty ,
                o.QtyCurrent = o.QtyCurrent_ / o.Qty;

      UPDATE  Items.t_ItemShared
      SET     QtyCurrentByUnit = Alls.f_FixXML(( SELECT DISTINCT
                                                        ', ' + FORMAT(t_ItemShared.QtyCurrent / t.Qty, '#,##0.##') + N' ' + t1.Name AS [text()]
                                                 FROM   Items.t_UnityItem AS t
                                                 LEFT JOIN Items.t_Unity AS t1 ON t1.ID = t.UnityID
                                                 WHERE  t.SharedID = t_ItemShared.ID
                                                        AND t.Qty > 1
                                               FOR
                                                 XML PATH('')
                                               )) ,
              PurchaseTotal = Purchase * QtyCurrent ,
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
              SellTotalF = Currencys.f_Format(SellCurrencyID, Sell * QtyCurrent) ,
              SellTotalD = SellD * QtyCurrent ,
              SellTotalLL = SellLL * QtyCurrent ,
              SellTotalEuro = SellEuro * QtyCurrent ,
              SellTotalWithTax = SellWithTax * QtyCurrent ,
              SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent) ,
              SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
              SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
              SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent;

      UPDATE  Items.t_ItemSharedMaterial
      SET     CreateBy = Users.f_UserGetName(CreateByID);

      UPDATE  Items.t_ItemShared
      SET     SearchText = Items.f_ItemSharedSearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemSharedMoving
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

    ENABLE TRIGGER Items.tr_ItemShared ON Items.t_ItemShared;
    ENABLE TRIGGER Items.tr_Item ON Items.t_Item;

    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

            --BEGIN --GoldenClick

            --    MERGE GoldenClick.dbo.t_ItemQtyFlexiBills AS t
            --    USING Items.t_ItemShared AS s
            --    ON s.ID = t.ID
            --    WHEN NOT MATCHED BY TARGET THEN
            --        INSERT ( ID, Barcode, Qty )
            --        VALUES ( s.ID ,
            --                 s.Barcode ,
            --                 s.QtyCurrent
            --               )
            --    WHEN MATCHED THEN
            --        UPDATE SET t.Barcode = s.Barcode ,
            --                  t.Qty = s.QtyCurrent;

            --    UPDATE  GoldenClick.dbo.t_liveVersion
            --    SET     ItemQtyFlexiBills = NEWID();

            --END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;


GO
