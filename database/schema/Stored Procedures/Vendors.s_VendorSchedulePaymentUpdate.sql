SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Vendors].[s_VendorSchedulePaymentUpdate]
    @DateIs DATE,
    @Payment FLOAT,
    @CurrencyID UNIQUEIDENTIFIER,
    @DescriptionIs NVARCHAR(MAX),
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

            DECLARE @ExchangeRate DECIMAL(18, 2),
                    @Return INT;

        END;

        BEGIN --Set info

            SET @ExchangeRate = Currencys.f_CurrencyGetExchangeRate(@CurrencyID);

        END;

        BEGIN --Update

            SET @Return = 0;

            UPDATE Vendors.t_VendorSchedulePayment
            SET DateIs = @DateIs,
                Payment = @Payment,
                PaymentF = Currencys.f_Format(@CurrencyID, @Payment),
                PaymentD = @Payment / @ExchangeRate,
                PaymentLL = Currencys.f_ExchangeToLL(@CurrencyID, @Payment, @Payment / @ExchangeRate),
                PaymentEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @Payment, @Payment / @ExchangeRate),
                CurrencyID = @CurrencyID,
                ExchangeRate = @ExchangeRate,
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

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
