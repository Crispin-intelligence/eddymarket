SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedInsert]
  @Name NVARCHAR(MAX) ,
  @NameInvoice NVARCHAR(MAX) ,
  @Barcode NVARCHAR(MAX) ,
  @Barcodes Items.td_Barcode READONLY ,
  @MainCategoryID UNIQUEIDENTIFIER ,
  @SubCategoryID UNIQUEIDENTIFIER ,
  @BrandID UNIQUEIDENTIFIER ,
  @InList BIT ,
  @CurrentQty DECIMAL(18, 2) ,
  @QtyToReorder INT ,
  @QtySalesAlert DECIMAL(18, 2) ,
  @IsSerial BIT ,
  @IsExpiryDate BIT ,
  @LifeSpanDays INT ,
  @NoticeDaysBeforeExpiryDate INT ,
  @NetWeight DECIMAL(18, 2) ,
  @GrossWeight DECIMAL(18, 2) ,
  @SizeIs NVARCHAR(MAX) ,
  @ColorIs NVARCHAR(MAX) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Purchase FLOAT ,
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
  @Unities Items.td_Unity READONLY ,
  @Material Items.tt_ItemSharedMaterial READONLY ,
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

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @Return INT ,
        @Sell FLOAT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @SellCurrencyID UNIQUEIDENTIFIER ,
        @SellExchangeRate DECIMAL(18, 2) ,
        @WarehouseCount INT ,
        @PurchaseWithTax FLOAT ,
        @SellWithTax FLOAT ,
        @SearchIndex Alls.td_String;

    END;

    BEGIN --Set info

      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);

      SELECT  @WarehouseCount = COUNT(*)
      FROM    Company.t_WareHouse AS s;

      SELECT TOP ( 1 )
              @SellCurrencyID = s.CurrencyID ,
              @Sell = s.Price
      FROM    @Unities AS s
      WHERE   s.IsPrimary = 1
      ORDER BY s.IsPrimary;

      SET @SellExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@SellCurrencyID);

      SET @PurchaseWithTax = Calculation.Rate(@Purchase, @TaxRate);

      SET @SellWithTax = Calculation.Rate(@Sell, @TaxRate);

      INSERT  INTO @SearchIndex
              ( Name )
      VALUES  ( @Name );

      INSERT  INTO @SearchIndex
              ( Name
              )
      SELECT  s.Barcode
      FROM    @Barcodes AS s;

    END;

    BEGIN --Insert item shared

      SET @Return = 0;

      INSERT  INTO Items.t_ItemShared
              ( ID ,
                Name ,
                NameInvoice ,
                Barcode ,
                MainCategoryID ,
                MainCategory ,
                SubCategoryID ,
                SubCategory ,
                BrandID ,
                Brand ,
                InList ,
                QtyToReorder ,
                QtySalesAlert ,
                IsSerial ,
                IsExpiryDate ,
                LifeSpanDays ,
                NoticeDaysBeforeExpiryDate ,
                NetWeight ,
                GrossWeight ,
                SizeIs ,
                ColorIs ,
                CurrencyID ,
                Currency ,
                Purchase ,
                PurchaseF ,
                PurchaseD ,
                PurchaseLL ,
                PurchaseEuro ,
                PurchaseTotalF ,
                PurchaseWithTax ,
                PurchaseWithTaxF ,
                PurchaseWithTaxD ,
                PurchaseWithTaxLL ,
                PurchaseWithTaxEuro ,
                PurchaseTotalWithTaxF ,
                SellCurrencyID ,
                SellCurrency ,
                Sell ,
                SellF ,
                SellD ,
                SellLL ,
                SellEuro ,
                SellTotalF ,
                SellWithTax ,
                SellWithTaxF ,
                SellWithTaxD ,
                SellWithTaxLL ,
                SellWithTaxEuro ,
                SellTotalWithTaxF ,
                StandardSalePrice ,
                Discount ,
                TaxRate ,
                ScaleType ,
                PLUNumber ,
                TypeIs ,
                ReplenishmentSystem ,
                ImageIs ,
                ImagePath ,
                IsSyncImage ,
                ImageThumbnail ,
                ImageThumbnailFixed ,
                DescriptionAR ,
                DescriptionEN ,
                DescriptionSearch ,
                DescriptionIs ,
                OpticType ,
                SpectacleLensesFocal ,
                SpectacleLensesMaterial ,
                SpectacleLensesUncoated ,
                SpectacleLensesSuperHardCoat ,
                SpectacleLensesAntiReflection ,
                SpectacleLensesUVProtection ,
                SpectacleLensesBlueFilterBlueControl ,
                SpectacleLensesPhotochromic ,
                SpectacleLensesBCPhotochromic ,
                SpectacleLensesPolariod ,
                SpectacleLensesTintedSolid ,
                SpectacleLensesTintedGradient ,
                SpectacleLensesTintedMirror ,
                SpectacleLensesIndex ,
                SpectacleLensesDiameter ,
                SpectacleLensesBase ,
                SpectacleLensesSphere ,
                SpectacleLensesCylinder ,
                SpectacleLensesAxis ,
                ContactLensesBC ,
                ContactLensesDIA ,
                ContactLensesTransparency ,
                ContactLensesColor ,
                ContactLensesType ,
                ContactLensesPeriod ,
                ContactLensesSphere ,
                ContactLensesCylinder ,
                ContactLensesAxis ,
                SearchIndex
              )
      VALUES  ( @ID ,
                @Name ,
                @NameInvoice ,
                @Barcode ,
                @MainCategoryID ,
                Items.f_MainCategoryGetName(@MainCategoryID) ,
                @SubCategoryID ,
                Items.f_SubCategoryGetName(@SubCategoryID) ,
                @BrandID ,
                Items.f_BrandGetName(@BrandID) ,
                @InList ,
                @QtyToReorder ,
                @QtySalesAlert ,
                @IsSerial ,
                @IsExpiryDate ,
                @LifeSpanDays ,
                @NoticeDaysBeforeExpiryDate ,
                @NetWeight ,
                @GrossWeight ,
                @SizeIs ,
                @ColorIs ,
                @CurrencyID ,
                Currencys.f_CurrencyGetName(@CurrencyID) ,
                @Purchase ,
                Currencys.f_Format(@CurrencyID, @Purchase) ,
                @Purchase / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @Purchase, @Purchase / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @Purchase, @Purchase / @ExchangeRate) ,
                Currencys.f_Format(@CurrencyID, 0) ,
                @PurchaseWithTax ,
                Currencys.f_Format(@CurrencyID, @PurchaseWithTax) ,
                @PurchaseWithTax / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @PurchaseWithTax, @PurchaseWithTax / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @PurchaseWithTax, @PurchaseWithTax / @ExchangeRate) ,
                Currencys.f_Format(@CurrencyID, 0) ,
                @SellCurrencyID ,
                Currencys.f_CurrencyGetName(@SellCurrencyID) ,
                @Sell ,
                Currencys.f_Format(@SellCurrencyID, @Sell) ,
                @Sell / @SellExchangeRate ,
                Currencys.f_ExchangeToLL(@SellCurrencyID, @Sell, @Sell / @SellExchangeRate) ,
                Currencys.f_ExchangeToEuro(@SellCurrencyID, @Sell, @Sell / @SellExchangeRate) ,
                Currencys.f_Format(@SellCurrencyID, 0) ,
                @SellWithTax ,
                Currencys.f_Format(@SellCurrencyID, @SellWithTax) ,
                @SellWithTax / @SellExchangeRate ,
                Currencys.f_ExchangeToLL(@SellCurrencyID, @SellWithTax, @SellWithTax / @SellExchangeRate) ,
                Currencys.f_ExchangeToEuro(@SellCurrencyID, @SellWithTax, @SellWithTax / @SellExchangeRate) ,
                Currencys.f_Format(@SellCurrencyID, 0) ,
                @StandardSalePrice ,
                @Discount ,
                @TaxRate ,
                @ScaleType ,
                @PLUNumber ,
                @TypeIs ,
                @ReplenishmentSystem ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @ImageThumbnail ,
                1 ,
                @DescriptionAR ,
                @DescriptionEN ,
                @DescriptionSearch ,
                @DescriptionIs ,
                @OpticType ,
                @SpectacleLensesFocal ,
                @SpectacleLensesMaterial ,
                @SpectacleLensesUncoated ,
                @SpectacleLensesSuperHardCoat ,
                @SpectacleLensesAntiReflection ,
                @SpectacleLensesUVProtection ,
                @SpectacleLensesBlueFilterBlueControl ,
                @SpectacleLensesPhotochromic ,
                @SpectacleLensesBCPhotochromic ,
                @SpectacleLensesPolariod ,
                @SpectacleLensesTintedSolid ,
                @SpectacleLensesTintedGradient ,
                @SpectacleLensesTintedMirror ,
                @SpectacleLensesIndex ,
                @SpectacleLensesDiameter ,
                @SpectacleLensesBase ,
                @SpectacleLensesSphere ,
                @SpectacleLensesCylinder ,
                @SpectacleLensesAxis ,
                @ContactLensesBC ,
                @ContactLensesDIA ,
                @ContactLensesTransparency ,
                @ContactLensesColor ,
                @ContactLensesType ,
                @ContactLensesPeriod ,
                @ContactLensesSphere ,
                @ContactLensesCylinder ,
                @ContactLensesAxis ,
                Alls.f_ToSearchIndex(@SearchIndex)
              );

    END;

    BEGIN --Insert barcodes

      SET @Return = -3;

      INSERT  INTO Items.t_ItemSharedBarCode
              ( SharedID ,
                BarCode ,
                BarcodeNumber ,
                TypeIs
              )
      SELECT DISTINCT
              @ID ,
              t.Barcode ,
              Alls.f_ToBigint(t.Barcode) ,
              t.TypeIs
      FROM    @Barcodes AS t;

    END;

    BEGIN --Insert items

      SET @QtyToReorder = @QtyToReorder / @WarehouseCount;

      INSERT  INTO Items.t_Item
              ( SharedID ,
                WareHouseID ,
                WareHouse ,
                PlaceID ,
                Place ,
                QtyToReorder
              )
      SELECT  @ID ,
              t.ID ,
              t.Name ,
              Company.f_PlaceGetFirstID1(t.ID) ,
              Company.f_PlaceGetFirstName1(t.ID) ,
              @QtyToReorder
      FROM    Company.t_WareHouse AS t;

    END;

    BEGIN --Insert unities

      INSERT  INTO Items.t_UnityItem
              ( UnityID ,
                Unity ,
                SharedID ,
                Qty ,
                PrimaryIs ,
                Purchasing ,
                Sold ,
                Inventory ,
                UseInTransfer ,
                BarCode ,
                CurrencyID ,
                Currency ,
                Price ,
                PriceF ,
                PriceD ,
                PriceLL ,
                PriceEuro ,
                PriceWithTax ,
                PriceWithTaxF ,
                PriceWithTaxD ,
                PriceWithTaxLL ,
                PriceWithTaxEuro ,
                LowestPrice ,
                LowestPriceF ,
                LowestPriceD
              )
      SELECT  t.UnityID ,
              Items.f_UnityGetName(t.UnityID) ,
              @ID ,
              t.Qty ,
              t.IsPrimary ,
              t.Purchasing ,
              t.Sold ,
              t.Inventory ,
              t.UseInTransfer ,
              t.BarCode ,
              t.CurrencyID ,
              t1.Name ,
              t.Price ,
              Currencys.f_Format(t.CurrencyID, t.Price) ,
              t.Price / t1.ExchangeRate ,
              Currencys.f_ExchangeToLL(t.CurrencyID, t.Price, t.Price / t1.ExchangeRate) ,
              Currencys.f_ExchangeToEuro(t.CurrencyID, t.Price, t.Price / t1.ExchangeRate) ,
              Calculation.Rate(t.Price, @TaxRate) ,
              Currencys.f_Format(t.CurrencyID, Calculation.Rate(t.Price, @TaxRate)) ,
              Calculation.Rate(t.Price, @TaxRate) / t1.ExchangeRate ,
              Currencys.f_ExchangeToLL(t.CurrencyID, Calculation.Rate(t.Price, @TaxRate), Calculation.Rate(t.Price, @TaxRate) / t1.ExchangeRate) ,
              Currencys.f_ExchangeToEuro(t.CurrencyID, Calculation.Rate(t.Price, @TaxRate), Calculation.Rate(t.Price, @TaxRate) / t1.ExchangeRate) ,
              t.LowestPrice ,
              Currencys.f_Format(t.CurrencyID, t.LowestPrice) ,
              t.LowestPrice / t1.ExchangeRate
      FROM    @Unities AS t
      LEFT JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID;

    END;

    BEGIN --Insert t_ItemSharedMaterial

      INSERT  INTO Items.t_ItemSharedMaterial
              ( ID ,
                ItemSharedFatherID ,
                ItemSharedID ,
                ItemUnityID ,
                Qty ,
                QtyWithUnity ,
                Qtys ,
                DescriptionIs ,
                CreateByID ,
                CreateBy
              )
      SELECT  t.ID ,
              @ID ,
              t.ItemSharedID ,
              t.ItemUnityID ,
              t.Qty ,
              FORMAT(t.Qty, '#,##0.####') + ' ' + t2.Name ,
              t.Qtys ,
              t.DescriptionIs ,
              @UserID ,
              Users.f_UserGetName(@UserID)
      FROM    @Material AS t
      LEFT JOIN Items.t_UnityItem AS t1 ON t1.ID = t.ItemUnityID
      LEFT JOIN Items.t_Unity AS t2 ON t2.ID = t1.UnityID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
                                       FOR
                                         XML PATH('')
                                       )) ,
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
              MaterialsNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                               FROM   @Material AS t
                                               LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                             FOR
                                               XML PATH('')
                                             )) ,
              MaterialsCounts = ( SELECT  COUNT(t.ID)
                                  FROM    @Material AS t
                                ) ,
              PlacesNames = Alls.f_FixXML(( SELECT  N', ' + t.Place AS [text()]
                                            FROM    Items.t_Item AS t
                                            WHERE   t.SharedID = t_ItemShared.ID
                                          FOR
                                            XML PATH('')
                                          ))
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics t_MainCategory

      UPDATE  Items.t_MainCategory
      SET     ItemC += 1 ,
              ItemInListCount += IIF(@InList = 1, 1, 0)
      WHERE   ID = @MainCategoryID;

    END;

    IF @CurrentQty > 0
      AND @WarehouseCount = 1
      AND @IsSerial = 0
    BEGIN

      BEGIN --Declare
     
        DECLARE @BeginningInventoryQuantityID UNIQUEIDENTIFIER ,
          @BeginningInventoryQuantityRef BIGINT ,
          @ItemID UNIQUEIDENTIFIER ,
          @ItemUnityID UNIQUEIDENTIFIER ,
          @PurchaseTotal FLOAT;     
     
      END;

      BEGIN --Set info

        SELECT  @BeginningInventoryQuantityRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Items.t_BeginningInventoryQuantity AS s;

        SELECT TOP ( 1 )
                @ItemID = s.ID
        FROM    Items.t_Item AS s
        WHERE   s.SharedID = @ID;

        SELECT TOP ( 1 )
                @ItemUnityID = s.ID
        FROM    Items.t_UnityItem AS s
        WHERE   s.SharedID = @ID
                AND s.PrimaryIs = 1
                AND s.Qty = 1;

        SET @PurchaseTotal = @Purchase * @CurrentQty;

      END;

      BEGIN --Insert

        INSERT  INTO Items.t_BeginningInventoryQuantity
                ( Ref ,
                  RefF ,
                  CurrencyID ,
                  Currency ,
                  ExchangeRate ,
                  Total ,
                  TotalF ,
                  TotalD ,
                  TotalLL ,
                  TotalEuro ,
                  Qtys ,
                  ItemsNames
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @BeginningInventoryQuantityRef ,
                  FORMAT(@BeginningInventoryQuantityRef, 'n0') ,
                  @CurrencyID ,
                  Currencys.f_CurrencyGetName(@CurrencyID) ,
                  @ExchangeRate ,
                  @Purchase * @CurrentQty ,
                  Currencys.f_Format(@CurrencyID, @PurchaseTotal) ,
                  @PurchaseTotal / @ExchangeRate ,
                  Currencys.f_ExchangeToLL(@CurrencyID, @PurchaseTotal, @PurchaseTotal / @ExchangeRate) ,
                  Currencys.f_ExchangeToEuro(@CurrencyID, @PurchaseTotal, @PurchaseTotal / @ExchangeRate) ,
                  @CurrentQty ,
                  @Name
                );

        SET @BeginningInventoryQuantityID = ( SELECT TOP ( 1 )
                                                      s.ID
                                              FROM    @IDs AS s
                                              ORDER BY s.ID
                                            );

      END;

      BEGIN --Insert detail

        INSERT  INTO Items.t_BeginningInventoryQuantityDetail
                ( BeginningInventoryQuantityID ,
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
                  Total ,
                  TotalF ,
                  TotalD ,
                  TotalLL ,
                  TotalEuro ,
                  SortAt
                )
        SELECT TOP ( 1 )
                @BeginningInventoryQuantityID ,
                @ID ,
                @ItemID ,
                @ItemUnityID ,
                @CurrentQty ,
                FORMAT(@CurrentQty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(@ItemUnityID) ,
                @CurrentQty ,
                @Purchase ,
                Currencys.f_Format(@CurrencyID, @Purchase) ,
                @Purchase / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @Purchase, @Purchase / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @Purchase, @Purchase / @ExchangeRate) ,
                @PurchaseTotal ,
                Currencys.f_Format(@CurrencyID, @PurchaseTotal) ,
                @PurchaseTotal / @ExchangeRate ,
                Currencys.f_ExchangeToLL(@CurrencyID, @PurchaseTotal, @PurchaseTotal / @ExchangeRate) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @PurchaseTotal, @PurchaseTotal / @ExchangeRate) ,
                1
        FROM    Items.t_Item AS s
        WHERE   s.SharedID = @ID;

      END;

      BEGIN --Fix item qty
		
        UPDATE  Items.t_Item
        SET     QtyCurrent += @CurrentQty
        WHERE   ID = @ItemID;

        UPDATE  Items.t_ItemShared
        SET     QtyCurrent += @CurrentQty
        WHERE   ID = @ID;

      END;

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

    SELECT  @Return;

  END CATCH;

END;





GO
