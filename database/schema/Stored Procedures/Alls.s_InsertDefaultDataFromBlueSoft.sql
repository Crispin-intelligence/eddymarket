SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Alls].[s_InsertDefaultDataFromBlueSoft]
AS
BEGIN

    SELECT 0;

    --  BEGIN --Insert shared item

    --      INSERT INTO Items.t_ItemShared
    --      (
    --          Name,
    --          Barcode,
    --          InList,
    --          IsSerial,
    --          IsExpiryDate,
    --          NetWeight,
    --          SizeIs,
    --          CurrencyID,
    --          Purchase,
    --          PurchaseD,
    --          SellCurrencyID,
    --          Sell,
    --          SellD,
    --          StandardSalePrice,
    --          Discount,
    --          ImageIs,
    --          DescriptionAR,
    --          DescriptionEN
    --      )
    --      SELECT t.Name,
    --             t.Barcode,
    --             t.InList,
    --             t.Serial,
    --             t.IsExpirationDate,
    --             t.WeightIs,
    --             t.SizeIs,
    --             CASE t1.BaseID
    --                 WHEN 0 THEN
    --                     Currencys.f_CurrencyGetFirstIDD()
    --                 WHEN 1 THEN
    --                     Currencys.f_CurrencyGetFirstIDLL()
    --                 ELSE
    --                     Currencys.f_CurrencyGetFirstIDEuro()
    --             END,
    --             t.Purchase,
    --             t.PurchaseD,
    --             CASE t1.BaseID
    --                 WHEN 0 THEN
    --                     Currencys.f_CurrencyGetFirstIDD()
    --                 WHEN 1 THEN
    --                     Currencys.f_CurrencyGetFirstIDLL()
    --                 ELSE
    --                     Currencys.f_CurrencyGetFirstIDEuro()
    --             END,
    --             t.Sell,
    --             t.SellD,
    --             t.PriceStatic,
    --             t.Discount,
    --             t.Image,
    --             t.Description,
    --             t.DescriptionEN
    --      FROM Retail2019.Items.t_ItemsShared AS t
    --          LEFT JOIN Retail2019.Currencys.t_Currency AS t1
    --              ON t1.CurrencyID = t.CurrencyID;

    --  END;

    --  BEGIN --Insert item

    --      INSERT INTO Items.t_Item
    --      (
    --          SharedID
    --      )
    --      SELECT t.ID
    --      FROM Items.t_ItemShared AS t;

    --  END;

   -- BEGIN --Insert barcode

   --     INSERT INTO Items.t_ItemSharedBarCode
   --     (
   --         SharedID,
   --         BarCode,
			--BarcodeNumber
   --     )
   --     SELECT ID,
   --            Barcode,
   --            Alls.f_ToBigint(Barcode)
   --     FROM Items.t_ItemShared;

   -- END;

--  BEGIN --Delete Units

--      DELETE FROM Items.t_Unity;

--  END;

--  BEGIN --Insert unit

--      INSERT INTO Items.t_Unity
--      (
--          Name,
--          DescriptionIs
--      )
--      SELECT t.Name,
--             t.DescriptionIs
--      FROM Retail2019.Items.t_Unity AS t;

--      INSERT INTO Items.t_UnityItem
--      (
--          UnityID,
--	Unity,
--          SharedID,
--          Qty,
--          PrimaryIs,
--          Purchasing,
--          Sold,
--          Inventory,
--          UseInTransfer,
--          CurrencyID,
--          Price,
--          PriceD
--      )
--      SELECT t2.ID,
--t2.Name,
--             t4.ID,
--             t.UnityQty,
--             t.UnityPrimary,
--             t.UnityPurchasing,
--             t.UnitySold,
--             t.UnityInventory,
--             CONVERT(   BIT,
--                        CASE t.UnityQty
--                            WHEN 1 THEN
--                                1
--                            ELSE
--                                0
--                        END
--                    ),
--             t4.SellCurrencyID,
--             t4.Sell * t.UnityQty,
--             t4.SellD * t.UnityQty
--      FROM Retail2019.Items.t_UnityItems AS t
--          LEFT JOIN Retail2019.Items.t_Unity AS t1
--              ON t1.ID = t.UnityUnityID
--          LEFT JOIN Items.t_Unity AS t2
--              ON t2.Name = t1.Name
--          LEFT JOIN Retail2019.Items.t_ItemsShared AS t3
--              ON t3.ID = t.UnityItemSharedID
--          LEFT JOIN Items.t_ItemShared AS t4
--              ON t4.Barcode = t3.Barcode;

--  END;

END;
GO
