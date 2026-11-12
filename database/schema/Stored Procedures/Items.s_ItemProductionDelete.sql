SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemProductionDelete]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @EventType TINYINT,
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

            DECLARE @ItemID UNIQUEIDENTIFIER,
                    @ItemSharedID UNIQUEIDENTIFIER,
                    @Qtys FLOAT,
                    @Return INT;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @ItemID = s.ItemID,
                   @ItemSharedID = s.ItemSharedID,
                   @Qtys = s.Qtys
            FROM Items.t_ItemProduction AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Items.t_ItemProductionSerial
            WHERE ItemProductionID = @ID;

            DELETE FROM Items.t_ItemSerial
            WHERE SectionType = 155
                  AND LinkID = @ID;

            DELETE FROM Items.t_ItemProductionMaterial
            OUTPUT Deleted.ItemID,
                   Deleted.ItemSharedID,
                   Deleted.Qtys
            INTO @ItemQty
            WHERE ItemProductionID = @ID;

            DELETE FROM Items.t_ItemProduction
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

            UPDATE Items.t_Item
            SET QtyCurrent -= @Qtys
            WHERE ID = @ItemID
                  AND TypeIs = 0;

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
                UPDATE SET t.QtyCurrent += s.Qty;

            UPDATE Items.t_ItemShared
            SET QtyCurrent -= @Qtys
            WHERE ID = @ItemSharedID
                  AND TypeIs = 0;

            UPDATE Items.t_ItemShared
            SET PurchaseTotal = Purchase * QtyCurrent,
                PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent),
                PurchaseTotalD = PurchaseD * QtyCurrent,
                PurchaseTotalLL = PurchaseLL * QtyCurrent,
                PurchaseTotalEuro = PurchaseEuro * QtyCurrent,
                PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent,
                PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent),
                PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent,
                PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent,
                PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent,
                SellTotal = Sell * QtyCurrent,
                SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](ID), Sell * QtyCurrent),
                SellTotalD = SellD * QtyCurrent,
                SellTotalLL = SellLL * QtyCurrent,
                SellTotalEuro = SellEuro * QtyCurrent,
                SellTotalWithTax = SellWithTax * QtyCurrent,
                SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent),
                SellTotalWithTaxD = SellWithTaxD * QtyCurrent,
                SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent,
                SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
            WHERE ID = @ItemSharedID
                  OR EXISTS
            (
                SELECT TOP (1) s.ID FROM @ItemQtyNet AS s WHERE s.ID = t_ItemShared.ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_ItemProductionMoving
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
            (@UserID, @ID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount);

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
