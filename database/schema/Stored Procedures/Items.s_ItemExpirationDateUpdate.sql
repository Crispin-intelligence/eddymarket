SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemExpirationDateUpdate]
  @ItemSharedID UNIQUEIDENTIFIER ,
  @ItemID UNIQUEIDENTIFIER ,
  @WareHouseID UNIQUEIDENTIFIER ,
  @PlaceID UNIQUEIDENTIFIER ,
  @Barcode NVARCHAR(450) ,
  @Qtys DECIMAL(18, 4) ,
  @ProductionDate DATE ,
  @ExpirationDate DATE ,
  @NotifyMeDaysBefore INT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Price FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType INT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare
		
      DECLARE @PriceD FLOAT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @ItemSharedIDOld UNIQUEIDENTIFIER ,
        @BarcodeOld NVARCHAR(450) ,
        @Return INT;

    END;

    BEGIN --Set info

      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);

      SET @PriceD = @Price / @ExchangeRate;

      SELECT TOP ( 1 )
              @ItemSharedIDOld = s.ItemSharedID ,
              @BarcodeOld = s.Barcode
      FROM    Items.t_ItemExpirationDate AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_ItemExpirationDate
      SET     ItemSharedID = @ItemSharedID ,
              ItemID = @ItemID ,
              WareHouseID = @WareHouseID ,
              WareHouse = Company.f_WareHouseGetName(@WareHouseID) ,
              PlaceID = @PlaceID ,
              Place = Company.f_PlaceGetName(@PlaceID) ,
              SectionIs = 10 ,
              SectionID = @ItemSharedID ,
              Barcode = @Barcode ,
              Qtys = @Qtys ,
              ProductionDate = @ProductionDate ,
              ExpirationDate = @ExpirationDate ,
              NotifyMeDaysBefore = @NotifyMeDaysBefore ,
              NotificationDate = DATEADD(DAY, 0 - @NotifyMeDaysBefore, @ExpirationDate) ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              Price = @Price ,
              PriceF = Currencys.f_Format(@CurrencyID, @Price) ,
              PriceD = @PriceD ,
              PriceLL = Currencys.f_ExchangeToLL(@CurrencyID, @Price, @PriceD) ,
              PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @PriceD) ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

      UPDATE  Items.t_ItemExpirationDate
      SET     SearchText = Items.f_ItemExpirationDateSearchTextGet(ID)
      WHERE   ID = @ID;

    END;
		
    BEGIN --Delete old barcode

      SET @Return = -3;

      DELETE  FROM Items.t_ItemSharedBarCode
      WHERE   SharedID = @ItemSharedID
              AND TypeIs = 3
              AND BarCode = @BarcodeOld;

    END;

    IF @Barcode <> N''
    BEGIN --Insert barcodes

      SET @Return = -3;

      INSERT  INTO Items.t_ItemSharedBarCode
              ( SharedID ,
                BarCode ,
                BarcodeNumber ,
                TypeIs
              )
      VALUES  ( @ItemSharedID ,
                @Barcode ,
                Alls.f_ToBigint(@Barcode) ,
                3
              );
	
    END;

    BEGIN --Fix t_ItemShared

      UPDATE  Items.t_ItemShared
      SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
                                       FOR
                                         XML PATH('')
                                       ))
      WHERE   ID = @ItemSharedID;

      EXECUTE Items.s_ItemSharedUpdateSearchIndexPART @ItemSharedID;
		
      IF @ItemSharedIDOld <> @ItemSharedID
      BEGIN

        UPDATE  Items.t_ItemShared
        SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                           FROM   Items.t_ItemSharedBarCode AS t
                                           WHERE  t.SharedID = t_ItemShared.ID
                                         FOR
                                           XML PATH('')
                                         ))
        WHERE   ID = @ItemSharedIDOld;                      

        EXECUTE Items.s_ItemSharedUpdateSearchIndexPART @ItemSharedIDOld;
		
      END;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemExpirationDateMoving
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

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;


GO
