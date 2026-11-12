SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarClassUpdateIsSync]
    @IsSync BIT,
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

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Cars.tr_CarClass ON Cars.t_CarClass;

        BEGIN --Insert

            UPDATE Cars.t_CarClass
            SET IsSync = @IsSync
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Cars.tr_CarClass ON Cars.t_CarClass;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Cars.t_CarClassMoving
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
            (@UserID, @ID, @Event, 7, @ComputerIP, @Computer, @ComputerAccount);

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
