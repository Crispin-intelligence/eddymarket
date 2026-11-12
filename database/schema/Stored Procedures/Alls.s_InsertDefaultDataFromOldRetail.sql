SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_InsertDefaultDataFromOldRetail]
AS
BEGIN

    BEGIN --Create table

        DROP TABLE Items.oldItem;

        CREATE TABLE Items.oldItem
        (
            name NVARCHAR(MAX),
            Barcode NVARCHAR(MAX),
            PriceSell FLOAT,
            PricePurchase FLOAT
        );

    --Names of columns from old data
    --Name2 = name
    --Code = Barcode
    --genpri = PricePurchase
    --Price2 = PriceSell
    --qtt = Qty
    --kind = mainCategoryID & subCategoryID

    END;

    BEGIN --Fix data

        DELETE FROM Items.oldItem
        WHERE PriceSell IS NULL
              OR PricePurchase IS NULL;

        WITH o
        AS (SELECT ROW_NUMBER() OVER (PARTITION BY Barcode ORDER BY (SELECT 0)) RN
            FROM Items.oldItem)
        DELETE FROM o
        WHERE RN > 1;

    END;

    BEGIN --Insert shared item

        DELETE Items.t_ItemShared;

        INSERT INTO Items.t_ItemShared
        (
            Name,
            Barcode,
            Sell,
            SellD,
            Purchase,
            PurchaseD,
            CurrencyID
        )
        SELECT t.name,
               t.Barcode,
               t.PriceSell,
               t.PriceSell / 1500.0,
               t.PricePurchase,
               t.PricePurchase / 1500.0,
               Currencys.f_CurrencyGetFirstIDLL()
        FROM Items.oldItem AS t;

    END;

    BEGIN --Insert item

        DELETE Items.t_Item;

        INSERT INTO Items.t_Item
        (
            SharedID
        )
        SELECT t.ID
        FROM Items.t_ItemShared AS t;

    END;

    BEGIN --Insert barcode

        DELETE Items.t_ItemSharedBarCode;

        INSERT INTO Items.t_ItemSharedBarCode
        (
            SharedID,
            BarCode,
            BarcodeNumber
        )
        SELECT ID,
               Barcode,
               Alls.f_ToBigint(Barcode)
        FROM Items.t_ItemShared;

    END;

    BEGIN --Insert unit

        DELETE Items.t_UnityItem;

        INSERT INTO Items.t_UnityItem
        (
            SharedID,
            CurrencyID
        )
        SELECT ID,
               Currencys.f_CurrencyGetFirstIDLL()
        FROM Items.t_ItemShared;

    END;

END;
GO
