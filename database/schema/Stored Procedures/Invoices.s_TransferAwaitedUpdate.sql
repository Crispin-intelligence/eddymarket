SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_TransferAwaitedUpdate]
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
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY

        SET ANSI_WARNINGS OFF;

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @ItemOut AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                SharedID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL
            );

            DECLARE @ItemOutOld AS TABLE
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

            DECLARE @return INT,
                    @Total FLOAT,
                    @TaxRate DECIMAL(4, 2) = 0,
                    @TaxValue FLOAT,
                    @NetIs FLOAT,
                    @Qtys DECIMAL(18, 4),
                    @FromWarehouseIDOld UNIQUEIDENTIFIER;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @FromWarehouseIDOld = s.FromWarehouseID
            FROM Invoices.t_TransferAwaited AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

            INSERT INTO @ItemOutOld
            (
                ID,
                SharedID,
                Qty
            )
            SELECT s1.ID,
                   s.ItemSharedID,
                   s.Qtys
            FROM Invoices.t_TransferAwaitedDetail AS s
                LEFT JOIN Items.t_Item AS s1
                    ON s1.SharedID = s.ItemSharedID
                       AND s1.WareHouseID = @FromWarehouseIDOld
            WHERE s.TransferAwaitedID = @ID;

            SELECT @Total = COALESCE(SUM(s.SubTotal), 0),
                   @TaxValue = COALESCE(SUM(s.TaxValue), 0),
                   @NetIs = COALESCE(SUM(s.Total), 0),
                   @Qtys = COALESCE(SUM(s.Qtys), 0)
            FROM @DetailIs AS s;

            IF @Total > 0
            BEGIN

                SET @TaxRate = (@TaxValue / @Total) * 100;

            END;

        END;

        BEGIN --Update

            SET @return = 0;

            UPDATE Invoices.t_TransferAwaited
            SET DateIs = @DateIs,
                DateOnly = @DateIs,
                DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1),
                DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1),
                FromWarehouseID = @FromWarehouseID,
                FromWarehouse = Company.f_WareHouseGetName(@FromWarehouseID),
                ToWarehouseID = @ToWarehouseID,
                ToWarehouse = Company.f_WareHouseGetName(@ToWarehouseID),
                UserID = @UserID,
                UserIs = Users.f_UserGetName(@UserID),
                CurrencyID = @CurrencyID,
                Currency = Currencys.f_CurrencyGetName(@CurrencyID),
                ExchangeRate = @ExchangeRate,
                ExchangeRateLL = @ExchangeRateLL,
                ExchangeRateEuro = @ExchangeRateEuro,
                Total = @Total,
                TotalF = Currencys.f_Format(@CurrencyID, @Total),
                TotalD = @Total / @ExchangeRate,
                TotalLL = (@Total / @ExchangeRate) * @ExchangeRateLL,
                TotalEuro = (@Total / @ExchangeRate) * @ExchangeRateEuro,
                TaxRate = @TaxRate,
                TaxRateF = FORMAT(@TaxRate, '0.##') + N' %',
                TaxValue = @TaxValue,
                TaxValueF = Currencys.f_Format(@CurrencyID, @TaxValue),
                TaxValueD = @TaxValue / @ExchangeRate,
                TaxValueLL = (@TaxValue / @ExchangeRate) * @ExchangeRateLL,
                TaxValueEuro = (@TaxValue / @ExchangeRate) * @ExchangeRateEuro,
                NetIs = @NetIs,
                NetIsF = Currencys.f_Format(@CurrencyID, @NetIs),
                NetIsD = @NetIs / @ExchangeRate,
                NetIsLL = (@NetIs / @ExchangeRate) * @ExchangeRateLL,
                NetIsEuro = (@NetIs / @ExchangeRate) * @ExchangeRateEuro,
                NetIsAR = Currencys.f_ToWordAR(@NetIs, @CurrencyID, 1),
                NetIsEN = Currencys.f_ToWordAR(@NetIs, @CurrencyID, 1),
                DescriptionIs = @DescriptionIs,
                Qtys = @Qtys
            WHERE ID = @ID;

        END;

        BEGIN --Delete detial serial

            DELETE FROM Invoices.t_TransferAwaitedDetailSerial
            WHERE TransferAwaitedID = @ID;

        END;

        BEGIN --Insert detail

            MERGE Invoices.t_TransferAwaitedDetail AS t
            USING @DetailIs AS s
            ON s.ID = t.ID
            WHEN NOT MATCHED BY TARGET THEN
                INSERT
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
                VALUES
                (s.ID, @ID, s.ItemSharedID, s.ItemUnityID, s.Qty,
                 FORMAT(s.Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID), s.Qtys, s.Price,
                 Currencys.f_Format(@CurrencyID, s.Price), s.Price / @ExchangeRate,
                 (s.Price / @ExchangeRate) * @ExchangeRateLL, (s.Price / @ExchangeRate) * @ExchangeRateEuro,
                 s.DiscountIs, FORMAT(s.DiscountIs, '0.##') + ' %', s.DiscountIsValue,
                 Currencys.f_Format(@CurrencyID, s.DiscountIsValue), s.DiscountIsValue / @ExchangeRate,
                 (s.DiscountIsValue / @ExchangeRate) * @ExchangeRateLL,
                 (s.DiscountIsValue / @ExchangeRate) * @ExchangeRateEuro, s.SubTotal,
                 Currencys.f_Format(@CurrencyID, s.SubTotal), s.SubTotal / @ExchangeRate,
                 (s.SubTotal / @ExchangeRate) * @ExchangeRateLL, (s.SubTotal / @ExchangeRate) * @ExchangeRateEuro,
                 s.TaxRate, FORMAT(s.TaxRate, '0.##') + ' %', s.TaxValue, Currencys.f_Format(@CurrencyID, s.TaxValue),
                 s.TaxValue / @ExchangeRate, (s.TaxValue / @ExchangeRate) * @ExchangeRateLL,
                 (s.TaxValue / @ExchangeRate) * @ExchangeRateEuro, s.Total, Currencys.f_Format(@CurrencyID, s.Total),
                 s.Total / @ExchangeRate, (s.Total / @ExchangeRate) * @ExchangeRateLL,
                 (s.Total / @ExchangeRate) * @ExchangeRateEuro, s.DescriptionIs, s.SortAt)
            WHEN MATCHED THEN
                UPDATE SET t.ItemUnityID = s.ItemUnityID,
                           t.Qty = s.Qty,
                           t.QtyWithUnity = FORMAT(s.Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID),
                           t.Qtys = s.Qtys,
                           t.Price = s.Price,
                           t.PriceF = Currencys.f_Format(@CurrencyID, s.Price),
                           t.PriceD = s.Price / @ExchangeRate,
                           t.PriceLL = (s.Price / @ExchangeRate) * @ExchangeRateLL,
                           t.PriceEuro = (s.Price / @ExchangeRate) * @ExchangeRateEuro,
                           t.DiscountIs = s.DiscountIs,
                           t.DiscountIsF = FORMAT(s.DiscountIs, '0.##') + ' %',
                           t.DiscountIsValue = s.DiscountIsValue,
                           t.DiscountIsValueF = Currencys.f_Format(@CurrencyID, s.DiscountIsValue),
                           t.DiscountIsValueD = s.DiscountIsValue / @ExchangeRate,
                           t.DiscountIsValueLL = (s.DiscountIsValue / @ExchangeRate) * @ExchangeRateLL,
                           t.DiscountIsValueEuro = (s.DiscountIsValue / @ExchangeRate) * @ExchangeRateEuro,
                           t.SubTotal = s.SubTotal,
                           t.SubTotalF = Currencys.f_Format(@CurrencyID, s.SubTotal),
                           t.SubTotalD = s.SubTotal / @ExchangeRate,
                           t.SubTotalLL = (s.SubTotal / @ExchangeRate) * @ExchangeRateLL,
                           t.SubTotalEuro = (s.SubTotal / @ExchangeRate) * @ExchangeRateEuro,
                           t.TaxRate = s.TaxRate,
                           t.TaxRateF = FORMAT(s.TaxRate, '0.##') + ' %',
                           t.TaxValue = s.TaxValue,
                           t.TaxValueF = Currencys.f_Format(@CurrencyID, s.TaxValue),
                           t.TaxValueD = s.TaxValue / @ExchangeRate,
                           t.TaxValueLL = (s.TaxValue / @ExchangeRate) * @ExchangeRateLL,
                           t.TaxValueEuro = (s.TaxValue / @ExchangeRate) * @ExchangeRateEuro,
                           t.Total = s.Total,
                           t.TotalF = Currencys.f_Format(@CurrencyID, s.Total),
                           t.TotalD = s.Total / @ExchangeRate,
                           t.TotalLL = (s.Total / @ExchangeRate) * @ExchangeRateLL,
                           t.TotalEuro = (s.Total / @ExchangeRate) * @ExchangeRateEuro,
                           t.DescriptionIs = s.DescriptionIs,
                           t.SortAt = s.SortAt
            WHEN NOT MATCHED BY SOURCE AND t.TransferAwaitedID = @ID THEN
                DELETE;

            INSERT INTO @ItemOut
            (
                ID,
                SharedID,
                Qty
            )
            SELECT s1.ID,
                   s.ItemSharedID,
                   s.Qtys
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
            SET IsAvailable = 1,
                LastSectionID = '00000000-0000-0000-0000-000000000000'
            WHERE LastSectionID = @ID;

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
            SELECT o.ID,
                   COALESCE(SUM(o.Qty), 0)
            FROM
            (
                SELECT s.ID,
                       s.Qty
                FROM @ItemOut AS s
                UNION ALL
                SELECT s.ID,
                       0 - s.Qty
                FROM @ItemOutOld AS s
            ) AS o
            GROUP BY o.ID;

            MERGE Items.t_Item AS t
            USING @ItemQtyNet AS s
            ON s.ID = t.ID
               AND t.TypeIs = 0
            WHEN MATCHED THEN
                UPDATE SET t.QtyCurrent -= s.Qty;

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
                       s.Qty
                FROM @ItemOut AS s
                UNION ALL
                SELECT s.SharedID,
                       0 - s.Qty
                FROM @ItemOutOld AS s
            ) AS o
            GROUP BY o.SharedID;

            MERGE Items.t_ItemShared AS t
            USING @ItemQtyNet AS s
            ON s.ID = t.ID
               AND t.TypeIs = 0
            WHEN MATCHED THEN
                UPDATE SET t.QtyCurrent -= s.Qty,
                           t.PurchaseTotal = t.Purchase * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalF = Currencys.f_Format(t.CurrencyID, t.Purchase * (t.QtyCurrent - s.Qty)),
                           t.PurchaseTotalD = t.PurchaseD * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalLL = t.PurchaseLL * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalEuro = t.PurchaseEuro * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalWithTax = t.PurchaseWithTax * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalWithTaxF = Currencys.f_Format(
                                                                           t.CurrencyID,
                                                                           t.PurchaseWithTax * (t.QtyCurrent - s.Qty)
                                                                       ),
                           t.PurchaseTotalWithTaxD = t.PurchaseWithTaxD * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalWithTaxLL = t.PurchaseWithTaxLL * (t.QtyCurrent - s.Qty),
                           t.PurchaseTotalWithTaxEuro = t.PurchaseWithTaxEuro * (t.QtyCurrent - s.Qty),
                           t.SellTotal = t.Sell * (t.QtyCurrent - s.Qty),
                           t.SellTotalF = Currencys.f_Format(
                                                                [Items].[f_UnityItemGetCurrencyID](t.ID),
                                                                t.Sell * (t.QtyCurrent - s.Qty)
                                                            ),
                           t.SellTotalD = t.SellD * (t.QtyCurrent - s.Qty),
                           t.SellTotalLL = t.SellLL * (t.QtyCurrent - s.Qty),
                           t.SellTotalEuro = t.SellEuro * (t.QtyCurrent - s.Qty),
                           t.SellTotalWithTax = t.SellWithTax * (t.QtyCurrent - s.Qty),
                           t.SellTotalWithTaxF = Currencys.f_Format(
                                                                       t.SellCurrencyID,
                                                                       t.SellWithTax * (t.QtyCurrent - s.Qty)
                                                                   ),
                           t.SellTotalWithTaxD = t.SellWithTaxD * (t.QtyCurrent - s.Qty),
                           t.SellTotalWithTaxLL = t.SellWithTaxLL * (t.QtyCurrent - s.Qty),
                           t.SellTotalWithTaxEuro = t.SellWithTaxEuro * (t.QtyCurrent - s.Qty);
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
