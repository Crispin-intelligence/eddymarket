SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_BondMoveFromHistory]
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

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Company.t_Bond
            (
                ID,
                Ref,
                RefF,
                NumberIs,
                NumberOfGroup,
                DateIs,
                FromAccountID,
                ToAccountID,
                StatesID,
                StatesIs,
                RegionID,
                RegionIs,
                StreetID,
                Street,
                AddressIs,
                CurrencyID,
                Currency,
                ExchangeRate,
                Amount,
                AmountF,
                AmountD,
                AmountLL,
                AmountEuro,
                AmountAR,
                AmountEN,
                BuildingID,
                Building,
                TypeIs,
                TypeIsAR,
                TypeIsEN,
                ImageIs,
                IsPaid,
                DateDue,
                DateDueMonthly,
                DateDueYearly,
                NotificationBeforeDays,
                NotificationDate,
                NotificationStop,
                NotificationTextAR,
                NotificationTextEN,
                DescriptionIs,
                DateCreate,
                WorkStationID
            )
            SELECT s.ID,
                   s.Ref,
                   s.RefF,
                   s.NumberIs,
                   s.NumberOfGroup,
                   s.DateIs,
                   s.FromAccountID,
                   s.ToAccountID,
                   s.StatesID,
                   s.StatesIs,
                   s.RegionID,
                   s.RegionIs,
                   s.StreetID,
                   s.Street,
                   s.AddressIs,
                   s.CurrencyID,
                   s.Currency,
                   s.ExchangeRate,
                   s.Amount,
                   s.AmountF,
                   s.AmountD,
                   s.AmountLL,
                   s.AmountEuro,
                   s.AmountAR,
                   s.AmountEN,
                   s.BuildingID,
                   s.Building,
                   s.TypeIs,
                   s.TypeIsAR,
                   s.TypeIsEN,
                   s.ImageIs,
                   s.IsPaid,
                   s.DateDue,
                   s.DateDueMonthly,
                   s.DateDueYearly,
                   s.NotificationBeforeDays,
                   s.NotificationDate,
                   0,
                   s.NotificationTextAR,
                   s.NotificationTextEN,
                   s.DescriptionIs,
                   s.DateCreate,
                   s.WorkStationID
            FROM Company.t_BondHistory AS s
            WHERE s.ID = @ID;

        END;

        BEGIN --Delete

            DELETE FROM Company.t_BondHistory
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_BondMoving
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
