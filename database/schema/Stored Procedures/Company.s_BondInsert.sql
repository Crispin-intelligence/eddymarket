SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_BondInsert]
    @NumberIs INT,
    @NumberOfGroup NVARCHAR(MAX),
    @DateIs DATE,
    @FromAccountID UNIQUEIDENTIFIER,
    @ToAccountID UNIQUEIDENTIFIER,
    @StatesID UNIQUEIDENTIFIER,
    @RegionID UNIQUEIDENTIFIER,
    @StreetID UNIQUEIDENTIFIER,
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @Amount FLOAT,
    @BuildingID UNIQUEIDENTIFIER,
    @TypeIs TINYINT,
    @ImageIs IMAGE,
    @DateDue DATE,
    @NotificationBeforeDays INT,
    @DescriptionIs NVARCHAR(MAX),
    @NotificationTextAR NVARCHAR(MAX),
    @NotificationTextEN NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

            DECLARE @Ref BIGINT,
                    @Currency NVARCHAR(MAX),
                    @return INT;

        END;

        BEGIN --Set info

            SELECT @Ref = COALESCE(MAX(o.Ref), 0) + 1
            FROM
            (
                SELECT s.Ref
                FROM Company.t_Bond AS s
                UNION ALL
                SELECT s.Ref
                FROM Company.t_BondHistory AS s
            ) AS o;

            SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

        END;

        BEGIN --Insert

            SET @return = 0;

            INSERT INTO Company.t_Bond
            (
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
                DateDue,
                DateDueMonthly,
                DateDueYearly,
                NotificationBeforeDays,
                NotificationDate,
                NotificationStop,
                NotificationTextAR,
                NotificationTextEN,
                DescriptionIs
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (   @Ref, FORMAT(@Ref, 'n0'), @NumberIs, @NumberOfGroup, @DateIs, @FromAccountID, @ToAccountID, @StatesID,
                Location.f_StatesGetName(@StatesID), @RegionID, Location.f_RegionGetName(@RegionID), @StreetID,
                Location.f_StreetGetName(@StreetID), @CurrencyID, @Currency, @ExchangeRate, @Amount,
                Currencys.f_Format(@CurrencyID, @Amount), @Amount / @ExchangeRate,
                Currencys.f_ExchangeToLL(@CurrencyID, @Amount, @Amount / @ExchangeRate),
                Currencys.f_ExchangeToEuro(@CurrencyID, @Amount, @Amount / @ExchangeRate),
                Currencys.f_ToWordAR(@Amount, @CurrencyID, 1), Currencys.f_ToWordEN(@Amount, @CurrencyID, 1),
                @BuildingID, Location.f_BuildingGetName(@BuildingID), @TypeIs, CASE @TypeIs
                                                                                   WHEN 0 THEN
                                                                                       N'داخل'
                                                                                   ELSE
                                                                                       N'خارج'
                                                                               END, CASE @TypeIs
                                                                                        WHEN 0 THEN
                                                                                            N'Inside'
                                                                                        ELSE
                                                                                            N'Outside'
                                                                                    END, @ImageIs, @DateDue,
                DATEFROMPARTS(YEAR(@DateDue), MONTH(@DateDue), 1), DATEFROMPARTS(YEAR(@DateDue), 1, 1),
                @NotificationBeforeDays, DATEADD(DAY, 0 - @NotificationBeforeDays, @DateDue), 0, @NotificationTextAR,
                @NotificationTextEN, @DescriptionIs);

            SET @ID =
            (
                SELECT TOP (1) s.ID FROM @IDs AS s ORDER BY s.ID
            );

            UPDATE Company.t_Bond
            SET AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, N'', N'', N'', N'', ' - ', '-')
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @return = -1;

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
            (@UserID, @ID, @Event + N': ' + CONVERT(NVARCHAR(MAX), @Ref), 0, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @return;

    END CATCH;

END;








GO
