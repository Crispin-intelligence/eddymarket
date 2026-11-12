SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_StockAdjustmentRebuildingStatistics]
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

        DISABLE TRIGGER Items.tr_StockAdjustment ON Items.t_StockAdjustment;

        BEGIN --Rebuild statistics

            SET @Return = 0;

            UPDATE Items.t_StockAdjustment
            SET RefF = FORMAT(Ref, 'n0'),
                ReasonStockAdjustment = Items.f_ReasonStockAdjustmentGetName(ReasonStockAdjustmentID),
                UserIs = Users.f_UserGetName(UserID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                NetIsF = Currencys.f_Format(CurrencyID, NetIs),
                NetIsAR = Currencys.f_ToWordAR(NetIs, CurrencyID, 1),
                NetIsEN = Currencys.f_ToWordEN(NetIs, CurrencyID, 1),
                ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Items.t_StockAdjustmentDetail AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.StockAdjustmentID = t_StockAdjustment.ID
                                 FOR XML PATH('')
                             )
                                          );

            WITH o
            AS (SELECT s.Price,
                       s.PriceF,
                       s.Total,
                       s.TotalF,
                       s1.CurrencyID,
                       s.Qty,
                       s.Qtys,
                       s.QtyWithUnity,
                       s3.Name AS Unity
                FROM Items.t_StockAdjustmentDetail AS s
                    LEFT JOIN Items.t_StockAdjustment AS s1
                        ON s1.ID = s.StockAdjustmentID
                    LEFT JOIN Items.t_UnityItem AS s2
                        ON s2.ID = s.ItemUnityID
                    LEFT JOIN Items.t_Unity AS s3
                        ON s3.ID = s2.UnityID)
            UPDATE o
            SET o.PriceF = Currencys.f_Format(o.CurrencyID, o.Price),
                o.TotalF = Currencys.f_Format(o.CurrencyID, o.Total),
                o.QtyWithUnity = FORMAT(o.Qty, '#,##0.####') + ' ' + o.Unity;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_StockAdjustmentMoving
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
            SET VersionLive = STUFF(VersionLive, StockAdjustment, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        END;

        ENABLE TRIGGER Items.tr_StockAdjustment ON Items.t_StockAdjustment;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;





GO
