SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_UnityItemDelete]
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

            DECLARE @Return INT,
                    @ItemSharedID UNIQUEIDENTIFIER,
                    @Barcode NVARCHAR(450),
                    @Purchasing BIT,
                    @Sold BIT,
                    @Inventory BIT,
                    @UseInTransfer BIT;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @ItemSharedID = s.SharedID,
                   @Barcode = s.BarCode,
                   @Purchasing = s.Purchasing,
                   @Sold = s.Sold,
                   @Inventory = s.Inventory,
                   @UseInTransfer = s.UseInTransfer
            FROM Items.t_UnityItem AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Delete Barcode

            DELETE FROM Items.t_ItemSharedBarCode
            WHERE SharedID = @ItemSharedID
                  AND TypeIs = 2
                  AND BarCode = @Barcode;

        END;

        BEGIN --Delete

            SET @Return = 0;

            DELETE FROM Company.t_AccountItemPrice
            WHERE ItemUnityID = @ID;

            DELETE FROM Items.t_UnityItem
            WHERE ID = @ID;

        END;

        BEGIN --Fix data

            UPDATE Items.t_UnityItem
            SET Purchasing = CASE @Purchasing
                                 WHEN 1 THEN
                                     @Purchasing
                                 ELSE
                                     Purchasing
                             END,
                Sold = CASE @Sold
                           WHEN 1 THEN
                               @Sold
                           ELSE
                               Sold
                       END,
                Inventory = CASE @Inventory
                                WHEN 1 THEN
                                    @Inventory
                                ELSE
                                    Inventory
                            END,
                UseInTransfer = CASE @UseInTransfer
                                    WHEN 1 THEN
                                        @UseInTransfer
                                    ELSE
                                        UseInTransfer
                                END
            WHERE SharedID = @ItemSharedID
                  AND PrimaryIs = 1;

        END;

        BEGIN --Rebuilding statistics

            UPDATE Items.t_ItemShared
            SET Barcodes = Alls.f_FixXML(
                           (
                               SELECT N', ' + t.BarCode AS [text()]
                               FROM Items.t_ItemSharedBarCode AS t
                               WHERE t.SharedID = t_ItemShared.ID
                               FOR XML PATH('')
                           )
                                        ),
                UnityC -= 1,
                UnityNames = Alls.f_FixXML(
                             (
                                 SELECT N', ' + t.Unity AS [text()]
                                 FROM Items.t_UnityItem AS t
                                 WHERE t.SharedID = t_ItemShared.ID
                                 FOR XML PATH('')
                             )
                                          )
            WHERE ID = @ItemSharedID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_ItemSharedMoving
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
            (@UserID, @ItemSharedID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount);

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
