SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_BeginningInventoryQuantityInsert]
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
                ID UNIQUEIDENTIFIER NOT NULL,
                SharedID UNIQUEIDENTIFIER NOT NULL,
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

            DECLARE @Ref BIGINT,
                    @return INT;

        END;

        BEGIN --Set info

            SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
            FROM Items.t_BeginningInventoryQuantity AS s;

        END;

        BEGIN --Insert

            SET @return = 0;

            INSERT INTO Items.t_BeginningInventoryQuantity
            (
                Ref,
                RefF,
                DateIs,
                CurrencyID,
                Currency,
                ExchangeRate,
                DescriptionIs
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Ref, FORMAT(@Ref, 'n0'), @DateIs, @CurrencyID, Currencys.f_CurrencyGetName(@CurrencyID), @ExchangeRate,
             @DescriptionIs);

            SET @ID =
            (
                SELECT TOP (1) s.ID FROM @IDs AS s ORDER BY s.ID
            );

        END;

        BEGIN --Insert detail

            INSERT INTO Items.t_BeginningInventoryQuantityDetail
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
            OUTPUT Inserted.ItemID,
                   Inserted.ItemSharedID,
                   Inserted.Qtys,
                   Inserted.Total,
                   Inserted.TotalD,
                   Inserted.TotalLL,
                   Inserted.TotalEuro
            INTO @Item
            SELECT s.ID,
                   @ID,
                   s.ItemSharedID,
                   s.ItemID,
                   s.ItemUnityID,
                   s.Qty,
                   FORMAT(s.Qty, '#,##0.####') + ' ' + s2.Name,
                   s.Qty * s1.Qty,
                   s.Price,
                   Currencys.f_Format(@CurrencyID, s.Price),
                   s.Price / @ExchangeRate,
                   Currencys.f_ExchangeToLL(@CurrencyID, s.Price, s.Price / @ExchangeRate),
                   Currencys.f_ExchangeToEuro(@CurrencyID, s.Price, s.Price / @ExchangeRate),
                   s.Price * s.Qty,
                   Currencys.f_Format(@CurrencyID, s.Price * s.Qty),
                   (s.Price * s.Qty) / @ExchangeRate,
                   Currencys.f_ExchangeToLL(@CurrencyID, s.Price * s.Qty, (s.Price * s.Qty) / @ExchangeRate),
                   Currencys.f_ExchangeToEuro(@CurrencyID, s.Price * s.Qty, (s.Price * s.Qty) / @ExchangeRate),
                   s.DescriptionIs,
                   s.SortAt
            FROM @DetailIs AS s
                LEFT JOIN Items.t_UnityItem AS s1
                    ON s1.ID = s.ItemUnityID
                LEFT JOIN Items.t_Unity AS s2
                    ON s2.ID = s1.UnityID;

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
            SELECT s.ID,
                   COALESCE(SUM(s.Qty), 0)
            FROM @Item AS s
            GROUP BY s.ID;

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
            SELECT s.SharedID,
                   COALESCE(SUM(s.Qty), 0)
            FROM @Item AS s
            GROUP BY s.SharedID;

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
            (@UserID, @ID, @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref), 0, @ComputerIP, @Computer, @ComputerAccount);

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
