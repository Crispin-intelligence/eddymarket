SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_BankUpdateIsSync]
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

        DISABLE TRIGGER Company.tr_Bank ON Company.t_Bank;

        BEGIN --Insert

            UPDATE Company.t_Bank
            SET IsSync = @IsSync
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Company.tr_Bank ON Company.t_Bank;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_BankMoving
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
