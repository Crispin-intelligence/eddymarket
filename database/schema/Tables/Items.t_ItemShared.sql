CREATE TABLE [Items].[t_ItemShared]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemShared_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_tbl_ItemsShared_ItemSharedName] DEFAULT (''),
[NameInvoice] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_NameInvoice] DEFAULT (''),
[Barcode] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_ItemsSharedName1] DEFAULT (''),
[Barcodes] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_Barcodes] DEFAULT (''),
[MainCategoryID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemShared_MainCategoryID] DEFAULT ([items].[f_MainCategoryGetFirstID]()),
[MainCategory] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_MainCategory] DEFAULT ([items].[f_MainCategoryGetFirstName]()),
[SubCategoryID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemShared_SubCategoryID] DEFAULT ([items].[f_SubCategoryGetFirstID]()),
[SubCategory] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SubCategory] DEFAULT ([items].[f_SubCategoryGetFirstName]()),
[BrandID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemShared_BrandID] DEFAULT ([items].[f_BrandGetFirstID]()),
[Brand] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_Brand] DEFAULT ([items].[f_BrandGetFirstName]()),
[InList] [bit] NOT NULL CONSTRAINT [DF_t_ItemsShared_ItemsSharedInList] DEFAULT ((0)),
[QtyCurrent] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemsShared_CurrentQty] DEFAULT ((0)),
[QtyCurrentByUnit] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_QtyCurrentByUnit] DEFAULT (''),
[QtyToReorder] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_QtyToReorder] DEFAULT ((0)),
[QtySalesAlert] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_QtySalesAlert] DEFAULT ((0)),
[IsSerial] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_IsSerial] DEFAULT ((0)),
[IsExpiryDate] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_IsExpiryDate] DEFAULT ((0)),
[LifeSpanDays] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_LifeSpanDays] DEFAULT ((0)),
[NoticeDaysBeforeExpiryDate] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_NoticeDaysBeforeExpiryDate] DEFAULT ((0)),
[NetWeight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_NetWeight] DEFAULT ((0.0)),
[GrossWeight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_GrossWeight] DEFAULT ((0.0)),
[SizeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_ItemsSharedNote1] DEFAULT (''),
[ColorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ColorIs] DEFAULT (''),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemShared_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Purchase] [float] NOT NULL CONSTRAINT [DF_t_ItemsShared_Purchase] DEFAULT ((0)),
[PurchaseF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_PurchaseF] DEFAULT (''),
[PurchaseD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseD] DEFAULT ((0)),
[PurchaseLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseLL] DEFAULT ((0)),
[PurchaseEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseEuro] DEFAULT ((0)),
[PurchaseTotal] [float] NOT NULL CONSTRAINT [DF_t_ItemsShared_PurchaseTotal] DEFAULT ((0)),
[PurchaseTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_PurchaseTotalF] DEFAULT (''),
[PurchaseTotalD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalD] DEFAULT ((0)),
[PurchaseTotalLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalLL] DEFAULT ((0)),
[PurchaseTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalEuro] DEFAULT ((0)),
[PurchaseWithTax] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseWithTax] DEFAULT ((0)),
[PurchaseWithTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseWithTaxF] DEFAULT ('0'),
[PurchaseWithTaxD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseWithTaxD] DEFAULT ((0)),
[PurchaseWithTaxLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseWithTaxLL] DEFAULT ((0)),
[PurchaseWithTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseWithTaxEuro] DEFAULT ((0)),
[PurchaseTotalWithTax] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalWithTax] DEFAULT ((0)),
[PurchaseTotalWithTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalWithTaxF] DEFAULT ('0'),
[PurchaseTotalWithTaxD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalWithTaxD] DEFAULT ((0)),
[PurchaseTotalWithTaxLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalWithTaxLL] DEFAULT ((0)),
[PurchaseTotalWithTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_PurchaseTotalWithTaxEuro] DEFAULT ((0)),
[SellCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemShared_SellCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[SellCurrency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SellCurrency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Sell] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_Sell] DEFAULT ((0)),
[SellF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SellF] DEFAULT ('0'),
[SellD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellD] DEFAULT ((0)),
[SellLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellLL] DEFAULT ((0)),
[SellEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellEuro] DEFAULT ((0)),
[SellTotal] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotal] DEFAULT ((0)),
[SellTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalF] DEFAULT ('0'),
[SellTotalD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalD] DEFAULT ((0)),
[SellTotalLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalLL] DEFAULT ((0)),
[SellTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalEuro] DEFAULT ((0)),
[SellWithTax] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellWithTax] DEFAULT ((0)),
[SellWithTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SellWithTaxF] DEFAULT ('0'),
[SellWithTaxD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellWithTaxD] DEFAULT ((0)),
[SellWithTaxLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellWithTaxLL] DEFAULT ((0)),
[SellWithTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellWithTaxEuro] DEFAULT ((0)),
[SellTotalWithTax] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalWithTax] DEFAULT ((0)),
[SellTotalWithTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalWithTaxF] DEFAULT ('0'),
[SellTotalWithTaxD] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalWithTaxD] DEFAULT ((0)),
[SellTotalWithTaxLL] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalWithTaxLL] DEFAULT ((0)),
[SellTotalWithTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_ItemShared_SellTotalWithTaxEuro] DEFAULT ((0)),
[StandardSalePrice] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_StandardSalePrice] DEFAULT ((0)),
[Discount] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_ItemsShared_Discount] DEFAULT ((0)),
[DiscountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_DiscountF] DEFAULT (''),
[TaxRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_TaxRate] DEFAULT ((0.0)),
[ScaleType] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemShared_ScaleType] DEFAULT ((0)),
[PLUNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_PLUNumber] DEFAULT (''),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemShared_TypeIs] DEFAULT ((0)),
[ReplenishmentSystem] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemShared_ReplenishmentSystem] DEFAULT ((0)),
[MaterialsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_MaterialsNames] DEFAULT (''),
[MaterialsCounts] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_MaterialsCounts] DEFAULT ((0)),
[ImageIs] [image] NOT NULL CONSTRAINT [DF_t_ItemShared_ImageIs] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImagePath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ImagePath] DEFAULT (''),
[ImageThumbnail] [image] NOT NULL CONSTRAINT [DF_t_ItemShared_ImageThumbnail] DEFAULT ((0x89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000467414D410000B18F0BFC6105000000097048597300000B1300000B1301009A9C180000000D49444154185763F8FFFFFF7F0009FB03FD054345CA0000000049454E44AE4260820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)),
[ImageThumbnailFixed] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_ImageThumbnailFixed] DEFAULT ((0)),
[DescriptionAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_DescriptionAR] DEFAULT (''),
[DescriptionEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemsShared_DescriptionEN] DEFAULT (''),
[DescriptionSearch] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_DescriptionSearch] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_DescriptionIs] DEFAULT (''),
[UnityC] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_UnityC] DEFAULT ((0)),
[UnityNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_UnityNames] DEFAULT (''),
[VendorC] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_VendorC] DEFAULT ((0)),
[VendorNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_VendorNames] DEFAULT (''),
[PlacesNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_PlacesNames] DEFAULT (''),
[FileStorageC] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_FileStorageC] DEFAULT ((0)),
[AdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty1] DEFAULT (''),
[AdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty2] DEFAULT (''),
[AdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty3] DEFAULT (''),
[AdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty4] DEFAULT (''),
[AdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty5] DEFAULT (''),
[AdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty6] DEFAULT (''),
[AdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty7] DEFAULT (''),
[AdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty8] DEFAULT (''),
[AdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty9] DEFAULT (''),
[AdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_AdditionalProperty10] DEFAULT (''),
[DateLastSale] [date] NOT NULL CONSTRAINT [DF_t_ItemShared_DateLastSale] DEFAULT (getdate()),
[DaysLastSale] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_DaysLastSale] DEFAULT ((0)),
[MakeInactiveAfter] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_MakeInactiveAfter] DEFAULT ((0)),
[MakeInactiveAfterType] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemShared_MakeInactiveAfterType] DEFAULT ((2)),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemShared_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_WhyThisStatus] DEFAULT (''),
[OpticType] [tinyint] NOT NULL CONSTRAINT [DF_t_ItemShared_OpticType] DEFAULT ((0)),
[SpectacleLensesFocal] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesFocal] DEFAULT (' '),
[SpectacleLensesMaterial] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesMaterial] DEFAULT (' '),
[SpectacleLensesUncoated] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesUncoated] DEFAULT ((1)),
[SpectacleLensesSuperHardCoat] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesSuperHardCoat] DEFAULT ((0)),
[SpectacleLensesAntiReflection] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesAntiReflection] DEFAULT ((1)),
[SpectacleLensesUVProtection] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesUVProtection] DEFAULT ((1)),
[SpectacleLensesBlueFilterBlueControl] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesBlueFilterBlueControl] DEFAULT ((1)),
[SpectacleLensesPhotochromic] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesPhotochromic] DEFAULT ((1)),
[SpectacleLensesBCPhotochromic] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesBCPhotochromic] DEFAULT ((1)),
[SpectacleLensesPolariod] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesPolariod] DEFAULT ((1)),
[SpectacleLensesTintedSolid] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesTintedSolid] DEFAULT (' '),
[SpectacleLensesTintedGradient] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesTintedGradient] DEFAULT (' '),
[SpectacleLensesTintedMirror] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesTintedMirror] DEFAULT (' '),
[SpectacleLensesIndex] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesIndex] DEFAULT ('1.499'),
[SpectacleLensesDiameter] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesDiameter] DEFAULT ((0)),
[SpectacleLensesBase] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesBase] DEFAULT ((0)),
[SpectacleLensesSphere] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesSphere] DEFAULT ((0)),
[SpectacleLensesCylinder] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesCylinder] DEFAULT ((0)),
[SpectacleLensesAxis] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_SpectacleLensesAxis] DEFAULT ((0)),
[ContactLensesBC] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesBC] DEFAULT ((0)),
[ContactLensesDIA] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesDIA] DEFAULT ((0)),
[ContactLensesTransparency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesTransparency] DEFAULT ('Transparent'),
[ContactLensesColor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesColor] DEFAULT (''),
[ContactLensesType] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesType] DEFAULT ('Plano'),
[ContactLensesPeriod] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesPeriod] DEFAULT ('Daily'),
[ContactLensesSphere] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesSphere] DEFAULT ((0)),
[ContactLensesCylinder] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesCylinder] DEFAULT ((0)),
[ContactLensesAxis] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_ContactLensesAxis] DEFAULT ((0)),
[ProfitPartnersCount] [int] NOT NULL CONSTRAINT [DF_t_ItemShared_ProfitPartnersCount] DEFAULT ((0)),
[ProfitPartners] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_ProfitPartners] DEFAULT (''),
[OrderBy] [bigint] NOT NULL CONSTRAINT [DF_t_ItemShared_OrderBy] DEFAULT ((0)),
[SearchIndex] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SearchIndex] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemShared_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemShared_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_IsSync] DEFAULT ((0)),
[IsSyncImage] [bit] NOT NULL CONSTRAINT [DF_t_ItemShared_IsSyncImage] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemsShared_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemShared] ON [Items].[t_ItemShared]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemShared
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemShared.ID );

  END;

  BEGIN --DECLARE

    DECLARE @IDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

  END;

  BEGIN --Set info

    INSERT  INTO @IDs
            ( ID )
    SELECT  s.ID
    FROM    Inserted AS s;

  END;

  IF UPDATE(QtyCurrent) --Update QtyCurrent
  BEGIN

    BEGIN --Fix data

      UPDATE  Items.t_ItemShared
      SET     QtyCurrentByUnit = Alls.f_FixXML(( SELECT DISTINCT
                                                        ', ' + FORMAT(t_ItemShared.QtyCurrent / t.Qty, '#,##0.##') + N' ' + t1.Name AS [text()]
                                                 FROM   Items.t_UnityItem AS t
                                                 LEFT JOIN Items.t_Unity AS t1 ON t1.ID = t.UnityID
                                                 WHERE  t.SharedID = t_ItemShared.ID
                                                        AND t.Qty > 1
                                               FOR
                                                 XML PATH('')
                                               ))
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              t.ID
                       FROM   @IDs AS t
                       WHERE  t.ID = t_ItemShared.ID );

    END;

    BEGIN; --Fix t_UnityItem

      WITH  o AS ( SELECT s.Qty ,
                          s.QtyCurrent ,
                          s1.QtyCurrent AS QtyCurrent_
                   FROM   Items.t_UnityItem AS s
                   LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.SharedID
                   WHERE  EXISTS ( SELECT TOP ( 1 )
                                          t.ID
                                   FROM   @IDs AS t
                                   WHERE  t.ID = s.SharedID )
                 )
        UPDATE  o
        SET     o.QtyCurrent = o.QtyCurrent_ / o.Qty;

    END;

            --    BEGIN --GoldenClick

            --        MERGE GoldenClick.dbo.t_ItemQtyFlexiBills AS t
            --        USING Inserted AS s
            --        ON s.ID = t.ID
            --        WHEN NOT MATCHED BY TARGET THEN
            --            INSERT ( ID, Barcode, Qty )
            --            VALUES ( s.ID ,
            --                     s.Barcode ,
            --                     s.QtyCurrent
            --                   )
            --        WHEN MATCHED THEN
            --            UPDATE SET t.Barcode = s.Barcode ,
            --                       t.Qty = s.QtyCurrent;

            --        UPDATE  GoldenClick.dbo.t_liveVersion
            --        SET     ItemQtyFlexiBills = NEWID();

            --    END;

  END;

  IF UPDATE(Purchase)
    OR UPDATE(PurchaseWithTax)
    OR UPDATE(CurrencyID)
    OR UPDATE(Currency)
    OR EXISTS ( SELECT  COUNT(*)
                FROM    Inserted ) --Update QtyCurrent
  BEGIN

    BEGIN; --Fix t_UnityItem

      WITH  o AS ( SELECT s.Qty ,
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
                          s1.CurrencyID AS CurrencyIDCost_ ,
                          s1.Currency AS CurrencyCost_ ,
                          s1.Purchase AS Cost_ ,
                          s1.PurchaseD AS CostD_ ,
                          s1.PurchaseLL AS CostLL_ ,
                          s1.PurchaseEuro AS CostEuro_ ,
                          s1.PurchaseWithTax AS CostWithTax_ ,
                          s1.PurchaseWithTaxD AS CostWithTaxD_ ,
                          s1.PurchaseWithTaxLL AS CostWithTaxLL_ ,
                          s1.PurchaseWithTaxEuro AS CostWithTaxEuro_
                   FROM   Items.t_UnityItem AS s
                   LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.SharedID
                   WHERE  EXISTS ( SELECT TOP ( 1 )
                                          t.ID
                                   FROM   @IDs AS t
                                   WHERE  t.ID = s.SharedID )
                 )
        UPDATE  o
        SET     o.CurrencyIDCost = o.CurrencyIDCost_ ,
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
                o.CostWithTaxEuro = o.CostWithTaxEuro_ * o.Qty;

    END;

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            1 ,
            'itemShared'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            1 ,
            'itemShared'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_ItemShared] ADD CONSTRAINT [PK_t_ItemShared] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_ItemShared_Barcode] ON [Items].[t_ItemShared] ([Barcode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_ItemSharedSerial] ON [Items].[t_ItemShared] ([IsSerial]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemShared] ADD CONSTRAINT [BrandKeyItemShared] FOREIGN KEY ([BrandID]) REFERENCES [Items].[t_Brand] ([ID])
GO
ALTER TABLE [Items].[t_ItemShared] ADD CONSTRAINT [CurrencyKeyItemShared] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Items].[t_ItemShared] ADD CONSTRAINT [MainCategoryKeyItemShared] FOREIGN KEY ([MainCategoryID]) REFERENCES [Items].[t_MainCategory] ([ID])
GO
ALTER TABLE [Items].[t_ItemShared] ADD CONSTRAINT [SellCurrencyKeyItemShared] FOREIGN KEY ([SellCurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Items].[t_ItemShared] ADD CONSTRAINT [SubCategoryKeyItemShared] FOREIGN KEY ([SubCategoryID]) REFERENCES [Items].[t_SubCategory] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Daily
Monthly
Yearly', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'ContactLensesPeriod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transparent
Colored', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'ContactLensesTransparency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Plano
Spherical
Toric
Pupil', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'ContactLensesType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year = 0
Month = 1
Day = 2', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'MakeInactiveAfterType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal =0
Spectacle Lenses = 1
Contact Lenses = 2', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'OpticType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'purchase = 0
production = 1
assembly = 2
defragmentation = 3
services = 4', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'ReplenishmentSystem'
GO
EXEC sp_addextendedproperty N'MS_Description', N'none = 0
price = 1
weight = 2', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'ScaleType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Plano
Single
Bifocal
Progressive
 ', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'SpectacleLensesFocal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1.499
1.53
1.56
1.59
1.61
1.67
1.74', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'SpectacleLensesIndex'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CR-39
Mid & High Index
Trivex
Polycarbonate
MR-8
MR-10
 ', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'SpectacleLensesMaterial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'G15
Dark Gray
Brown
Blue
Yellow
 ', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'SpectacleLensesTintedGradient'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Blue
Green
Yellow
Rose
Red
Gold Platinium
Silver
 ', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'SpectacleLensesTintedMirror'
GO
EXEC sp_addextendedproperty N'MS_Description', N'G15
Dark Gray
Brown
Blue
Yellow
 ', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'SpectacleLensesTintedSolid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'StatusIs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inventory = 0
Services = 1', 'SCHEMA', N'Items', 'TABLE', N't_ItemShared', 'COLUMN', N'TypeIs'
GO
