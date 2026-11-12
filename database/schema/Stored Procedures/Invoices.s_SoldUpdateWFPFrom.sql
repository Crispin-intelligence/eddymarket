SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldUpdateWFPFrom]
    @WFPFrom BIT,
    @UserID UNIQUEIDENTIFIER,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @WFPShopID NVARCHAR(MAX) = '',
                    @WFPBranchID NVARCHAR(MAX) = '',
                    @Return INT;

        END;

        BEGIN --Set info

            IF @WFPFrom = 1
            BEGIN

                SELECT TOP (1)
                       @WFPShopID = s.ShopID,
                       @WFPBranchID = s.BranchID
                FROM Options.t_WorldFoodProgramme AS s
                ORDER BY s.ID;

            END;

        END;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE Invoices.t_Sold
            SET WFPShopID = @WFPShopID,
                WFPBranchID = @WFPBranchID,
                WFPFrom = @WFPFrom
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_Sold.ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Invoices.t_SoldMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   s.EventIs,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDAndEvent AS s;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;








GO
