SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Currencys].[s_CurrencyInsertDefaultData]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Check

            IF EXISTS (SELECT TOP (1) ID FROM Currencys.t_Currency)
            BEGIN
			
                COMMIT TRAN;

                RETURN 1;

            END;

        END;

        BEGIN --Insert

            INSERT Currencys.t_Currency
            (
                ID,
                TypeIs,
                Name,
                ExchangeRate,
                DecimalNumber,
                PositivePattern,
                DescriptionAR,
                DescriptionEN,
                DescriptionDecimalAR,
                DescriptionDecimalEN,
                DateCreate
            )
            VALUES
            ('11111111-1111-1111-1111-111111111111', 0, N'$', 1, 2, 3, 'دولار أمريكي', N'American Dollar', N'سنتا',
             N'Cents', GETDATE()),
            ('22222222-2222-2222-2222-222222222222', 1, N'L.L.', 1500, 0, 3, 'ليرة لبنانية', N'Lebanese Pounds', N'',
             N'', GETDATE()),
            ('33333333-3333-3333-3333-333333333333', 2, N'Euro', 0.9, 2, 3, 'يورو', N'Euro', N'سنتا', N'Cents',
             GETDATE());

        END;

        COMMIT TRAN;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN 0;

    END CATCH;

END;




GO
