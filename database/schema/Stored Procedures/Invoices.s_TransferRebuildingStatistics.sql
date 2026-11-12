SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_TransferRebuildingStatistics]
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

            UPDATE Invoices.t_Transfer
            SET FromWarehouse = Company.f_WareHouseGetName(FromWarehouseID),
                ToWarehouse = Company.f_WareHouseGetName(ToWarehouseID),
                UserIs = Users.f_UserGetName(UserID),
                ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Invoices.t_TransferDetail AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.TransferID = t_Transfer.ID
                                 FOR XML PATH('')
                             )
                                          );


            WITH o
            AS (SELECT s.Qty,
                       s.QtyWithUnity,
                       s2.Name AS Unity
                FROM Invoices.t_TransferDetail AS s
                    LEFT JOIN Items.t_UnityItem AS s1
                        ON s1.ID = s.ItemUnityID
                    LEFT JOIN Items.t_Unity AS s2
                        ON s2.ID = s1.UnityID)
            UPDATE o
            SET o.QtyWithUnity = FORMAT(o.Qty, '#,##0.####') + ' ' + o.Unity;

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
