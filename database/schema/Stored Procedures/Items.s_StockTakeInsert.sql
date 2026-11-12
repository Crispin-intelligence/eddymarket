SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_StockTakeInsert]
    @DateIs DATETIME ,
    @TypeIs TINYINT ,
    @WarehouseID UNIQUEIDENTIFIER ,
    @ReasonStockAdjustmentID UNIQUEIDENTIFIER ,
    @CurrencyID UNIQUEIDENTIFIER ,
    @ExchangeRate DECIMAL(18, 2) ,
    @ExchangeRateLL DECIMAL(18, 2) ,
    @ExchangeRateEuro DECIMAL(18, 2) ,
    @DescriptionIs NVARCHAR(MAX) ,
    @DetailIs Items.[tt_StockTakeDetail] READONLY ,
    @SerialIsIn Items.tt_ItemSerial READONLY ,
    @SerialIsOut Items.tt_ItemSerial READONLY ,
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
                  ID UNIQUEIDENTIFIER NOT NULL ,
                  SharedID UNIQUEIDENTIFIER NOT NULL ,
                  Qty DECIMAL(18, 4) NOT NULL ,
                  Total FLOAT NOT NULL ,
                  TotalD FLOAT NOT NULL ,
                  TotalLL FLOAT NOT NULL ,
                  TotalEuro FLOAT NOT NULL
                );

            DECLARE @ItemQtyNet AS TABLE
                (
                  ID UNIQUEIDENTIFIER NOT NULL ,
                  Qty DECIMAL(18, 4) NOT NULL
                );

            DECLARE @Ref BIGINT ,
                @return INT;

        END;

        BEGIN --Set info

            SELECT  @Ref = ISNULL(MAX(s.Ref), 0) + 1
            FROM    Items.t_StockTake AS s;

        END;

        BEGIN --Insert

            SET @return = 0;

            INSERT  INTO Items.t_StockTake
                    ( Ref ,
                      RefF ,
					  TypeIs,
                      DateIs ,
                      DateOnly ,
                      DateMonthly ,
                      DateYearly ,
                      WarehouseID ,
                      Warehouse ,
                      ReasonStockAdjustmentID ,
                      ReasonStockAdjustment ,
                      UserID ,
                      UserIs ,
                      CurrencyID ,
                      Currency ,
                      ExchangeRate ,
                      ExchangeRateLL ,
                      ExchangeRateEuro ,
                      DescriptionIs
                    )
            OUTPUT  Inserted.ID
                    INTO @IDs ( ID )
            VALUES  ( @Ref ,
                      FORMAT(@Ref, 'n0') ,
					  @TypeIs,
                      @DateIs ,
                      @DateIs ,
                      DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
                      DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
                      @WarehouseID ,
                      Company.f_WareHouseGetName(@WarehouseID) ,
                      @ReasonStockAdjustmentID ,
                      Items.f_ReasonStockAdjustmentGetName(@ReasonStockAdjustmentID) ,
                      @UserID ,
                      Users.f_UserGetName(@UserID) ,
                      @CurrencyID ,
                      Currencys.f_CurrencyGetName(@CurrencyID) ,
                      @ExchangeRate ,
                      @ExchangeRateLL ,
                      @ExchangeRateEuro ,
                      @DescriptionIs
                    );

            SET @ID = ( SELECT TOP ( 1 )
                                s.ID
                        FROM    @IDs AS s
                        ORDER BY s.ID
                      );

        END;

        BEGIN --Insert detail

            INSERT  INTO Items.t_StockTakeDetail
                    ( ID ,
                      StockTakeID ,
                      ItemSharedID ,
                      ItemID ,
                      ItemUnityID ,
                      QtyCurrent ,
                      QtyOnHand ,
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
                      DescriptionIs ,
                      SortAt
                    )
            OUTPUT  Inserted.ItemID ,
                    Inserted.ItemSharedID ,
                    Inserted.Qtys ,
                    Inserted.Total ,
                    Inserted.TotalD ,
                    Inserted.TotalLL ,
                    Inserted.TotalEuro
                    INTO @Item
                    SELECT  s.ID ,
                            @ID ,
                            s.ItemSharedID ,
                            s.ItemID ,
                            s.ItemUnityID ,
                            s.QtyCurrent ,
                            s.QtyOnHand ,
                            s.Qty ,
                            FORMAT(s.Qty, '#,##0.####') + ' ' + s2.Name ,
                            s.Qty * s1.Qty ,
                            s.Price ,
                            Currencys.f_Format(@CurrencyID, s.Price) ,
                            s.Price / @ExchangeRate ,
                            ( s.Price / @ExchangeRate ) * @ExchangeRateLL ,
                            ( s.Price / @ExchangeRate ) * @ExchangeRateEuro ,
                            s.Total ,
                            Currencys.f_Format(@CurrencyID, s.Total) ,
                            s.Total / @ExchangeRate ,
                            ( s.Total / @ExchangeRate ) * @ExchangeRateLL ,
                            ( s.Total / @ExchangeRate ) * @ExchangeRateEuro ,
                            s.DescriptionIs ,
                            s.SortAt
                    FROM    @DetailIs AS s
                            LEFT JOIN Items.t_UnityItem AS s1 ON s1.ID = s.ItemUnityID
                            LEFT JOIN Items.t_Unity AS s2 ON s2.ID = s1.UnityID;

        END;

        BEGIN --Insert serial in

            INSERT  INTO Items.t_ItemSerial
                    ( ID ,
                      ItemSharedID ,
                      ItemID ,
                      SerialText ,
                      SectionType ,
                      LinkID
                    )
                    SELECT  s.ID ,
                            s.ItemSharedID ,
                            s.ItemID ,
                            s.SerialText ,
                            101 ,
                            @ID
                    FROM    @SerialIsIn AS s;

        END;

        BEGIN --Insert detial serial

            INSERT  INTO Items.t_StockTakeDetailSerial
                    ( StockTakeID ,
                      StockTakeDetailID ,
                      SerialID
                    )
                    SELECT  @ID ,
                            s.FatherID ,
                            s.ID
                    FROM    @SerialIsIn AS s
                    UNION ALL
                    SELECT  @ID ,
                            s.FatherID ,
                            s.ID
                    FROM    @SerialIsOut AS s;

        END;

        BEGIN --Update item serial out

            UPDATE  Items.t_ItemSerial
            SET     IsAvailable = 0
            WHERE   EXISTS ( SELECT TOP ( 1 )
                                    s.ID
                             FROM   @SerialIsOut AS s
                             WHERE  s.ID = t_ItemSerial.ID );

        END;

        BEGIN --Rebuild statistics

            UPDATE  Items.t_StockTake
            SET     NetIs = ( SELECT    COALESCE(SUM(s.Total), 0)
                              FROM      @Item AS s
                            ) ,
                    NetIsD = ( SELECT   COALESCE(SUM(s.TotalD), 0)
                               FROM     @Item AS s
                             ) ,
                    NetIsLL = ( SELECT  COALESCE(SUM(s.TotalLL), 0)
                                FROM    @Item AS s
                              ) ,
                    NetIsEuro = ( SELECT    COALESCE(SUM(s.TotalEuro), 0)
                                  FROM      @Item AS s
                                ) ,
                    Qtys = ( SELECT COALESCE(SUM(s.Qty), 0)
                             FROM   @Item AS s
                           )
            WHERE   ID = @ID;

            UPDATE  Items.t_StockTake
            SET     NetIsF = Currencys.f_Format(@CurrencyID, NetIs) ,
                    ItemsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                        ', ' + t1.Name AS [text()]
                                                 FROM   Items.t_StockTakeDetail AS t
                                                        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                                 WHERE  t.StockTakeID = t_StockTake.ID
                                               FOR
                                                 XML PATH('')
                                               ))
            WHERE   ID = @ID;

        END;

        BEGIN --Fix item qty

            INSERT  INTO @ItemQtyNet
                    ( ID ,
                      Qty
                    )
                    SELECT  s.ID ,
                            COALESCE(SUM(s.Qty), 0)
                    FROM    @Item AS s
                    GROUP BY s.ID;

            MERGE Items.t_Item AS t
            USING @ItemQtyNet AS s
            ON s.ID = t.ID
                AND t.TypeIs = 0
            WHEN MATCHED THEN
                UPDATE SET
                         t.QtyCurrent += s.Qty ,
                         t.LastStockTakeDate = @DateIs;

        END;

        BEGIN --Fix shared item qty

            DELETE  FROM @ItemQtyNet;

            INSERT  INTO @ItemQtyNet
                    ( ID ,
                      Qty
                    )
                    SELECT  s.SharedID ,
                            COALESCE(SUM(s.Qty), 0)
                    FROM    @Item AS s
                    GROUP BY s.SharedID;

            MERGE Items.t_ItemShared AS t
            USING @ItemQtyNet AS s
            ON s.ID = t.ID
                AND t.TypeIs = 0
            WHEN MATCHED THEN
                UPDATE SET
                         t.QtyCurrent += s.Qty ,
                         t.PurchaseTotal = t.Purchase * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalF = Currencys.f_Format(t.CurrencyID, t.Purchase * ( t.QtyCurrent + s.Qty )) ,
                         t.PurchaseTotalD = t.PurchaseD * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalLL = t.PurchaseLL * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalEuro = t.PurchaseEuro * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalWithTax = t.PurchaseWithTax * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalWithTaxF = Currencys.f_Format(t.CurrencyID, t.PurchaseWithTax * ( t.QtyCurrent + s.Qty )) ,
                         t.PurchaseTotalWithTaxD = t.PurchaseWithTaxD * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalWithTaxLL = t.PurchaseWithTaxLL * ( t.QtyCurrent + s.Qty ) ,
                         t.PurchaseTotalWithTaxEuro = t.PurchaseWithTaxEuro * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotal = t.Sell * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](t.ID), t.Sell * ( t.QtyCurrent + s.Qty )) ,
                         t.SellTotalD = t.SellD * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalLL = t.SellLL * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalEuro = t.SellEuro * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalWithTax = t.SellWithTax * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalWithTaxF = Currencys.f_Format(t.SellCurrencyID, t.SellWithTax * ( t.QtyCurrent + s.Qty )) ,
                         t.SellTotalWithTaxD = t.SellWithTaxD * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalWithTaxLL = t.SellWithTaxLL * ( t.QtyCurrent + s.Qty ) ,
                         t.SellTotalWithTaxEuro = t.SellWithTaxEuro * ( t.QtyCurrent + s.Qty );

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT  INTO Items.t_StockTakeMoving
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
                      @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref) ,
                      0 ,
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
