SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedUpdate]
  @Name NVARCHAR(MAX) ,
  @NameInvoice NVARCHAR(MAX) ,
  @Barcode NVARCHAR(MAX) ,
  @Barcodes Items.td_Barcode READONLY ,
  @MainCategoryID UNIQUEIDENTIFIER ,
  @SubCategoryID UNIQUEIDENTIFIER ,
  @BrandID UNIQUEIDENTIFIER ,
  @InList BIT ,
  @QtyToReorder INT ,
  @QtySalesAlert DECIMAL(18, 2) ,
  @IsExpiryDate BIT ,
  @LifeSpanDays INT ,
  @NoticeDaysBeforeExpiryDate INT ,
  @NetWeight DECIMAL(18, 2) ,
  @GrossWeight DECIMAL(18, 2) ,
  @SizeIs NVARCHAR(MAX) ,
  @ColorIs NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Purchase FLOAT ,
  @CurrencyIDSell UNIQUEIDENTIFIER ,
  @Sell FLOAT ,
  @StandardSalePrice BIT ,
  @Discount DECIMAL(4, 2) ,
  @TaxRate DECIMAL(4, 2) ,
  @ScaleType TINYINT ,
  @PLUNumber NVARCHAR(MAX) ,
  @TypeIs TINYINT ,
  @ReplenishmentSystem TINYINT ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @ImageThumbnail IMAGE ,
  @IsSyncImage BIT ,
  @DescriptionAR NVARCHAR(MAX) ,
  @DescriptionEN NVARCHAR(MAX) ,
  @DescriptionSearch NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @OpticType TINYINT ,
  @SpectacleLensesFocal NVARCHAR(MAX) ,
  @SpectacleLensesMaterial NVARCHAR(MAX) ,
  @SpectacleLensesUncoated BIT ,
  @SpectacleLensesSuperHardCoat BIT ,
  @SpectacleLensesAntiReflection BIT ,
  @SpectacleLensesUVProtection BIT ,
  @SpectacleLensesBlueFilterBlueControl BIT ,
  @SpectacleLensesPhotochromic BIT ,
  @SpectacleLensesBCPhotochromic BIT ,
  @SpectacleLensesPolariod BIT ,
  @SpectacleLensesTintedSolid NVARCHAR(MAX) ,
  @SpectacleLensesTintedGradient NVARCHAR(MAX) ,
  @SpectacleLensesTintedMirror NVARCHAR(MAX) ,
  @SpectacleLensesIndex NVARCHAR(MAX) ,
  @SpectacleLensesDiameter INT ,
  @SpectacleLensesBase INT ,
  @SpectacleLensesSphere DECIMAL(18, 2) ,
  @SpectacleLensesCylinder DECIMAL(18, 2) ,
  @SpectacleLensesAxis INT ,
  @ContactLensesBC DECIMAL(18, 2) ,
  @ContactLensesDIA DECIMAL(18, 2) ,
  @ContactLensesTransparency NVARCHAR(MAX) ,
  @ContactLensesColor NVARCHAR(MAX) ,
  @ContactLensesType NVARCHAR(MAX) ,
  @ContactLensesPeriod NVARCHAR(MAX) ,
  @ContactLensesSphere DECIMAL(18, 2) ,
  @ContactLensesCylinder DECIMAL(18, 2) ,
  @ContactLensesAxis INT ,
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

      DECLARE @return INT ,
        @CurrencyType TINYINT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @ExchangeRateSell DECIMAL(18, 2) ,
        @MainCategoryIDOld UNIQUEIDENTIFIER ,
        @InListOld BIT ,
        @QtyToReorderOld INT ,
        @WarehouseCount INT ,
        @PurchaseWithTax FLOAT ,
        @SearchIndex Alls.td_String;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @MainCategoryIDOld = s.MainCategoryID ,
              @QtyToReorderOld = s.QtyToReorder ,
              @InListOld = s.InList
      FROM    Items.t_ItemShared AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      SET @CurrencyType = [Currencys].[f_CurrencyGetTypeIs](@CurrencyID);
      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);
      SET @ExchangeRateSell = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyIDSell);

      SELECT  @WarehouseCount = COUNT(*)
      FROM    Company.t_WareHouse AS s;

      SET @PurchaseWithTax = Calculation.Rate(@Purchase, @TaxRate);
    
      INSERT  INTO @SearchIndex
              ( Name )
      VALUES  ( @Name );

      INSERT  INTO @SearchIndex
              ( Name
              )
      SELECT  s.Barcode
      FROM    @Barcodes AS s;

    END;

    BEGIN --Update item shared

      SET @return = 0;

      UPDATE  Items.t_ItemShared
      SET     Name = @Name ,
              NameInvoice = @NameInvoice ,
              Barcode = @Barcode ,
              MainCategoryID = @MainCategoryID ,
              MainCategory = Items.f_MainCategoryGetName(@MainCategoryID) ,
              SubCategoryID = @SubCategoryID ,
              SubCategory = Items.f_SubCategoryGetName(@SubCategoryID) ,
              BrandID = @BrandID ,
              Brand = Items.f_BrandGetName(@BrandID) ,
              InList = @InList ,
              QtyToReorder = @QtyToReorder ,
              QtySalesAlert = @QtySalesAlert ,
              IsExpiryDate = @IsExpiryDate ,
              LifeSpanDays = @LifeSpanDays ,
              NoticeDaysBeforeExpiryDate = @NoticeDaysBeforeExpiryDate ,
              NetWeight = @NetWeight ,
              GrossWeight = @GrossWeight ,
              SizeIs = @SizeIs ,
              ColorIs = @ColorIs ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              Purchase = @Purchase ,
              PurchaseF = Currencys.f_Format(@CurrencyID, @Purchase) ,
              PurchaseD = @Purchase / @ExchangeRate ,
              PurchaseLL = Currencys.f_ExchangeToLL(@CurrencyID, @Purchase, @Purchase / @ExchangeRate) ,
              PurchaseEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Purchase, @Purchase / @ExchangeRate) ,
              PurchaseWithTax = @PurchaseWithTax ,
              PurchaseWithTaxF = Currencys.f_Format(@CurrencyID, @PurchaseWithTax) ,
              PurchaseWithTaxD = @PurchaseWithTax / @ExchangeRate ,
              PurchaseWithTaxLL = Currencys.f_ExchangeToLL(@CurrencyID, @PurchaseWithTax, @PurchaseWithTax / @ExchangeRate) ,
              PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @PurchaseWithTax, @PurchaseWithTax / @ExchangeRate) ,
              SellCurrencyID = @CurrencyIDSell ,
              SellCurrency = Currencys.f_CurrencyGetName(@CurrencyIDSell) ,
              Sell = @Sell ,
              SellF = Currencys.f_Format(@CurrencyIDSell, @Sell) ,
              SellD = @Sell / @ExchangeRateSell ,
              SellLL = Currencys.f_ExchangeToLL(@CurrencyIDSell, @Sell, @Sell / @ExchangeRateSell) ,
              SellEuro = Currencys.f_ExchangeToEuro(@CurrencyIDSell, @Sell, @Sell / @ExchangeRateSell) ,
              SellWithTax = Calculation.Rate(@Sell, TaxRate) ,
              StandardSalePrice = @StandardSalePrice ,
              Discount = @Discount ,
              TaxRate = @TaxRate ,
              ScaleType = @ScaleType ,
              PLUNumber = @PLUNumber ,
              TypeIs = @TypeIs ,
              ReplenishmentSystem = @ReplenishmentSystem ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              ImageThumbnail = @ImageThumbnail ,
              ImageThumbnailFixed = 1 ,
              IsSyncImage = @IsSyncImage ,
              DescriptionAR = @DescriptionAR ,
              DescriptionEN = @DescriptionEN ,
              DescriptionSearch = @DescriptionSearch ,
              DescriptionIs = @DescriptionIs ,
              OpticType = @OpticType ,
              SpectacleLensesFocal = @SpectacleLensesFocal ,
              SpectacleLensesMaterial = @SpectacleLensesMaterial ,
              SpectacleLensesUncoated = @SpectacleLensesUncoated ,
              SpectacleLensesSuperHardCoat = @SpectacleLensesSuperHardCoat ,
              SpectacleLensesAntiReflection = @SpectacleLensesAntiReflection ,
              SpectacleLensesUVProtection = @SpectacleLensesUVProtection ,
              SpectacleLensesBlueFilterBlueControl = @SpectacleLensesBlueFilterBlueControl ,
              SpectacleLensesPhotochromic = @SpectacleLensesPhotochromic ,
              SpectacleLensesBCPhotochromic = @SpectacleLensesBCPhotochromic ,
              SpectacleLensesPolariod = @SpectacleLensesPolariod ,
              SpectacleLensesTintedSolid = @SpectacleLensesTintedSolid ,
              SpectacleLensesTintedGradient = @SpectacleLensesTintedGradient ,
              SpectacleLensesTintedMirror = @SpectacleLensesTintedMirror ,
              SpectacleLensesIndex = @SpectacleLensesIndex ,
              SpectacleLensesDiameter = @SpectacleLensesDiameter ,
              SpectacleLensesBase = @SpectacleLensesBase ,
              SpectacleLensesSphere = @SpectacleLensesSphere ,
              SpectacleLensesCylinder = @SpectacleLensesCylinder ,
              SpectacleLensesAxis = @SpectacleLensesAxis ,
              ContactLensesBC = @ContactLensesBC ,
              ContactLensesDIA = @ContactLensesDIA ,
              ContactLensesTransparency = @ContactLensesTransparency ,
              ContactLensesColor = @ContactLensesColor ,
              ContactLensesType = @ContactLensesType ,
              ContactLensesPeriod = @ContactLensesPeriod ,
              ContactLensesSphere = @ContactLensesSphere ,
              ContactLensesCylinder = @ContactLensesCylinder ,
              ContactLensesAxis = @ContactLensesAxis ,
              SearchIndex = Alls.f_ToSearchIndex(@SearchIndex)
      WHERE   ID = @ID;

    END;

    BEGIN --Update Base Unit

      UPDATE  Items.t_UnityItem
      SET     CurrencyID = @CurrencyIDSell ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyIDSell) ,
              Price = @Sell ,
              PriceF = Currencys.f_Format(@CurrencyIDSell, @Sell) ,
              PriceD = @Sell / @ExchangeRateSell ,
              PriceLL = Currencys.f_ExchangeToLL(@CurrencyIDSell, @Sell, @Sell / @ExchangeRateSell) ,
              PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyIDSell, @Sell, @Sell / @ExchangeRateSell) ,
              PriceWithTax = Calculation.Rate(@Sell, @TaxRate)
      WHERE   SharedID = @ID
              AND PrimaryIs = 1
              AND Qty = 1;

      UPDATE  Items.t_UnityItem
      SET     PriceWithTaxF = Currencys.f_Format(@CurrencyIDSell, PriceWithTax) ,
              PriceWithTaxD = PriceWithTax / @ExchangeRateSell ,
              PriceWithTaxLL = Currencys.f_ExchangeToLL(@CurrencyIDSell, PriceWithTax, PriceWithTax / @ExchangeRateSell) ,
              PriceWithTaxEuro = Currencys.f_ExchangeToEuro(@CurrencyIDSell, PriceWithTax, PriceWithTax / @ExchangeRateSell)
      WHERE   SharedID = @ID
              AND PrimaryIs = 1
              AND Qty = 1;

      UPDATE  Items.t_ItemShared
      SET     SellTotal = @Sell * QtyCurrent ,
              SellTotalF = Currencys.f_Format(@CurrencyIDSell, @Sell * QtyCurrent) ,
              SellWithTaxF = Currencys.f_Format(@CurrencyIDSell, SellWithTax) ,
              SellWithTaxD = SellWithTax / @ExchangeRateSell ,
              SellWithTaxLL = Currencys.f_ExchangeToLL(@CurrencyIDSell, SellWithTax, SellWithTax / @ExchangeRateSell) ,
              SellWithTaxEuro = Currencys.f_ExchangeToEuro(@CurrencyIDSell, SellWithTax, SellWithTax / @ExchangeRateSell) ,
              SellTotalWithTax = SellWithTax * QtyCurrent ,
              SellTotalWithTaxF = Currencys.f_Format(@CurrencyIDSell, SellWithTax * QtyCurrent)
      WHERE   ID = @ID;

      UPDATE  Items.t_ItemShared
      SET     SellTotalD = SellD * QtyCurrent ,
              SellTotalLL = SellLL * QtyCurrent ,
              SellTotalEuro = SellEuro * QtyCurrent ,
              SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
              SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
              SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
      WHERE   ID = @ID;

    END;

    IF @QtyToReorder <> @QtyToReorderOld
    BEGIN --Update items

      SET @QtyToReorder = @QtyToReorder / @WarehouseCount;

      UPDATE  Items.t_Item
      SET     QtyToReorder = @QtyToReorder
      WHERE   SharedID = @ID;

    END;

    BEGIN --Reinsert barcodes

      SET @return = -3;

      DELETE  FROM Items.t_ItemSharedBarCode
      WHERE   SharedID = @ID;

      INSERT  INTO Items.t_ItemSharedBarCode
              ( SharedID ,
                BarCode ,
                BarcodeNumber ,
                TypeIs
              )
      SELECT  @ID ,
              t.Barcode ,
              Alls.f_ToBigint(t.Barcode) ,
              t.TypeIs
      FROM    @Barcodes AS t;

    END;

    IF EXISTS ( SELECT TOP ( 1 ) --t_ItemSharedMaterial
                        s.ID
                FROM    Items.t_ItemSharedMaterial AS s
                WHERE   s.ItemSharedID = @ID )
    BEGIN
		  
      DECLARE @MaterialItemSharedFatherIDs AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      INSERT  @MaterialItemSharedFatherIDs
              ( ID
              )
      SELECT  s.ItemSharedFatherID
      FROM    Items.t_ItemSharedMaterial AS s
      WHERE   s.ItemSharedID = @ID;

      UPDATE  Items.t_ItemShared
      SET     Purchase = ( SELECT COALESCE(SUM(CASE s3.TypeIs
                                                 WHEN 0 THEN s1.PurchaseD * s.Qtys
                                                 WHEN 1 THEN s1.PurchaseLL * s.Qtys
                                                 ELSE s1.PurchaseEuro * s.Qtys
                                               END), 0)
                           FROM   Items.t_ItemSharedMaterial AS s
                           INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
                           INNER JOIN Items.t_ItemShared AS s2 ON s2.ID = s.ItemSharedFatherID
                           INNER JOIN Currencys.t_Currency AS s3 ON s3.ID = s2.CurrencyID
                           WHERE  s.ItemSharedFatherID = t_ItemShared.ID
                         )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @MaterialItemSharedFatherIDs AS s
                       WHERE  s.ID = t_ItemShared.ID );

      UPDATE  Items.t_ItemShared
      SET     PurchaseF = Currencys.f_Format(CurrencyID, Purchase) ,
              PurchaseD = Purchase / @ExchangeRate ,
              PurchaseLL = Currencys.f_ExchangeToLL(CurrencyID, Purchase, Purchase / @ExchangeRate) ,
              PurchaseEuro = Currencys.f_ExchangeToEuro(CurrencyID, Purchase, Purchase / @ExchangeRate) ,
              PurchaseWithTax = Calculation.Rate(Purchase, TaxRate)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @MaterialItemSharedFatherIDs AS s
                       WHERE  s.ID = t_ItemShared.ID );

      UPDATE  Items.t_ItemShared
      SET     PurchaseWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax) ,
              PurchaseWithTaxD = PurchaseWithTax / @ExchangeRate ,
              PurchaseWithTaxLL = Currencys.f_ExchangeToLL(CurrencyID, PurchaseWithTax, PurchaseWithTax / @ExchangeRate) ,
              PurchaseWithTaxEuro = Currencys.f_ExchangeToEuro(CurrencyID, PurchaseWithTax, PurchaseWithTax / @ExchangeRate)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @MaterialItemSharedFatherIDs AS s
                       WHERE  s.ID = t_ItemShared.ID );

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
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
              PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent
      WHERE   ID = @ID;

    END;

    IF @MainCategoryIDOld <> @MainCategoryID
    BEGIN --Rebuilding statistics t_MainCategory

      UPDATE  Items.t_MainCategory
      SET     ItemC += 1 ,
              ItemInListCount = ( SELECT  COUNT(*) AS Total
                                  FROM    Items.t_ItemShared AS t
                                  WHERE   t.MainCategoryID = t_MainCategory.ID
                                          AND t.InList = 1
                                )
      WHERE   ID = @MainCategoryID;

      UPDATE  Items.t_MainCategory
      SET     ItemC -= 1 ,
              ItemInListCount = ( SELECT  COUNT(*) AS Total
                                  FROM    Items.t_ItemShared AS t
                                  WHERE   t.MainCategoryID = t_MainCategory.ID
                                          AND t.InList = 1
                                )
      WHERE   ID = @MainCategoryIDOld;

    END;

    IF @InListOld <> @InList
    BEGIN --Rebuilding statistics t_MainCategory

      UPDATE  Items.t_MainCategory
      SET     ItemInListCount = ( SELECT  COUNT(*) AS Total
                                  FROM    Items.t_ItemShared AS t
                                  WHERE   t.MainCategoryID = t_MainCategory.ID
                                          AND t.InList = 1
                                )
      WHERE   ID IN ( @MainCategoryID, @MainCategoryIDOld );


    END;

    BEGIN -- SearchText
    	  
      UPDATE  Items.t_ItemShared
      SET     SearchText = Items.f_ItemSharedSearchTextGet(ID)
      WHERE   ID = @ID;

      UPDATE  Items.t_Item
      SET     SearchText = Items.f_ItemSearchTextGet(ID)
      WHERE   SharedID = @ID;
	   
      UPDATE  Items.t_UnityItem
      SET     SearchText = Items.f_UnityItemSearchTextGet(ID)
      WHERE   SharedID = @ID;

    END;

    BEGIN --Insert event

      SET @return = -1;

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
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

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
