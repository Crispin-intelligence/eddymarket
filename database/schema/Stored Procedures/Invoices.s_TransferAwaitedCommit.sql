SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_TransferAwaitedCommit]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT,
                    @Ref NVARCHAR(MAX),
                    @ToWarehouseID UNIQUEIDENTIFIER;

            DECLARE @ItemIn AS TABLE
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

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @Ref = s.RefF,
                   @ToWarehouseID = s.ToWarehouseID
            FROM Invoices.t_TransferAwaited AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

            INSERT INTO @ItemIn
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
                       AND s1.WareHouseID = @ToWarehouseID
            WHERE s.TransferAwaitedID = @ID;

        END;

        BEGIN --Insert Transfer

            SET @Return = 0;

            INSERT INTO Invoices.t_Transfer
            (
                ID,
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
                ItemsNames,
                Qtys,
                DateCreate,
                WorkStationID
            )
            SELECT t.ID,
                   t.Ref,
                   t.RefF,
                   t.DateIs,
                   t.DateOnly,
                   t.DateMonthly,
                   t.DateYearly,
                   t.FromWarehouseID,
                   t.FromWarehouse,
                   t.ToWarehouseID,
                   t.ToWarehouse,
                   t.UserID,
                   t.UserIs,
                   t.CurrencyID,
                   t.Currency,
                   t.ExchangeRate,
                   t.ExchangeRateLL,
                   t.ExchangeRateEuro,
                   t.Total,
                   t.TotalF,
                   t.TotalD,
                   t.TotalLL,
                   t.TotalEuro,
                   t.TaxRate,
                   t.TaxRateF,
                   t.TaxValue,
                   t.TaxValueF,
                   t.TaxValueD,
                   t.TaxValueLL,
                   t.TaxValueEuro,
                   t.NetIs,
                   t.NetIsF,
                   t.NetIsD,
                   t.NetIsLL,
                   t.NetIsEuro,
                   t.NetIsAR,
                   t.NetIsEN,
                   t.DescriptionIs,
                   t.ItemsNames,
                   t.Qtys,
                   t.DateCreate,
                   t.WorkStationID
            FROM Invoices.t_TransferAwaited AS t
            WHERE t.ID = @ID;

        END;

        BEGIN --Insert Detail

            SET @Return = -2;

            INSERT INTO Invoices.t_TransferDetail
            (
                ID,
                TransferID,
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
                SortAt,
                DateCreate,
                WorkStationID
            )
            SELECT t.ID,
                   t.TransferAwaitedID,
                   t.ItemSharedID,
                   t.ItemUnityID,
                   t.Qty,
                   t.QtyWithUnity,
                   t.Qtys,
                   t.Price,
                   t.PriceF,
                   t.PriceD,
                   t.PriceLL,
                   t.PriceEuro,
                   t.DiscountIs,
                   t.DiscountIsF,
                   t.DiscountIsValue,
                   t.DiscountIsValueF,
                   t.DiscountIsValueD,
                   t.DiscountIsValueLL,
                   t.DiscountIsValueEuro,
                   t.SubTotal,
                   t.SubTotalF,
                   t.SubTotalD,
                   t.SubTotalLL,
                   t.SubTotalEuro,
                   t.TaxRate,
                   t.TaxRateF,
                   t.TaxValue,
                   t.TaxValueF,
                   t.TaxValueD,
                   t.TaxValueLL,
                   t.TaxValueEuro,
                   t.Total,
                   t.TotalF,
                   t.TotalD,
                   t.TotalLL,
                   t.TotalEuro,
                   t.DescriptionIs,
                   t.SortAt,
                   t.DateCreate,
                   t.WorkStationID
            FROM Invoices.t_TransferAwaitedDetail AS t
            WHERE t.TransferAwaitedID = @ID;

            INSERT INTO Invoices.t_TransferDetailSerial
            (
                ID,
                TransferID,
                TransferDetailID,
                SerialID,
                DateCreate,
                WorkStationID
            )
            SELECT s.ID,
                   s.TransferAwaitedID,
                   s.TransferAwaitedDetailID,
                   s.SerialID,
                   s.DateCreate,
                   s.WorkStationID
            FROM Invoices.t_TransferAwaitedDetailSerial AS s;

        END;

        BEGIN -- Update t_ItemSerial

            UPDATE Items.t_ItemSerial
            SET IsAvailable = 1,
                ItemID = Items.f_ItemGetID(ItemSharedID, @ToWarehouseID),
                LastSectionID = '00000000-0000-0000-0000-000000000000'
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM Invoices.t_TransferAwaitedDetailSerial AS s
                WHERE s.SerialID = t_ItemSerial.ID
            );

        END;

        BEGIN --Delete Transfer Awaited

            DELETE FROM Invoices.t_TransferAwaitedDetailSerial
            WHERE TransferAwaitedID = @ID;

            DELETE FROM Invoices.t_TransferAwaitedDetail
            WHERE TransferAwaitedID = @ID;

            DELETE FROM Invoices.t_TransferAwaited
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
            FROM @ItemIn AS s
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
            FROM @ItemIn AS s
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

            SET @Return = -1;

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
            (@UserID, @ID, @Event + N': ' + @Ref, 2, @ComputerIP, @Computer, @ComputerAccount);

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
