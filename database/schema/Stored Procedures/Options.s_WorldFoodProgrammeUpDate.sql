SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Options].[s_WorldFoodProgrammeUpDate]
    @ShopID NVARCHAR(MAX),
    @BranchID NVARCHAR(MAX),
    @DestinationPath NVARCHAR(MAX),
    @FileNamePrefix NVARCHAR(MAX),
    @FileNameDateTimeFormat NVARCHAR(MAX),
    @FileNameSuffix NVARCHAR(MAX),
    @AutoGenerateReport TINYINT,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @ShopIDOld NVARCHAR(MAX),
                    @BranchIDOld NVARCHAR(MAX),
                    @Return INT;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @ShopIDOld = s.ShopID,
                   @BranchIDOld = s.BranchID
            FROM Options.t_WorldFoodProgramme AS s
            ORDER BY s.ID;

        END;

        BEGIN --Update

            SET @Return = 0;

            UPDATE Options.t_WorldFoodProgramme
            SET ShopID = @ShopID,
                BranchID = @BranchID,
                DestinationPath = @DestinationPath,
                FileNamePrefix = @FileNamePrefix,
                FileNameDateTimeFormat = @FileNameDateTimeFormat,
                FileNameSuffix = @FileNameSuffix,
                AutoGenerateReport = @AutoGenerateReport
            WHERE ID = @ID;

        END;

        IF @ShopID <> @ShopIDOld
           OR @BranchID <> @BranchIDOld
        BEGIN --Fix Invoices.t_Sold
		
            UPDATE Invoices.t_Sold
            SET WFPShopID = @ShopID,
                WFPBranchID = @BranchID
            WHERE WFPFrom = 1;
						
        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Options.t_WorldFoodProgrammeMoving
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

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;



GO
