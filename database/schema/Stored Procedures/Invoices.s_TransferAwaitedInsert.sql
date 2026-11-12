SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_TransferAwaitedInsert]
    @DateIs DATETIME,
    @FromWarehouseID UNIQUEIDENTIFIER,
    @ToWarehouseID UNIQUEIDENTIFIER,
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @ExchangeRateLL DECIMAL(18, 2),
    @ExchangeRateEuro DECIMAL(18, 2),
    @DescriptionIs NVARCHAR(MAX),
    @DetailIs Invoices.[tt_TransferDetail] READONLY,
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

            DECLARE @ItemOut AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                SharedID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL
            );

            DECLARE @ItemQtyNet AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL
            );

            DECLARE @Ref BIGINT,
                    @Total FLOAT,
                    @TaxRate DECIMAL(4, 2) = 0,
                    @TaxValue FLOAT,
                    @NetIs FLOAT,
                    @Qtys DECIMAL(18, 4),
                    @return INT;

        END;

        BEGIN --Set info

            SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
            FROM
            (
                SELECT MAX(s.Ref) AS Ref
                FROM Invoices.t_TransferAwaited AS s
                UNION
                SELECT MAX(s.Ref)
                FROM Invoices.t_Transfer AS s
            ) AS s;

            SELECT @Total = COALESCE(SUM(s.SubTotal), 0),
                   @TaxValue = COALESCE(SUM(s.TaxValue), 0),
                   @NetIs = COALESCE(SUM(s.Total), 0),
                   @Qtys = COALESCE(SUM(s.Qtys), 0)
            FROM @DetailIs AS s;

            IF @Total > 0
               AND @TaxValue > 0
            BEGIN

                SET @TaxRate = (@TaxValue / @Total) * 100;

            END;

        END;

        BEGIN --Insert

            SET @return = 0;

            INSERT INTO Invoices.t_TransferAwaited
            (
                Ref,
                RefF,
                DateIs,
                DateOnly,
                DateMonthly,
                DateYearly,
                FromWarehouseID,
                FromWarehouse,
                ToWarehouseID,
                ToWarehouse,
                UserID,
                UserIs,
                CurrencyID,
                Currency,
                ExchangeRate,
                ExchangeRateLL,
                ExchangeRateEuro,
                Total,
                TotalF,
                TotalD,
                TotalLL,
                TotalEuro,
                TaxRate,
                TaxRateF,
                TaxValue,
                TaxValueF,
                TaxValueD,
                TaxValueLL,
                TaxValueEuro,
                NetIs,
                NetIsF,
                NetIsD,
                NetIsLL,
                NetIsEuro,
                NetIsAR,
                NetIsEN,
                DescriptionIs,
                Qtys
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Ref, FORMAT(@Ref, 'n0'), @DateIs, @DateIs, DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1),
             DATEFROMPARTS(YEAR(@DateIs), 1, 1), @FromWarehouseID, Company.f_WareHouseGetName(@FromWarehouseID),
             @ToWarehouseID, Company.f_WareHouseGetName(@ToWarehouseID), @UserID, Users.f_UserGetName(@UserID),
             @CurrencyID, Currencys.f_CurrencyGetName(@CurrencyID), @ExchangeRate, @ExchangeRateLL, @ExchangeRateEuro,
             @Total, Currencys.f_Format(@CurrencyID, @Total), @Total / @ExchangeRate,
             (@Total / @ExchangeRate) * @ExchangeRateLL, (@Total / @ExchangeRate) * @ExchangeRateEuro, @TaxRate,
             FORMAT(@TaxRate, '0.##') + N' %', @TaxValue, Currencys.f_Format(@CurrencyID, @TaxValue),
             @TaxValue / @ExchangeRate, (@TaxValue / @ExchangeRate) * @ExchangeRateLL,
             (@TaxValue / @ExchangeRate) * @ExchangeRateEuro, @NetIs, Currencys.f_Format(@CurrencyID, @NetIs),
             @NetIs / @ExchangeRate, (@NetIs / @ExchangeRate) * @ExchangeRateLL,
             (@NetIs / @ExchangeRate) * @ExchangeRateEuro, Currencys.f_ToWordAR(@NetIs, @CurrencyID, 1),
             Currencys.f_ToWordAR(@NetIs, @CurrencyID, 1), @DescriptionIs, @Qtys);

            SET @ID =
            (
                SELECT TOP (1) s.ID FROM @IDs AS s ORDER BY s.ID
            );

        END;

        BEGIN --Insert detail

            INSERT INTO Invoices.t_TransferAwaitedDetail
            (
                ID,
                TransferAwaitedID,
                ItemSharedID,
                ItemUnityID,
                Qty,
                QtyWithUnity,
                Qtys,
                Price,
                PriceF,
                PriceD,
                PriceLL,
                PriceEuro,
                DiscountIs,
                DiscountIsF,
                DiscountIsValue,
                DiscountIsValueF,
                DiscountIsValueD,
                DiscountIsValueLL,
                DiscountIsValueEuro,
                SubTotal,
                SubTotalF,
                SubTotalD,
                SubTotalLL,
                SubTotalEuro,
                TaxRate,
                TaxRateF,
                TaxValue,
                TaxValueF,
                TaxValueD,
                TaxValueLL,
                TaxValueEuro,
                Total,
                TotalF,
                TotalD,
                TotalLL,
                TotalEuro,
                DescriptionIs,
                SortAt
            )
            SELECT s.ID,
                   @ID,
                   s.ItemSharedID,
                   s.ItemUnityID,
                   s.Qty,
                   FORMAT(s.Qty, '#,##0.####') + ' ' + s2.Name,
                   s.Qtys,
                   s.Price,
                   Currencys.f_Format(@CurrencyID, s.Price),
                   s.Price / @ExchangeRate,
                   (s.Price / @ExchangeRate) * @ExchangeRateLL,
                   (s.Price / @ExchangeRate) * @ExchangeRateEuro,
                   s.DiscountIs,
                   FORMAT(s.DiscountIs, '0.##') + ' %',
                   s.DiscountIsValue,
                   Currencys.f_Format(@CurrencyID, s.DiscountIsValue),
                   s.DiscountIsValue / @ExchangeRate,
                   (s.DiscountIsValue / @ExchangeRate) * @ExchangeRateLL,
                   (s.DiscountIsValue / @ExchangeRate) * @ExchangeRateEuro,
                   s.SubTotal,
                   Currencys.f_Format(@CurrencyID, s.SubTotal),
                   s.SubTotal / @ExchangeRate,
                   (s.SubTotal / @ExchangeRate) * @ExchangeRateLL,
                   (s.SubTotal / @ExchangeRate) * @ExchangeRateEuro,
                   s.TaxRate,
                   FORMAT(s.TaxRate, '0.##') + ' %',
                   s.TaxValue,
                   Currencys.f_Format(@CurrencyID, s.TaxValue),
                   s.TaxValue / @ExchangeRate,
                   (s.TaxValue / @ExchangeRate) * @ExchangeRateLL,
                   (s.TaxValue / @ExchangeRate) * @ExchangeRateEuro,
                   s.Total,
                   Currencys.f_Format(@CurrencyID, s.Total),
                   s.Total / @ExchangeRate,
                   (s.Total / @ExchangeRate) * @ExchangeRateLL,
                   (s.Total / @ExchangeRate) * @ExchangeRateEuro,
                   s.DescriptionIs,
                   s.SortAt
            FROM @DetailIs AS s
                LEFT JOIN Items.t_UnityItem AS s1
                    ON s1.ID = s.ItemUnityID
                LEFT JOIN Items.t_Unity AS s2
                    ON s2.ID = s1.UnityID;

            INSERT INTO @ItemOut
            (
                ID,
                SharedID,
                Qty
            )
            SELECT s1.ID,
                   s.ItemSharedID,
                   0 - s.Qtys
            FROM Invoices.t_TransferAwaitedDetail AS s
                LEFT JOIN Items.t_Item AS s1
                    ON s1.SharedID = s.ItemSharedID
                       AND s1.WareHouseID = @FromWarehouseID
            WHERE s.TransferAwaitedID = @ID;

        END;

        BEGIN --Insert detial serial

            INSERT INTO Invoices.t_TransferAwaitedDetailSerial
            (
                TransferAwaitedID,
                TransferAwaitedDetailID,
                SerialID
            )
            SELECT @ID,
                   s.FatherID,
                   s.ID
            FROM @SerialIs AS s;

        END;

        BEGIN --Update item serial

            UPDATE Items.t_ItemSerial
            SET IsAvailable = 2,
                LastSectionID = @ID
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @SerialIs AS s WHERE s.ID = t_ItemSerial.ID
            );

        END;

        BEGIN --Rebuild statistics

            UPDATE Invoices.t_TransferAwaited
            SET ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Invoices.t_TransferAwaitedDetail AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.TransferAwaitedID = t_TransferAwaited.ID
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
            FROM @ItemOut AS s
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
            FROM @ItemOut AS s
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

            INSERT INTO Invoices.t_TransferMoving
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
