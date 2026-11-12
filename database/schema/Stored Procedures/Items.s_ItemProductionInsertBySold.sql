SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemProductionInsertBySold] @ProductionWhenSale BIT ,
  @SoldID UNIQUEIDENTIFIER ,
  @SoldRef BIGINT ,
  @DateIs DATETIME ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Currency NVARCHAR(MAX) ,
  @CurrencyTypeIs INT ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @DetailIs Invoices.tt_SoldDetail READONLY ,
  @UserID UNIQUEIDENTIFIER ,
  @EventInsert NVARCHAR(MAX) ,
  @EventInsertBySold NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN

  IF @ProductionWhenSale = 0
  BEGIN

    RETURN 0;

  END;

  IF NOT EXISTS ( SELECT TOP ( 1 ) s.ID
                    FROM @DetailIs AS s
                    INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
                    WHERE s1.MaterialsCounts > 0 )
  BEGIN

    RETURN 0;

  END;
                    
  BEGIN --Declare
    
    DECLARE @IDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

    DECLARE @SavedIDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        RefF NVARCHAR(MAX) NOT NULL
      );

    DECLARE @ID UNIQUEIDENTIFIER ,
      @DetailID UNIQUEIDENTIFIER ,
      @Ref BIGINT ,
      @EmployeeID UNIQUEIDENTIFIER ,
      @Employee NVARCHAR(MAX) ,
      @User NVARCHAR(MAX) ,
      @ItemSharedID UNIQUEIDENTIFIER ,
      @ItemID UNIQUEIDENTIFIER ,
      @ItemUnityID UNIQUEIDENTIFIER ,
      @Qty DECIMAL(18, 4) ,
      @Qtys DECIMAL(18, 4) ,
      @WarehouseID UNIQUEIDENTIFIER ,
      @Cost FLOAT ,
      @CostD FLOAT ,
      @CostTotal FLOAT ,
      @CostTotalD FLOAT;
   
    DECLARE @Item AS TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        SharedID UNIQUEIDENTIFIER NOT NULL ,
        Qty DECIMAL(18, 4) NOT NULL
      );

    DECLARE @ItemQtyNet AS TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        Qty DECIMAL(18, 4) NOT NULL
      );

  END;

  BEGIN --Set info

    SELECT @EmployeeID = Employees.f_EmployeeGetFirstID();
    SELECT @Employee = Employees.f_EmployeeGetName(@EmployeeID);
    SELECT @User = Users.f_UserGetName(@UserID);
	  
  END;

  DECLARE i CURSOR FORWARD_ONLY
  FOR
  SELECT s.ID
    FROM @DetailIs AS s
    INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
    WHERE s1.IsSerial = 0 AND s1.MaterialsCounts > 0;

  OPEN i;
  FETCH NEXT FROM i
    INTO @DetailID;
  WHILE @@FETCH_STATUS = 0
  BEGIN
	
    BEGIN --Set info

      SELECT @Ref = ISNULL(MAX(s.Ref), 0) + 1
        FROM Items.t_ItemProduction AS s;
	  
      SELECT TOP ( 1 ) @ItemSharedID = s.ItemSharedID ,
          @ItemID = s.ItemID ,
          @ItemUnityID = s.ItemUnityID ,
          @Qty = s.Qty ,
          @Qtys = s.Qtys ,
          @WarehouseID = s1.WareHouseID ,
          @Cost = s.Cost
        FROM @DetailIs AS s
        INNER JOIN Items.t_Item AS s1 ON s1.ID = s.ItemID
        WHERE s.ID = @DetailID;
		
      SET @CostD = @Cost / @ExchangeRate;
      SET @CostTotal = @Cost * @Qty;
      SET @CostTotalD = @CostTotal / @ExchangeRate;

    END;

    BEGIN --Insert t_ItemProduction

      DELETE FROM @IDs;

      INSERT INTO Items.t_ItemProduction
          ( Ref ,
            SoldID ,
            SoldRef ,
            SoldDetailID ,
            DateIs ,
            EmployeeID ,
            Employee ,
            ItemSharedID ,
            ItemID ,
            ItemUnityID ,
            Qty ,
            Qtys ,
            WarehouseID ,
            CurrencyID ,
            Currency ,
            ExchangeRate ,
            ExchangeRateLL ,
            ExchangeRateEuro ,
            Cost ,
            CostD ,
            CostLL ,
            CostEuro ,
            TotalCost ,
            TotalCostD ,
            TotalCostLL ,
            TotalCostEuro ,
            CreateByID ,
            CreateBy ,
            HaveSerial
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Ref ,
            @SoldID ,
            @SoldRef ,
            @DetailID ,
            @DateIs ,
            @EmployeeID ,
            @Employee ,
            @ItemSharedID ,
            @ItemID ,
            @ItemUnityID ,
            @Qty ,
            @Qtys ,
            @WarehouseID ,
            @CurrencyID ,
            @Currency ,
            @ExchangeRate ,
            @ExchangeRateLL ,
            @ExchangeRateEuro ,
            @Cost ,
            @CostD ,
            @CostD * @ExchangeRateLL ,
            @CostD * @ExchangeRateEuro ,
            @CostTotal ,
            @CostTotalD ,
            @CostTotalD * @ExchangeRateLL ,
            @CostTotalD * @ExchangeRateEuro ,
            @UserID ,
            @User ,
            0
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

      INSERT INTO @SavedIDs
          ( ID, RefF )
        VALUES ( @ID, FORMAT(@Ref, 'n0') );
   
    END;
	
    BEGIN --Fix t_Item, t_ItemShared +
       
      UPDATE Items.t_Item
        SET QtyCurrent += @Qtys
        WHERE ID = @ItemID AND TypeIs = 0;
    
      UPDATE Items.t_ItemShared
        SET QtyCurrent += @Qtys
        WHERE ID = @ItemSharedID AND TypeIs = 0;

    END; 
   
    BEGIN --Insert t_ItemProductionMaterial

      DELETE FROM @Item;

      INSERT INTO Items.t_ItemProductionMaterial
          ( ItemProductionID ,
            ItemSharedID ,
            ItemID ,
            ItemUnityID ,
            Qty ,
            Qtys ,
            WarehouseID ,
            Cost ,
            TotalCost ,
            SortAt
          )
        OUTPUT Inserted.ItemID ,
          Inserted.ItemSharedID ,
          Inserted.Qtys
          INTO @Item
        SELECT @ID ,
            s.ItemSharedID ,
            s2.ID ,
            s.ItemUnityID ,
            s.Qty * @Qtys ,
            s.Qtys * @Qtys ,
            @WarehouseID ,
            CASE @CurrencyTypeIs
              WHEN 0 THEN s1.PurchaseD
              WHEN 1 THEN s1.PurchaseLL
              ELSE s1.PurchaseEuro
            END * s3.Qty ,
            ( CASE @CurrencyTypeIs
                WHEN 0 THEN s1.PurchaseD
                WHEN 1 THEN s1.PurchaseLL
                ELSE s1.PurchaseEuro
              END * s3.Qty ) * ( s.Qty * @Qtys ) ,
            ROW_NUMBER() OVER ( ORDER BY ( SELECT 1
                                         ) )
          FROM Items.t_ItemSharedMaterial AS s
          INNER JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
          INNER JOIN Items.t_Item AS s2 ON s2.SharedID = s1.ID AND s2.WareHouseID = @WarehouseID
          LEFT JOIN Items.t_UnityItem AS s3 ON s3.ID = s.ItemUnityID
          WHERE s.ItemSharedFatherID = @ItemSharedID;

    END;

    BEGIN --Fix item qty

      DELETE FROM @ItemQtyNet;

      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT s.ID ,
            COALESCE(SUM(s.Qty), 0)
          FROM @Item AS s
          GROUP BY s.ID;

      MERGE Items.t_Item AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET t.QtyCurrent -= s.Qty;

    END;

    BEGIN --Fix shared item qty
		
      INSERT INTO @ItemQtyNet
          ( ID ,
            Qty
          )
        SELECT s.SharedID ,
            COALESCE(SUM(s.Qty), 0)
          FROM @Item AS s
          GROUP BY s.SharedID;

      MERGE Items.t_ItemShared AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET t.QtyCurrent -= s.Qty;

    END;
	
    FETCH NEXT FROM i
        INTO @DetailID;
  END;
  CLOSE i;
  DEALLOCATE i;

  BEGIN --Fix t_ItemShared
	  
    UPDATE Items.t_ItemShared
      SET PurchaseTotal = Purchase * QtyCurrent ,
          PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
          PurchaseTotalD = PurchaseD * QtyCurrent ,
          PurchaseTotalLL = PurchaseLL * QtyCurrent ,
          PurchaseTotalEuro = PurchaseEuro * QtyCurrent ,
          PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
          PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
          PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
          PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
          PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent ,
          SellTotal = Sell * QtyCurrent ,
          SellTotalF = Currencys.f_Format([Items].[f_UnityItemGetCurrencyID](ID), Sell * QtyCurrent) ,
          SellTotalD = SellD * QtyCurrent ,
          SellTotalLL = SellLL * QtyCurrent ,
          SellTotalEuro = SellEuro * QtyCurrent ,
          SellTotalWithTax = SellWithTax * QtyCurrent ,
          SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent) ,
          SellTotalWithTaxD = SellWithTaxD * QtyCurrent ,
          SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent ,
          SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                      FROM @DetailIs AS s
                      LEFT JOIN Items.t_ItemShared AS s1 ON s1.ID = s.ItemSharedID
                      WHERE s.ItemSharedID = t_ItemShared.ID AND s1.MaterialsCounts > 0 );

  END;

  BEGIN --Fix t_ItemProduction, t_ItemProductionMaterial
	     
    UPDATE Items.t_ItemProduction
      SET RefF = FORMAT(Ref, 'n0') ,
          SoldRefF = FORMAT(SoldRef, 'n0') ,
          DateOnly = DateIs ,
          DateMonthly = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
          DateYearly = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
          QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(ItemUnityID) ,
          Warehouse = Company.f_WareHouseGetName(WarehouseID) ,
          CostF = Currencys.f_Format(CurrencyID, Cost) ,
          TotalCostF = Currencys.f_Format(CurrencyID, TotalCost) ,
          ItemsNames = Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                        FROM Items.t_ItemProductionMaterial AS t
                                        LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                        WHERE t.ItemProductionID = t_ItemProduction.ID
                                     FOR
                                       XML PATH('')
                                     )) ,
          ItemsCounts = ( SELECT COUNT(*)
                            FROM Items.t_ItemProductionMaterial AS t
                            WHERE t.ItemProductionID = t_ItemProduction.ID
                        )
      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                      FROM @SavedIDs AS s
                      WHERE s.ID = t_ItemProduction.ID );
   
    UPDATE Items.t_ItemProductionMaterial
      SET QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(ItemUnityID) ,
          Warehouse = Company.f_WareHouseGetName(WarehouseID) ,
          CostF = Currencys.f_Format(@CurrencyID, Cost) ,
          CostD = Cost / @ExchangeRate ,
          TotalCostF = Currencys.f_Format(@CurrencyID, TotalCost) ,
          TotalCostD = TotalCost / @ExchangeRate
      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                      FROM @SavedIDs AS s
                      WHERE s.ID = Items.t_ItemProductionMaterial.ItemProductionID );
     
    UPDATE Items.t_ItemProductionMaterial
      SET CostLL = CostD * @ExchangeRateLL ,
          CostEuro = CostD * @ExchangeRateEuro ,
          TotalCostLL = TotalCostD * @ExchangeRateLL ,
          TotalCostEuro = TotalCostD * @ExchangeRateEuro
      WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                      FROM @SavedIDs AS s
                      WHERE s.ID = Items.t_ItemProductionMaterial.ItemProductionID );

  END;
	 
  BEGIN --Insert event

    INSERT INTO Items.t_ItemProductionMoving
        ( UserID ,
          SectionID ,
          EventIs ,
          EventType ,
          ComputerIP ,
          Computer ,
          ComputerAccount
        )
      SELECT @UserID ,
          s.ID ,
          @EventInsert + N': ' + s.RefF + N' (' + @EventInsertBySold + N': ' + FORMAT(@SoldRef, N'n0') + N')' ,
          0 ,
          @ComputerIP ,
          @Computer ,
          @ComputerAccount
        FROM @SavedIDs AS s;

  END;
  
  RETURN 1;

END;




GO
