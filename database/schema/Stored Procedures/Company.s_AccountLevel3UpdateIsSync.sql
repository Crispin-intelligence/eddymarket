SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_AccountLevel3UpdateIsSync]
    @IsSync BIT,
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

        BEGIN --Insert

            UPDATE Company.t_AccountLevel3
            SET IsSync = @IsSync
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;

GO
