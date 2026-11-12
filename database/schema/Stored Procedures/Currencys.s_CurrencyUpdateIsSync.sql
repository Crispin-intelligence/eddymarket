SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Currencys].[s_CurrencyUpdateIsSync]
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

        DISABLE TRIGGER Currencys.tr_Currency ON Currencys.t_Currency;

        BEGIN --Insert

            UPDATE Currencys.t_Currency
            SET IsSync = @IsSync
            WHERE ID = @ID;

        END;

        ENABLE TRIGGER Currencys.tr_Currency ON Currencys.t_Currency;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Currencys.t_CurrencyMoving
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
