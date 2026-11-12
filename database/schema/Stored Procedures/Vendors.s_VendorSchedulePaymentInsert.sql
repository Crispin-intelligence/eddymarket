SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Vendors].[s_VendorSchedulePaymentInsert]
    @PurchasingID UNIQUEIDENTIFIER,
    @VendorID UNIQUEIDENTIFIER,
    @CurrencyID UNIQUEIDENTIFIER,
    @Payments Vendors.tt_VendorSchedulePayment READONLY,
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

            DECLARE @Vendor NVARCHAR(MAX),
                    @Currency NVARCHAR(MAX),
                    @ExchangeRate DECIMAL(18, 2),
                    @Return INT;

            DECLARE @IDs AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

        END;

        BEGIN --Set info

            SET @Vendor = Vendors.f_VendorGetName(@VendorID);

            SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);

            SET @ExchangeRate = Currencys.f_CurrencyGetExchangeRate(@CurrencyID);

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Vendors.t_VendorSchedulePayment
            (
                ID,
                PurchasingID,
                VendorID,
                Vendor,
                DateIs,
                Payment,
                PaymentF,
                PaymentD,
                PaymentLL,
                PaymentEuro,
                CurrencyID,
                Currency,
                ExchangeRate,
                DescriptionIs
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            SELECT s.ID,
                   @PurchasingID,
                   @VendorID,
                   @Vendor,
                   s.DateIs,
                   s.Payment,
                   Currencys.f_Format(@CurrencyID, s.Payment),
                   s.Payment / @ExchangeRate,
                   Currencys.f_ExchangeToLL(@CurrencyID, s.Payment, s.Payment / @ExchangeRate),
                   Currencys.f_ExchangeToEuro(@CurrencyID, s.Payment, s.Payment / @ExchangeRate),
                   @CurrencyID,
                   @Currency,
                   @ExchangeRate,
                   s.DescriptionIs
            FROM @Payments AS s;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Vendors.t_VendorMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   @Event,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDs AS s;

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
