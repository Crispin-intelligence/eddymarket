SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_BeginningInventoryQuantityUpdate]
    @DateIs DATETIME,
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @DescriptionIs NVARCHAR(MAX),
    @DetailIs Items.tt_BeginningInventoryQuantityDetail READONLY,
    @SerialIs Items.tt_ItemSerial READONLY,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY

        SET ANSI_WARNINGS OFF;

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @ItemQtyOld AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                SharedID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL
            );

            DECLARE @Item AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                SharedID UNIQUEIDENTIFIER NOT NULL,
                ItemID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL,
                Total FLOAT NOT NULL,
                TotalD FLOAT NOT NULL,
                TotalLL FLOAT NOT NULL,
                TotalEuro FLOAT NOT NULL
            );

            DECLARE @ItemQtyNet AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL
            );

            DECLARE @return INT;

        END;

        BEGIN --Set info

            INSERT INTO @ItemQtyOld
            (
                ID,
                SharedID,
                Qty
            )
            SELECT s.ItemID,
                   s.ItemSharedID,
                   s.Qtys
            FROM Items.t_BeginningInventoryQuantityDetail AS s
            WHERE s.BeginningInventoryQuantityID = @ID;

        END;

        BEGIN --Update

            SET @return = 0;

            UPDATE Items.t_BeginningInventoryQuantity
            SET DateIs = @DateIs,
                CurrencyID = @CurrencyID,
                Currency = Currencys.f_CurrencyGetName(@CurrencyID),
                ExchangeRate = @ExchangeRate,
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

        END;

        BEGIN --Insert detail

            MERGE Items.t_BeginningInventoryQuantityDetail AS t
            USING @DetailIs AS s
            ON s.ID = t.ID
            WHEN NOT MATCHED BY TARGET THEN
                INSERT
                (
                    ID,
                    BeginningInventoryQuantityID,
                    ItemSharedID,
                    ItemID,
                    ItemUnityID,
                    Qty,
                    QtyWithUnity,
                    Qtys,
                    Price,
                    PriceF,
                    PriceD,
                    PriceLL,
                    PriceEuro,
                    Total,
                    TotalF,
                    TotalD,
                    TotalLL,
                    TotalEuro,
                    DescriptionIs,
                    SortAt
                )
                VALUES
                (s.ID, @ID, s.ItemSharedID, s.ItemID, s.ItemUnityID, s.Qty,
                 FORMAT(s.Qty, '#,##0.####') + ' ' + [Items].[f_UnityItemGetName](s.ItemUnityID),
                 s.Qty * [Items].[f_UnityItemGetQty](s.ItemUnityID), s.Price, Currencys.f_Format(@CurrencyID, s.Price),
                 s.Price / @ExchangeRate, Currencys.f_ExchangeToLL(@CurrencyID, s.Price, s.Price / @ExchangeRate),
                 Currencys.f_ExchangeToEuro(@CurrencyID, s.Price, s.Price / @ExchangeRate), s.Price * s.Qty,
                 Currencys.f_Format(@CurrencyID, s.Price * s.Qty), (s.Price * s.Qty) / @ExchangeRate,
                 Currencys.f_ExchangeToLL(@CurrencyID, s.Price * s.Qty, (s.Price * s.Qty) / @ExchangeRate),
                 Currencys.f_ExchangeToEuro(@CurrencyID, s.Price * s.Qty, (s.Price * s.Qty) / @ExchangeRate),
                 s.DescriptionIs, s.SortAt)
            WHEN MATCHED THEN
                UPDATE SET t.ItemID = s.ItemID,
                           t.ItemUnityID = s.ItemUnityID,
                           t.Qty = s.Qty,
                           t.QtyWithUnity = FORMAT(s.Qty, '#,##0.##') + ' '
                                            + [Items].[f_UnityItemGetName](s.ItemUnityID),
                           t.Qtys = s.Qty * [Items].[f_UnityItemGetQty](s.ItemUnityID),
                           t.Price = s.Price,
                           t.PriceF = Currencys.f_Format(@CurrencyID, s.Price),
                           t.PriceD = s.Price / @ExchangeRate,
                           t.PriceLL = Currencys.f_ExchangeToLL(@CurrencyID, s.Price, s.Price / @ExchangeRate),
                           t.PriceEuro = Currencys.f_ExchangeToEuro(@CurrencyID, s.Price, s.Price / @ExchangeRate),
                           t.Total = s.Price * s.Qty,
                           t.TotalF = Currencys.f_Format(@CurrencyID, s.Price * s.Qty),
                           t.TotalD = (s.Price * s.Qty) / @ExchangeRate,
                           t.TotalLL = Currencys.f_ExchangeToLL(
                                                                   @CurrencyID,
                                                                   s.Price * s.Qty,
                                                                   (s.Price * s.Qty) / @ExchangeRate
                                                               ),
                           t.TotalEuro = Currencys.f_ExchangeToEuro(
                                                                       @CurrencyID,
                                                                       s.Price * s.Qty,
                                                                       (s.Price * s.Qty) / @ExchangeRate
                                                                   ),
                           t.DescriptionIs = s.DescriptionIs,
                           t.SortAt = s.SortAt
            WHEN NOT MATCHED BY SOURCE AND t.BeginningInventoryQuantityID = @ID THEN
                DELETE;

            INSERT INTO @Item
            (
                ID,
                SharedID,
                ItemID,
                Qty,
                Total,
                TotalD,
                TotalLL,
                TotalEuro
            )
            SELECT s.ID,
                   s.ItemSharedID,
                   s.ItemID,
                   s.Qtys,
                   s.Total,
                   s.TotalD,
                   s.TotalLL,
                   s.TotalEuro
            FROM Items.t_BeginningInventoryQuantityDetail AS s
            WHERE s.BeginningInventoryQuantityID = @ID;

        END;

        BEGIN --Insert serial

            INSERT INTO Items.t_ItemSerial
            (
                ID,
                ItemSharedID,
                ItemID,
                SerialText,
                SectionType,
                LinkID
            )
            SELECT s.ID,
                   s.ItemSharedID,
                   s.ItemID,
                   s.SerialText,
                   158,
                   @ID
            FROM @SerialIs AS s;

        END;

        BEGIN --Insert detial serial

            INSERT INTO Items.t_BeginningInventoryQuantityDetailSerial
            (
                BeginningInventoryQuantityID,
                BeginningInventoryQuantityDetailID,
                SerialID
            )
            SELECT @ID,
                   s.FatherID,
                   s.ID
            FROM @SerialIs AS s;

        END;

        BEGIN --Rebuild statistics

            UPDATE Items.t_BeginningInventoryQuantity
            SET Total =
                (
                    SELECT COALESCE(SUM(s.Total), 0) FROM @Item AS s
                ),
                TotalD =
                (
                    SELECT COALESCE(SUM(s.TotalD), 0) FROM @Item AS s
                ),
                TotalLL =
                (
                    SELECT COALESCE(SUM(s.TotalLL), 0) FROM @Item AS s
                ),
                TotalEuro =
                (
                    SELECT COALESCE(SUM(s.TotalEuro), 0) FROM @Item AS s
                ),
                Qtys =
                (
                    SELECT COALESCE(SUM(s.Qty), 0) FROM @Item AS s
                )
            WHERE ID = @ID;

            UPDATE Items.t_BeginningInventoryQuantity
            SET TotalF = Currencys.f_Format(CurrencyID, Total),
                ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Items.t_BeginningInventoryQuantityDetail AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.BeginningInventoryQuantityID = t_BeginningInventoryQuantity.ID
                                 FOR XML PATH('')
                             )
                                          )
            WHERE ID = @ID;

        END;

        BEGIN --Fix item qty

            INSERT INTO @ItemQtyNet
            (
                ID,
                Qty
            )
            SELECT o.ID,
                   COALESCE(SUM(o.Qty), 0)
            FROM
            (
                SELECT s.ID,
                       0 - COALESCE(SUM(s.Qty), 0) AS Qty
                FROM @ItemQtyOld AS s
                GROUP BY s.ID
                UNION ALL
                SELECT s.ItemID,
                       COALESCE(SUM(s.Qty), 0)
                FROM @Item AS s
                GROUP BY s.ItemID
            ) AS o
            GROUP BY o.ID;

            MERGE Items.t_Item AS t
            USING @ItemQtyNet AS s
            ON s.ID = t.ID
               AND t.TypeIs = 0
            WHEN MATCHED THEN
                UPDATE SET t.QtyCurrent += s.Qty;

        END;

        BEGIN --Fix shared item qty

            DELETE FROM @ItemQtyNet;

            INSERT INTO @ItemQtyNet
            (
                ID,
                Qty
            )
            SELECT o.SharedID,
                   COALESCE(SUM(o.Qty), 0)
            FROM
            (
                SELECT s.SharedID,
                       0 - COALESCE(SUM(s.Qty), 0) AS Qty
                FROM @ItemQtyOld AS s
                GROUP BY s.SharedID
                UNION ALL
                SELECT s.SharedID,
                       COALESCE(SUM(s.Qty), 0)
                FROM @Item AS s
                GROUP BY s.SharedID
            ) AS o
            GROUP BY o.SharedID;

            MERGE Items.t_ItemShared AS t
            USING @ItemQtyNet AS s
            ON s.ID = t.ID
               AND t.TypeIs = 0
            WHEN MATCHED THEN
                UPDATE SET t.QtyCurrent += s.Qty,
                           t.PurchaseTotal = t.Purchase * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalF = Currencys.f_Format(t.CurrencyID, t.Purchase * (t.QtyCurrent + s.Qty)),
                           t.PurchaseTotalD = t.PurchaseD * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalLL = t.PurchaseLL * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalEuro = t.PurchaseEuro * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalWithTax = t.PurchaseWithTax * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalWithTaxF = Currencys.f_Format(
                                                                           t.CurrencyID,
                                                                           t.PurchaseWithTax * (t.QtyCurrent + s.Qty)
                                                                       ),
                           t.PurchaseTotalWithTaxD = t.PurchaseWithTaxD * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalWithTaxLL = t.PurchaseWithTaxLL * (t.QtyCurrent + s.Qty),
                           t.PurchaseTotalWithTaxEuro = t.PurchaseWithTaxEuro * (t.QtyCurrent + s.Qty),
                           t.SellTotal = t.Sell * (t.QtyCurrent + s.Qty),
                           t.SellTotalF = Currencys.f_Format(
                                                                [Items].[f_UnityItemGetCurrencyID](t.ID),
                                                                t.Sell * (t.QtyCurrent + s.Qty)
                                                            ),
                           t.SellTotalD = t.SellD * (t.QtyCurrent + s.Qty),
                           t.SellTotalLL = t.SellLL * (t.QtyCurrent + s.Qty),
                           t.SellTotalEuro = t.SellEuro * (t.QtyCurrent + s.Qty),
                           t.SellTotalWithTax = t.SellWithTax * (t.QtyCurrent + s.Qty),
                           t.SellTotalWithTaxF = Currencys.f_Format(
                                                                       t.SellCurrencyID,
                                                                       t.SellWithTax * (t.QtyCurrent + s.Qty)
                                                                   ),
                           t.SellTotalWithTaxD = t.SellWithTaxD * (t.QtyCurrent + s.Qty),
                           t.SellTotalWithTaxLL = t.SellWithTaxLL * (t.QtyCurrent + s.Qty),
                           t.SellTotalWithTaxEuro = t.SellWithTaxEuro * (t.QtyCurrent + s.Qty);

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT INTO Items.t_BeginningInventoryQuantityMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            VALUES
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
