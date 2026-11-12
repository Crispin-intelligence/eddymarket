SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemExpirationDateInsert]
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

      DECLARE @Ref BIGINT ,
        @PriceD FLOAT ,
        @ExchangeRate DECIMAL(18, 2) ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT  @Ref = ISNULL(MAX(s.Ref), 0) + 1
      FROM    Items.t_ItemExpirationDate AS s;

      SET @ExchangeRate = [Currencys].[f_CurrencyGetExchangeRate](@CurrencyID);

      SET @PriceD = @Price / @ExchangeRate;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Items.t_ItemExpirationDate
              ( ID ,
                Ref ,
                RefF ,
                ItemSharedID ,
                ItemID ,
                WareHouseID ,
                WareHouse ,
                PlaceID ,
                Place ,
                SectionIs ,
                SectionID ,
                Barcode ,
                Qtys ,
                ProductionDate ,
                ExpirationDate ,
                NotifyMeDaysBefore ,
                NotificationDate ,
                CurrencyID ,
                Currency ,
                Price ,
                PriceF ,
                PriceD ,
                PriceLL ,
                PriceEuro ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Ref ,
                FORMAT(@Ref, 'n0') ,
                @ItemSharedID ,
                @ItemID ,
                @WareHouseID ,
                Company.f_WareHouseGetName(@WareHouseID) ,
                @PlaceID ,
                Company.f_PlaceGetName(@PlaceID) ,
                10 ,
                @ItemSharedID ,
                @Barcode ,
                @Qtys ,
                @ProductionDate ,
                @ExpirationDate ,
                @NotifyMeDaysBefore ,
                DATEADD(DAY, 0 - @NotifyMeDaysBefore, @ExpirationDate) ,
                @CurrencyID ,
                Currencys.f_CurrencyGetName(@CurrencyID) ,
                @Price ,
                Currencys.f_Format(@CurrencyID, @Price) ,
                @PriceD ,
                Currencys.f_ExchangeToLL(@CurrencyID, @Price, @PriceD) ,
                Currencys.f_ExchangeToEuro(@CurrencyID, @Price, @PriceD) ,
                @DescriptionIs
              );

      UPDATE  Items.t_ItemExpirationDate
      SET     SearchText = Items.f_ItemExpirationDateSearchTextGet(ID)
      WHERE   ID = @ID;

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
		
      UPDATE  Items.t_ItemShared
      SET     Barcodes = Alls.f_FixXML(( SELECT N', ' + t.BarCode AS [text()]
                                         FROM   Items.t_ItemSharedBarCode AS t
                                         WHERE  t.SharedID = t_ItemShared.ID
                                       FOR
                                         XML PATH('')
                                       ))
      WHERE   ID = @ItemSharedID;

      EXECUTE Items.s_ItemSharedUpdateSearchIndexPART @ItemSharedID;
		
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
