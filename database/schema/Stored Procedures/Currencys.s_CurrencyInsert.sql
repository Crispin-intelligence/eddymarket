SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Currencys].[s_CurrencyInsert]
    @Name NVARCHAR(450),
    @ExchangeRate DECIMAL(18, 2),
    @DecimalNumber TINYINT,
    @PositivePattern TINYINT,
    @DescriptionAR NVARCHAR(MAX),
    @DescriptionEN NVARCHAR(MAX),
    @DescriptionDecimalAR NVARCHAR(MAX),
    @DescriptionDecimalEN NVARCHAR(MAX),
    @RewardPointsInsteadOf FLOAT,
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

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Currencys.t_Currency
            (
                Name,
                ExchangeRate,
                DecimalNumber,
                PositivePattern,
                DescriptionAR,
                DescriptionEN,
                DescriptionDecimalAR,
                DescriptionDecimalEN,
                RewardPointsInsteadOf
            )
            OUTPUT Inserted.ID
            INTO @IDs
            (
                ID
            )
            VALUES
            (@Name, @ExchangeRate, @DecimalNumber, @PositivePattern, @DescriptionAR, @DescriptionEN,
             @DescriptionDecimalAR, @DescriptionDecimalEN, @RewardPointsInsteadOf);

            SET @ID =
            (
                SELECT TOP (1) ID FROM @IDs ORDER BY ID
            );

        END;

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
            (@UserID, @ID, @Event, 0, @ComputerIP, @Computer, @ComputerAccount);

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
