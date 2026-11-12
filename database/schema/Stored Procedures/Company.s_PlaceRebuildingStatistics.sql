SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_PlaceRebuildingStatistics]
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

            UPDATE Company.t_Place
            SET WareHouseID = WareHouseID,
                ItemC =
                (
                    SELECT COUNT(*) FROM Items.t_Item AS s WHERE s.PlaceID = t_Place.ID
                ),
                Qtys =
                (
                    SELECT COALESCE(SUM(s.QtyCurrent), 0)
                    FROM Items.t_Item AS s
                    WHERE s.PlaceID = t_Place.ID
                ),
                Purchase =
                (
                    SELECT COALESCE(SUM(s1.PurchaseD * s.QtyCurrent), 0)
                    FROM Items.t_Item AS s
                        LEFT JOIN Items.t_ItemShared AS s1
                            ON s1.ID = s.SharedID
                    WHERE s.PlaceID = t_Place.ID
                ),
                Sell =
                (
                    SELECT COALESCE(SUM(s1.SellD * s.QtyCurrent), 0)
                    FROM Items.t_Item AS s
                        LEFT JOIN Items.t_ItemShared AS s1
                            ON s1.ID = s.SharedID
                    WHERE s.PlaceID = t_Place.ID
                );

            UPDATE Company.t_Place
            SET PurchaseF = Currencys.f_FormatD(Purchase),
                SellF = Currencys.f_FormatD(Sell);

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_PlaceMoving
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
