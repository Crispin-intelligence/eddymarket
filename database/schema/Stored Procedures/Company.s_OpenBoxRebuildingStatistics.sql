SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_OpenBoxRebuildingStatistics]
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

        BEGIN --Rebuilding statistics

            SET @Return = 0;

            UPDATE Company.t_OpenBox
            SET UserIs = Users.f_UserGetName(UserID),
                FromAccount = Company.f_AccountGetName(FromAccountID),
                ToAccount = Company.f_AccountGetName(ToAccountID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                BalanceF = Currencys.f_Format(CurrencyID, Balance),
                BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1),
                BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1);

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_OpenBoxMoving
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

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;








GO
