SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_CloseBoxRebuildingStatistics]
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

            UPDATE Company.t_CloseBox
            SET FromUser = Users.f_UserGetName(FromUserID),
                ToUser = Users.f_UserGetName(ToUserID),
                FromAccount = Company.f_AccountGetName(FromAccountID),
                ToAccount = Company.f_AccountGetName(ToAccountID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                BalanceF = Currencys.f_Format(CurrencyID, Balance),
                TotalDF = Currencys.f_FormatD(TotalD),
                TotalLLF = Currencys.f_FormatLL(TotalLL),
                TotalEuroF = Currencys.f_FormatEuro(TotalEuro);

            UPDATE Company.t_CloseBoxDetail
            SET Currency = Currencys.f_CurrencyGetName(CurrencyID),
                PriceF = Currencys.f_Format(CurrencyID, Price),
                TotalF = Currencys.f_Format(CurrencyID, Total);

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_CloseBoxMoving
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
