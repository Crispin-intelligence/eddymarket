SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemProductionRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Items.tr_ItemProduction ON Items.t_ItemProduction;

        BEGIN --Rebuild statistics

            SET @Return = 0;

            UPDATE Items.t_ItemProduction
            SET RefF = FORMAT(Ref, 'n0'),
                Employee = Employees.f_EmployeeGetName(EmployeeID),
                QtyWithUnity = FORMAT(Qty, '#,##0.####') + ' ' + Items.f_UnityItemGetName(ItemUnityID),
                Warehouse = Company.f_WareHouseGetName(WarehouseID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                CostF = Currencys.f_Format(CurrencyID, Cost),
                ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Items.t_ItemProductionMaterial AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.ItemProductionID = t_ItemProduction.ID
                                 FOR XML PATH('')
                             )
                                          ),
                ItemsCounts =
                (
                    SELECT COUNT(*)
                    FROM Items.t_ItemProductionMaterial AS t
                    WHERE t.ItemProductionID = t_ItemProduction.ID
                ),
                CreateBy = Users.f_UserGetName(CreateByID);

            WITH o
            AS (SELECT s.Cost,
                       s.CostF,
                       s.TotalCost,
                       s.TotalCostF,
                       s1.CurrencyID,
                       s.Qty,
                       s.Qtys,
                       s.QtyWithUnity,
                       s3.Name AS Unity
                FROM Items.t_ItemProductionMaterial AS s
                    LEFT JOIN Items.t_ItemProduction AS s1
                        ON s1.ID = s.ItemProductionID
                    LEFT JOIN Items.t_UnityItem AS s2
                        ON s2.ID = s.ItemUnityID
                    LEFT JOIN Items.t_Unity AS s3
                        ON s3.ID = s2.UnityID)
            UPDATE o
            SET o.CostF = Currencys.f_Format(o.CurrencyID, o.Cost),
                o.TotalCostF = Currencys.f_Format(o.CurrencyID, o.TotalCost),
                o.QtyWithUnity = FORMAT(o.Qty, '#,##0.####') + ' ' + o.Unity;

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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

        END;

        BEGIN --Live

            UPDATE Alls.t_LiveVersion
            SET VersionLive = STUFF(VersionLive, ItemProduction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        END;

        ENABLE TRIGGER Items.tr_ItemProduction ON Items.t_ItemProduction;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;




GO
