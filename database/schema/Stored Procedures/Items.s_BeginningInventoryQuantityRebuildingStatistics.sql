SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_BeginningInventoryQuantityRebuildingStatistics]
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

        BEGIN --Rebuild statistics

            SET @Return = 0;

            UPDATE Items.t_BeginningInventoryQuantity
            SET RefF = FORMAT(Ref, 'n0'),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                TotalF = Currencys.f_Format(CurrencyID, Total),
                ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Items.t_BeginningInventoryQuantityDetail AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.BeginningInventoryQuantityID = t_BeginningInventoryQuantity.ID
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
                       s.QtyWithUnity,
                       s3.Name AS Unity
                FROM Items.t_BeginningInventoryQuantityDetail AS s
                    LEFT JOIN Items.t_BeginningInventoryQuantity AS s1
                        ON s1.ID = s.BeginningInventoryQuantityID
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

            INSERT INTO Items.t_BeginningInventoryQuantityMoving
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

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;


GO
