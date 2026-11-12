SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_UnityItemUpdate]
  @UnityID UNIQUEIDENTIFIER ,
  @Purchasing BIT ,
  @Sold BIT ,
  @Inventory BIT ,
  @UseInTransfer BIT ,
  @BarCode NVARCHAR(450) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Price FLOAT ,
  @LowestPrice FLOAT ,
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

      DECLARE @Return INT ,
        @ItemSharedID UNIQUEIDENTIFIER ,
        @UnityIDOld UNIQUEIDENTIFIER ,
        @Unity NVARCHAR(MAX) ,
        @BarcodeOld NVARCHAR(450) ,
        @ExchangeRate DECIMAL(18, 2) ,
        @PrimaryIs BIT ,
        @PurchasingOld BIT ,
        @SoldOld BIT ,
        @InventoryOld BIT ,
        @UseInTransferOld BIT ,
        @UnityC INT ,
        @TaxRate DECIMAL(4, 2);

    END;

    BEGIN --Set info

      SET @ExchangeRate = Currencys.f_CurrencyGetExchangeRate(@CurrencyID);

      SET @Unity = Items.f_UnityGetName(@UnityID);

      SELECT TOP ( 1 )
              @ItemSharedID = s.SharedID ,
              @UnityIDOld = s.UnityID ,
              @BarcodeOld = s.BarCode ,
              @PrimaryIs = s.PrimaryIs ,
              @PurchasingOld = s.Purchasing ,
              @SoldOld = s.Sold ,
              @InventoryOld = s.Inventory ,
              @UseInTransferOld = s.UseInTransfer ,
              @TaxRate = s1.TaxRate
      FROM    Items.t_UnityItem AS s
      LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.SharedID
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      SELECT  @UnityC = COUNT(*)
      FROM    Items.t_UnityItem AS s
      WHERE   s.SharedID = @ItemSharedID;

    END;

    BEGIN --Delete old barcode

      SET @Return = -3;

      DELETE  FROM Items.t_ItemSharedBarCode
      WHERE   SharedID = @ItemSharedID
              AND TypeIs = 2
              AND BarCode = @BarcodeOld;

    END;

    IF @BarCode <> N''
    BEGIN --Insert barcodes

      INSERT  INTO Items.t_ItemSharedBarCode
              ( SharedID ,
                BarCode ,
                BarcodeNumber ,
                TypeIs
              )
      VALUES  ( @ItemSharedID ,
                @BarCode ,
                Alls.f_ToBigint(@BarCode) ,
                2
              );

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_UnityItem
      SET     Purchasing = IIF(@Purchasing = 1, 0, Purchasing) ,
              Sold = IIF(@Sold = 1, 0, Sold) ,
              Inventory = IIF(@Inventory = 1, 0, Inventory) ,
              UseInTransfer = IIF(@UseInTransfer = 1, 0, UseInTransfer)
      WHERE   SharedID = @ItemSharedID;

      UPDATE  Items.t_UnityItem
      SET     UnityID = @UnityID ,
              Unity = @Unity ,
              Purchasing = @Purchasing ,
              Sold = @Sold ,
              Inventory = @Inventory ,
              UseInTransfer = @UseInTransfer ,
              BarCode = @BarCode ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              Price = @Price ,
              PriceF = Currencys.f_Format(@CurrencyID, @Price) ,
              PriceD = @Price / @ExchangeRate ,
              PriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @Price, @Price / @ExchangeRate) ,
              PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @Price / @ExchangeRate) ,
              PriceWithTax = Calculation.Rate(@Price, @TaxRate) ,
              LowestPrice = @LowestPrice ,
              LowestPriceF = Currencys.f_Format(@CurrencyID, @LowestPrice) ,
              LowestPriceD = @LowestPrice / @ExchangeRate
      WHERE   ID = @ID;

      UPDATE  Items.t_UnityItem
      SET     PriceWithTaxF = Currencys.f_Format(CurrencyID, PriceWithTax) ,
              PriceWithTaxD = PriceWithTax / @ExchangeRate ,
              PriceWithTaxLL = Currencys.f_ExchangeToLL(CurrencyID, PriceWithTax, PriceWithTax / @ExchangeRate) ,
              PriceWithTaxEuro = Currencys.f_ExchangeToEuro(CurrencyID, PriceWithTax, PriceWithTax / @ExchangeRate)
      WHERE   ID = @ID;

    END;

    BEGIN --Fix data

      IF @UnityC = 1
      BEGIN

        UPDATE  Items.t_UnityItem
        SET     Purchasing = 1 ,
                Sold = 1 ,
                Inventory = 1 ,
                UseInTransfer = 1
        WHERE   SharedID = @ItemSharedID;

      END;
      ELSE
        IF @UnityC = 2
        BEGIN

          UPDATE  Items.t_UnityItem
          SET     Purchasing = ~@Purchasing ,
                  Sold = ~@Sold ,
                  Inventory = ~@Inventory ,
                  UseInTransfer = ~@UseInTransfer
          WHERE   SharedID = @ItemSharedID
                  AND ID <> @ID;

        END;
        ELSE
        BEGIN

          SELECT TOP ( 1 )
                  @ID = s.ID
          FROM    Items.t_UnityItem AS s
          WHERE   s.SharedID = @ItemSharedID
                  AND s.ID <> @ID
          ORDER BY s.DateCreate;

          UPDATE  Items.t_UnityItem
          SET     Purchasing = IIF(@Purchasing = 0
                  AND @PurchasingOld = 1, 1, Purchasing) ,
                  Sold = IIF(@Sold = 0
                  AND @SoldOld = 1, 1, Sold) ,
                  Inventory = IIF(@Inventory = 0
                  AND @InventoryOld = 1, 1, Inventory) ,
                  UseInTransfer = IIF(@UseInTransfer = 0
                  AND @UseInTransferOld = 1, 1, UseInTransfer)
          WHERE   ID = @ID;

        END;

    END;

    IF @PrimaryIs = 1
    BEGIN --Update item

      UPDATE  Items.t_ItemShared
      SET     SellCurrencyID = @CurrencyID ,
              SellCurrency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              Sell = @Price ,
              SellF = Currencys.f_Format(@CurrencyID, @Price) ,
              SellD = @Price / @ExchangeRate ,
              SellLL = Currencys.f_ExchangeToLL(@CurrencyID, @Price, @Price / @ExchangeRate) ,
              SellEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @Price / @ExchangeRate) ,
              SellWithTax = Calculation.Rate(@Price, TaxRate)
      WHERE   ID = @ItemSharedID;

      UPDATE  Items.t_ItemShared
      SET     SellTotal = @Price * QtyCurrent ,
              SellTotalF = Currencys.f_Format(@CurrencyID, @Price * QtyCurrent) ,
              SellWithTaxF = Currencys.f_Format(@CurrencyID, SellWithTax) ,
              SellWithTaxD = SellWithTax / @ExchangeRate ,
              SellWithTaxLL = Currencys.f_ExchangeToLL(@CurrencyID, SellWithTax, SellWithTax / @ExchangeRate) ,
              SellWithTaxEuro = Currencys.f_ExchangeToEuro(@CurrencyID, SellWithTax, SellWithTax / @ExchangeRate) ,
              SellTotalWithTax = SellWithTax * QtyCurrent ,
              SellTotalWithTaxF = Currencys.f_Format(@CurrencyID, SellWithTax * QtyCurrent)
      WHERE   ID = @ItemSharedID;

      UPDATE  Items.t_ItemShared
      SET     SellTotalD = SellD * QtyCurrent ,
              SellTotalLL = SellLL * QtyCurrent ,
              SellTotalEuro = SellEuro * QtyCurrent ,
              SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
              SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
              SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
      WHERE   ID = @ItemSharedID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
                                       FOR
                                         XML PATH('')
                                       )) ,
              UnityNames = Alls.f_FixXML(( SELECT N', ' + t.Unity AS [text()]
                                           FROM   Items.t_UnityItem AS t
                                           WHERE  t.SharedID = t_ItemShared.ID
                                         FOR
                                           XML PATH('')
                                         ))
      WHERE   ID = @ItemSharedID;

      IF @UnityID <> @UnityIDOld
      BEGIN

        UPDATE  Invoices.t_PurchasingDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_PurchasingDeletedDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_PurchasingReturnDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_PurchasingReturnDeletedDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_SoldDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_SoldDeletedDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_SoldDeletedDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_SoldReturnDeletedDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Company.t_AccountItemPrice
        SET     Unity = @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_TransferDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Invoices.t_TransferAwaitedDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Items.t_BeginningInventoryQuantityDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Items.t_ItemProduction
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Items.t_ItemProductionMaterial
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Items.t_ItemSharedMaterial
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Items.t_StockAdjustmentDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Items.t_StockTakeDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Quotations.t_QuotationDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

        UPDATE  Quotations.t_QuotationHistoryDetail
        SET     QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + @Unity
        WHERE   ItemUnityID = @ID;

      END;
   
      UPDATE  Items.t_UnityItem
      SET     SearchText = Items.f_UnityItemSearchTextGet(ID)
      WHERE   ID = @ID;

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
                @ItemSharedID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;









GO
