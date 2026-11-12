SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_MovingInsertReport]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @TableName NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Insert event

            EXECUTE @Return = Alls.s_MovingInsert3 @ID,
                                                   @UserID,
                                                   @Event,
                                                   3,
                                                   @ComputerIP,
                                                   @Computer,
                                                   @ComputerAccount,
                                                   @TableName;

            IF @Return = -1
            BEGIN

                ROLLBACK;

                RETURN -1;

            END;

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;





GO
