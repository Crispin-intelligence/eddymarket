SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_StockTakeUpdateMerge]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDs Alls.tt_Guid READONLY
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Item AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                Qty DECIMAL(18, 4) NOT NULL,
                Total FLOAT NOT NULL,
                TotalD FLOAT NOT NULL,
                TotalLL FLOAT NOT NULL,
                TotalEuro FLOAT NOT NULL
            );

            DECLARE @ID UNIQUEIDENTIFIER,
                    @return INT;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @ID = t.ID
            FROM Items.t_StockTake AS t
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t.ID
            )
            ORDER BY t.Ref;

        END;

        BEGIN --Insert detail

            SET @return = 0;

            UPDATE Items.t_StockTakeDetail
            SET StockTakeID = @ID
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM @IDs AS s
                WHERE s.ID = t_StockTakeDetail.StockTakeID
            );

        END;

        BEGIN --Insert detial serial

            UPDATE Items.t_StockTakeDetailSerial
            SET StockTakeID = @ID
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM @IDs AS s
                WHERE s.ID = t_StockTakeDetailSerial.StockTakeID
            );

        END;

        BEGIN --Rebuild statistics

            INSERT INTO @Item
            (
                ID,
                Qty,
                Total,
                TotalD,
                TotalLL,
                TotalEuro
            )
            SELECT s.ID,
                   s.Qtys,
                   s.Total,
                   s.TotalD,
                   s.TotalLL,
                   s.TotalEuro
            FROM Items.t_StockTakeDetail AS s
            WHERE s.StockTakeID = @ID;

            UPDATE Items.t_StockTake
            SET NetIs =
                (
                    SELECT COALESCE(SUM(s.Total), 0) FROM @Item AS s
                ),
                NetIsD =
                (
                    SELECT COALESCE(SUM(s.TotalD), 0) FROM @Item AS s
                ),
                NetIsLL =
                (
                    SELECT COALESCE(SUM(s.TotalLL), 0) FROM @Item AS s
                ),
                NetIsEuro =
                (
                    SELECT COALESCE(SUM(s.TotalEuro), 0) FROM @Item AS s
                ),
                Qtys =
                (
                    SELECT COALESCE(SUM(s.Qty), 0) FROM @Item AS s
                )
            WHERE ID = @ID;

            UPDATE Items.t_StockTake
            SET NetIsF = Currencys.f_Format(CurrencyID, NetIs),
                ItemsNames = Alls.f_FixXML(
                             (
                                 SELECT DISTINCT
                                        ', ' + t1.Name AS [text()]
                                 FROM Items.t_StockTakeDetail AS t
                                     LEFT JOIN Items.t_ItemShared AS t1
                                         ON t1.ID = t.ItemSharedID
                                 WHERE t.StockTakeID = t_StockTake.ID
                                 FOR XML PATH('')
                             )
                                          )
            WHERE ID = @ID;

        END;

        BEGIN --Delete

            DELETE FROM Items.t_StockTake
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM @IDs AS s
                WHERE s.ID = t_StockTake.ID
                      AND s.ID <> @ID
            );

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT INTO Items.t_StockTakeMoving
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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @return;

    END CATCH;

END;









GO
