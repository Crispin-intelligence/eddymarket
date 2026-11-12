SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_ChequeHistoryRebuildingStatistics]
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

            UPDATE Company.t_ChequeHistory
            SET Bank = Company.f_BankGetName(BankID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                AmountF = Currencys.f_Format(CurrencyID, Amount),
                AmountAR = Currencys.f_ToWordAR(Amount, CurrencyID, 1),
                AmountEN = Currencys.f_ToWordEN(Amount, CurrencyID, 1),
                Building = Location.f_BuildingGetName(BuildingID),
                TypeIsAR = CASE TypeIs
                               WHEN 0 THEN
                                   N'داخل'
                               ELSE
                                   N'خارج'
                           END,
                TypeIsEN = CASE TypeIs
                               WHEN 0 THEN
                                   N'Inside'
                               ELSE
                                   N'Outside'
                           END,
                DateDueMonthly = DATEFROMPARTS(YEAR(DateDue), MONTH(DateDue), 1),
                DateDueYearly = DATEFROMPARTS(YEAR(DateDue), 1, 1),
                NotificationDate = DATEADD(DAY, NotificationBeforeDays, DateDue),
                NotificationStop = 1;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_ChequeMoving
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
