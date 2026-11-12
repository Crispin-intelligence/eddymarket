SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_TransferAwaitedDelete]
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

            DECLARE @ItemQty AS TABLE
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

            DECLARE @Return INT,
                    @FromWarehouseID UNIQUEIDENTIFIER;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @FromWarehouseID = s.FromWarehouseID
            FROM Invoices.t_TransferAwaited AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

            INSERT INTO @ItemQty
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

        BEGIN -- Update t_ItemSerial

            UPDATE Items.t_ItemSerial
            SET IsAvailable = 1,
                LastSectionID = '00000000-0000-0000-0000-000000000000'
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM Invoices.t_TransferAwaitedDetailSerial AS s
                WHERE s.SerialID = t_ItemSerial.ID
            );

        END;

        BEGIN --Delete

            SET @Return = 0;

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
            FROM @ItemQty AS s
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
            FROM @ItemQty AS s
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
            (@UserID, @ID, @Event, 2, @ComputerIP, @Computer, @ComputerAccount);

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
