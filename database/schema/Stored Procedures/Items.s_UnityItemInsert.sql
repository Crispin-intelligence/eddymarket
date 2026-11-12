SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_UnityItemInsert]
  @UnityID UNIQUEIDENTIFIER ,
  @SharedID UNIQUEIDENTIFIER ,
  @Qty DECIMAL(18, 2) ,
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

      DECLARE @ExchangeRate DECIMAL(18, 2) ,
        @TaxRate DECIMAL(4, 2) ,
        @Return INT;

    END;

    BEGIN --Set info

      SET @ExchangeRate = Currencys.f_CurrencyGetExchangeRate(@CurrencyID);

      SELECT TOP ( 1 )
              @TaxRate = s.TaxRate
      FROM    Items.t_ItemShared AS s
      WHERE   s.ID = @SharedID
      ORDER BY s.ID;

    END;

    IF @BarCode <> N''
    BEGIN --Insert barcodes

      SET @Return = -3;

      INSERT  INTO Items.t_ItemSharedBarCode
              ( SharedID ,
                BarCode ,
                BarcodeNumber ,
                TypeIs
              )
      VALUES  ( @SharedID ,
                @BarCode ,
                Alls.f_ToBigint(@BarCode) ,
                2
              );

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Items.t_UnityItem
              ( ID ,
                UnityID ,
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
                LowestPrice ,
                LowestPriceF ,
                LowestPriceD
              )
      SELECT TOP ( 1 )
              @ID ,
              @UnityID ,
              Items.f_UnityGetName(@UnityID) ,
              @SharedID ,
              @Qty ,
              0 ,
              @Purchasing ,
              @Sold ,
              @Inventory ,
              @UseInTransfer ,
              @BarCode ,
              @CurrencyID ,
              s.Name ,
              @Price ,
              Currencys.f_Format(@CurrencyID, @Price) ,
              @Price / s.ExchangeRate ,
              Currencys.f_ExchangeToLL(@CurrencyID, @Price, @Price / s.ExchangeRate) ,
              Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @Price / s.ExchangeRate) ,
              Calculation.Rate(@Price, @TaxRate) ,
              @LowestPrice ,
              Currencys.f_Format(@CurrencyID, @LowestPrice) ,
              @LowestPrice / s.ExchangeRate
      FROM    Currencys.t_Currency AS s
      WHERE   s.ID = @CurrencyID
      ORDER BY s.ID;

    END;

    BEGIN --Fix data

      UPDATE  Items.t_UnityItem
      SET     Purchasing = CASE @Purchasing
                             WHEN 1 THEN 0
                             ELSE Purchasing
                           END ,
              Sold = CASE @Sold
                       WHEN 1 THEN 0
                       ELSE Sold
                     END ,
              Inventory = CASE @Inventory
                            WHEN 1 THEN 0
                            ELSE Inventory
                          END ,
              UseInTransfer = CASE @UseInTransfer
                                WHEN 1 THEN 0
                                ELSE UseInTransfer
                              END
      WHERE   SharedID = @SharedID
              AND ID <> @ID;

      UPDATE  Items.t_UnityItem
      SET     PriceWithTaxF = Currencys.f_Format(CurrencyID, PriceWithTax) ,
              PriceWithTaxD = PriceWithTax / @ExchangeRate ,
              PriceWithTaxLL = Currencys.f_ExchangeToLL(CurrencyID, PriceWithTax, PriceWithTax / @ExchangeRate) ,
              PriceWithTaxEuro = Currencys.f_ExchangeToEuro(CurrencyID, PriceWithTax, PriceWithTax / @ExchangeRate)
      WHERE   ID = @ID;
	  
      UPDATE  Items.t_UnityItem
      SET     SearchText = Items.f_UnityItemSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
                                       FOR
                                         XML PATH('')
                                       )) ,
              UnityC += 1 ,
              UnityNames = Alls.f_FixXML(( SELECT N', ' + t.Unity AS [text()]
                                           FROM   Items.t_UnityItem AS t
                                           WHERE  t.SharedID = t_ItemShared.ID
                                         FOR
                                           XML PATH('')
                                         ))
      WHERE   ID = @SharedID;

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
                @SharedID ,
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
