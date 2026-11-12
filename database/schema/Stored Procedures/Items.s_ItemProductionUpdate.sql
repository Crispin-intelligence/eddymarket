SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemProductionUpdate]
  @RefPaper NVARCHAR(MAX) ,
  @DateIs DATETIME ,
  @EmployeeID UNIQUEIDENTIFIER ,
  @ItemSharedID UNIQUEIDENTIFIER ,
  @ItemID UNIQUEIDENTIFIER ,
  @ItemUnityID UNIQUEIDENTIFIER ,
  @Qty DECIMAL(18, 4) ,
  @Qtys DECIMAL(18, 4) ,
  @WarehouseID UNIQUEIDENTIFIER ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @TotalCost FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @SerialIs Items.tt_ItemSerial READONLY ,
  @Material Items.tt_ItemProductionMaterial READONLY ,
  @MaterialSerial Items.tt_ItemSerial READONLY ,
  @HaveSerial BIT ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Item AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          SharedID UNIQUEIDENTIFIER NOT NULL ,
          Qty DECIMAL(18, 4) NOT NULL
        );

      DECLARE @ItemQtyOld AS TABLE
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

      DECLARE @ItemIDOld UNIQUEIDENTIFIER ,
        @ItemSharedIDOld UNIQUEIDENTIFIER ,
        @QtysOld DECIMAL(18, 4) ,
        @Currency NVARCHAR(MAX) ,
        @ItemsNames NVARCHAR(MAX) ,
        @ItemsCounts INT ,
        @Cost FLOAT ,
        @return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @ItemIDOld = s.ItemID ,
              @ItemSharedIDOld = s.ItemSharedID ,
              @QtysOld = s.Qtys
      FROM    Items.t_ItemProduction AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

      INSERT  INTO @ItemQtyOld
              ( ID ,
                SharedID ,
                Qty
              )
      SELECT  s.ItemID ,
              s.ItemSharedID ,
              s.Qtys
      FROM    Items.t_ItemProductionMaterial AS s
      WHERE   s.ItemProductionID = @ID;

      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

      SELECT  @ItemsCounts = ( SELECT COUNT(*)
                               FROM   @Material
                             );

      SELECT  @ItemsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                    ', ' + t1.Name AS [text()]
                                            FROM    @Material AS t
                                            LEFT JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
                                          FOR
                                            XML PATH('')
                                          ));

      SET @Cost = @TotalCost / @Qty;

    END;

    BEGIN --Insert

      SET @return = 0;

      UPDATE  Items.t_ItemProduction
      SET     RefPaper = @RefPaper ,
              DateIs = @DateIs ,
              DateOnly = @DateIs ,
              DateMonthly = DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
              DateYearly = DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
              EmployeeID = @EmployeeID ,
              Employee = Employees.f_EmployeeGetName(@EmployeeID) ,
              ItemSharedID = @ItemSharedID ,
              ItemID = @ItemID ,
              ItemUnityID = @ItemUnityID ,
              Qty = @Qty ,
              QtyWithUnity = FORMAT(@Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(@ItemUnityID) ,
              Qtys = @Qtys ,
              WarehouseID = @WarehouseID ,
              Warehouse = Company.f_WareHouseGetName(@WarehouseID) ,
              CurrencyID = @CurrencyID ,
              Currency = @Currency ,
              ExchangeRate = @ExchangeRate ,
              ExchangeRateLL = @ExchangeRateLL ,
              ExchangeRateEuro = @ExchangeRateEuro ,
              Cost = @Cost ,
              CostF = Currencys.f_Format(@CurrencyID, @Cost) ,
              CostD = @Cost / @ExchangeRate ,
              CostLL = @Cost / @ExchangeRate * @ExchangeRateLL ,
              CostEuro = @Cost / @ExchangeRate * @ExchangeRateEuro ,
              TotalCost = @TotalCost ,
              TotalCostF = Currencys.f_Format(@CurrencyID, @TotalCost) ,
              TotalCostD = @TotalCost / @ExchangeRate ,
              TotalCostLL = @TotalCost / @ExchangeRate * @ExchangeRateLL ,
              TotalCostEuro = @TotalCost / @ExchangeRate * @ExchangeRateEuro ,
              ItemsNames = @ItemsNames ,
              ItemsCounts = @ItemsCounts ,
              DescriptionIs = @DescriptionIs ,
              HaveSerial = @HaveSerial
      WHERE   ID = @ID;

    END;

    BEGIN --Insert t_ItemProductionMaterial

      MERGE Items.t_ItemProductionMaterial AS t
      USING @Material AS s
      ON s.ID = t.ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
                 ItemProductionID ,
                 ItemSharedID ,
                 ItemID ,
                 ItemUnityID ,
                 Qty ,
                 QtyWithUnity ,
                 Qtys ,
                 WarehouseID ,
                 Warehouse ,
                 Cost ,
                 CostF ,
                 CostD ,
                 CostLL ,
                 CostEuro ,
                 TotalCost ,
                 TotalCostF ,
                 TotalCostD ,
                 TotalCostLL ,
                 TotalCostEuro ,
                 DescriptionIs ,
                 SortAt
               )
        VALUES ( s.ID ,
                 @ID ,
                 s.ItemSharedID ,
                 s.ItemID ,
                 s.ItemUnityID ,
                 s.Qty ,
                 FORMAT(s.Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID) ,
                 s.Qtys ,
                 s.WarehouseID ,
                 Company.f_WareHouseGetName(s.WarehouseID) ,
                 s.Cost ,
                 Currencys.f_Format(@CurrencyID, s.Cost) ,
                 s.Cost / @ExchangeRate ,
                 ( s.Cost / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.Cost / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.TotalCost ,
                 Currencys.f_Format(@CurrencyID, s.TotalCost) ,
                 s.TotalCost / @ExchangeRate ,
                 ( s.TotalCost / @ExchangeRate ) * @ExchangeRateLL ,
                 ( s.TotalCost / @ExchangeRate ) * @ExchangeRateEuro ,
                 s.DescriptionIs ,
                 s.SortAt
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.ItemSharedID = s.ItemSharedID ,
               t.ItemID = s.ItemID ,
               t.ItemUnityID = s.ItemUnityID ,
               t.Qty = s.Qty ,
               t.QtyWithUnity = FORMAT(s.Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(s.ItemUnityID) ,
               t.Qtys = s.Qtys ,
               t.WarehouseID = s.WarehouseID ,
               t.Warehouse = Company.f_WareHouseGetName(s.WarehouseID) ,
               t.Cost = s.Cost ,
               t.CostF = Currencys.f_Format(@CurrencyID, s.Cost) ,
               t.CostD = s.Cost / @ExchangeRate ,
               t.CostLL = ( s.Cost / @ExchangeRate ) * @ExchangeRateLL ,
               t.CostEuro = ( s.Cost / @ExchangeRate ) * @ExchangeRateEuro ,
               t.TotalCost = s.TotalCost ,
               t.TotalCostF = Currencys.f_Format(@CurrencyID, s.TotalCost) ,
               t.TotalCostD = s.TotalCost / @ExchangeRate ,
               t.TotalCostLL = ( s.TotalCost / @ExchangeRate ) * @ExchangeRateLL ,
               t.TotalCostEuro = ( s.TotalCost / @ExchangeRate ) * @ExchangeRateEuro ,
               t.DescriptionIs = s.DescriptionIs ,
               t.SortAt = s.SortAt
      WHEN NOT MATCHED BY SOURCE AND t.ItemProductionID = @ID THEN
        DELETE;

      INSERT  INTO @Item
              ( ID ,
                SharedID ,
                Qty
              )
      SELECT  s.ItemID ,
              s.ItemSharedID ,
              s.Qtys
      FROM    Items.t_ItemProductionMaterial AS s
      WHERE   s.ItemProductionID = @ID;

    END;

    BEGIN --Insert t_ItemSerial

      INSERT  INTO Items.t_ItemSerial
              ( ID ,
                ItemSharedID ,
                ItemID ,
                SerialText ,
                SectionType ,
                LinkID
              )
      SELECT  s.ID ,
              s.ItemSharedID ,
              s.ItemID ,
              s.SerialText ,
              155 ,
              @ID
      FROM    @SerialIs AS s;

    END;

    BEGIN --Insert t_ItemProductionSerial

      INSERT  INTO Items.t_ItemProductionSerial
              ( ItemProductionID, SerialID )
      SELECT  @ID ,
              s.ID
      FROM    @SerialIs AS s;

    END;

    BEGIN --Insert t_ItemProductionMaterialSerial

      INSERT  INTO Items.t_ItemProductionMaterialSerial
              ( ItemProductionID ,
                ItemProductionMaterialID ,
                SerialID
              )
      SELECT  @ID ,
              s.FatherID ,
              s.ID
      FROM    @MaterialSerial AS s;

    END;

    BEGIN --Update item serial

      UPDATE  Items.t_ItemSerial
      SET     IsAvailable = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @MaterialSerial AS s
                       WHERE  s.ID = t_ItemSerial.ID );

    END;

    BEGIN --Fix item qty

      INSERT  INTO @ItemQtyNet
              ( ID ,
                Qty
              )
      SELECT  s.ID ,
              COALESCE(SUM(s.Qty), 0)
      FROM    @Item AS s
      GROUP BY s.ID;

      MERGE Items.t_Item AS t
      USING @ItemQtyOld AS s
      ON s.ID = t.ID
        AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET
               t.QtyCurrent += s.Qty;

      MERGE Items.t_Item AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID
        AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET
               t.QtyCurrent -= s.Qty;

      UPDATE  Items.t_Item
      SET     QtyCurrent -= @QtysOld
      WHERE   ID = @ItemIDOld
              AND TypeIs = 0;

      UPDATE  Items.t_Item
      SET     QtyCurrent += @Qtys
      WHERE   ID = @ItemID
              AND TypeIs = 0;

    END;

    BEGIN --Fix shared item qty

      DELETE  FROM @ItemQtyNet;

      INSERT  INTO @ItemQtyNet
              ( ID ,
                Qty
              )
      SELECT  s.SharedID ,
              COALESCE(SUM(s.Qty), 0)
      FROM    @Item AS s
      GROUP BY s.SharedID;

      MERGE Items.t_ItemShared AS t
      USING @ItemQtyOld AS s
      ON s.SharedID = t.ID
        AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET
               t.QtyCurrent += s.Qty;

      MERGE Items.t_ItemShared AS t
      USING @ItemQtyNet AS s
      ON s.ID = t.ID
        AND t.TypeIs = 0
      WHEN MATCHED THEN
        UPDATE SET
               t.QtyCurrent -= s.Qty;

      UPDATE  Items.t_ItemShared
      SET     QtyCurrent -= @QtysOld
      WHERE   ID = @ItemSharedIDOld
              AND TypeIs = 0;

      UPDATE  Items.t_ItemShared
      SET     QtyCurrent += @Qtys
      WHERE   ID = @ItemSharedID
              AND TypeIs = 0;

      UPDATE  Items.t_ItemShared
      SET     PurchaseTotal = Purchase * QtyCurrent ,
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
      WHERE   ID = @ItemSharedID
              OR EXISTS ( SELECT TOP ( 1 )
                                  s.ID
                          FROM    @ItemQtyNet AS s
                          WHERE   s.ID = t_ItemShared.ID
                          UNION
                          SELECT TOP ( 1 )
                                  s.ID
                          FROM    @ItemQtyOld AS s
                          WHERE   s.ID = t_ItemShared.ID );

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT  INTO Items.t_ItemProductionMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                0 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;
	
    BEGIN --Reinsert t_ItemShared
	
      UPDATE  Items.t_ItemShared
      SET     CurrencyID = @CurrencyID ,
              Currency = @Currency ,
              Purchase = @Cost ,
              PurchaseF = Currencys.f_Format(CurrencyID, @Cost) ,
              PurchaseD = @Cost / @ExchangeRate ,
              PurchaseLL = ( @Cost / @ExchangeRate ) * @ExchangeRateLL ,
              PurchaseEuro = ( @Cost / @ExchangeRate ) * @ExchangeRateEuro
      WHERE   ID = @ItemSharedID;
	 
      UPDATE  Items.t_ItemShared
      SET     PurchaseWithTax = Calculation.Rate(Purchase, TaxRate) ,
              PurchaseWithTaxF = Currencys.f_Format(CurrencyID, Calculation.Rate(Purchase, TaxRate)) ,
              PurchaseWithTaxD = Calculation.Rate(PurchaseD, TaxRate) ,
              PurchaseWithTaxLL = Calculation.Rate(PurchaseLL, TaxRate) ,
              PurchaseWithTaxEuro = Calculation.Rate(PurchaseEuro, TaxRate) ,
              PurchaseTotal = Purchase * QtyCurrent ,
              PurchaseTotalF = Currencys.f_Format(CurrencyID, Purchase * QtyCurrent) ,
              PurchaseTotalD = PurchaseD * QtyCurrent ,
              PurchaseTotalLL = PurchaseLL * QtyCurrent ,
              PurchaseTotalEuro = PurchaseEuro * QtyCurrent
      WHERE   ID = @ItemSharedID;
	
      UPDATE  Items.t_ItemShared
      SET     PurchaseTotalWithTax = PurchaseWithTax * QtyCurrent ,
              PurchaseTotalWithTaxF = Currencys.f_Format(CurrencyID, PurchaseWithTax * QtyCurrent) ,
              PurchaseTotalWithTaxD = PurchaseWithTaxD * QtyCurrent ,
              PurchaseTotalWithTaxLL = PurchaseWithTaxLL * QtyCurrent ,
              PurchaseTotalWithTaxEuro = PurchaseWithTaxEuro * QtyCurrent
      WHERE   ID = @ItemSharedID;

    END;

    BEGIN --Reinsert t_ItemSharedMaterial

      DELETE  FROM Items.t_ItemSharedMaterial
      WHERE   ItemSharedFatherID = @ItemSharedID;

      INSERT  INTO Items.t_ItemSharedMaterial
              ( ItemSharedFatherID ,
                ItemSharedID ,
                ItemUnityID ,
                Qty ,
                QtyWithUnity ,
                Qtys ,
                DescriptionIs ,
                CreateByID ,
                CreateBy
	          )
      SELECT  @ItemSharedID ,
              s.ItemSharedID ,
              s.ItemUnityID ,
              s.Qty ,
              s.QtyWithUnity ,
              s.Qtys ,
              s.DescriptionIs ,
              @UserID ,
              s1.Name
      FROM    Items.t_ItemProductionMaterial AS s
      INNER JOIN Users.t_User AS s1 ON s1.ID = @UserID
      WHERE   s.ItemProductionID = @ID;

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @return;

  END CATCH;

END;






GO
