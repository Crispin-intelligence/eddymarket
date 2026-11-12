SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedUpdateSaleByRate]
    @IncreaseRate DECIMAL(5, 2),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDs Alls.tt_Guid READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Items_ AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                ItemSharedID UNIQUEIDENTIFIER NOT NULL,
                PrimaryIs BIT NOT NULL,
                PriceWithTax FLOAT NOT NULL,
                CurrencyID UNIQUEIDENTIFIER NOT NULL,
                ExchangeRate DECIMAL(18, 2) NOT NULL,
                TaxRate DECIMAL(4, 2) NOT NULL
            );

            DECLARE @Return INT,
                    @ExchangeRateLL DECIMAL(18, 2),
                    @ExchangeRateEuro DECIMAL(18, 2);

        END;

        BEGIN --Set info

            INSERT INTO @Items_
            (
                ID,
                ItemSharedID,
                PrimaryIs,
                PriceWithTax,
                CurrencyID,
                ExchangeRate,
                TaxRate
            )
            SELECT s.ID,
                   s.SharedID,
                   s.PrimaryIs,
                   Calculation.Rate(s.PriceWithTax, @IncreaseRate),
                   s.CurrencyID,
                   s1.ExchangeRate,
                   s2.TaxRate
            FROM Items.t_UnityItem AS s
                LEFT JOIN Currencys.t_Currency AS s1
                    ON s1.ID = s.CurrencyID
                LEFT JOIN Items.t_ItemShared AS s2
                    ON s2.ID = s.SharedID
            WHERE EXISTS
            (
                SELECT TOP (1) s3.ID FROM @IDs AS s3 WHERE s3.ID = s.SharedID
            );

            SET @ExchangeRateLL = Currencys.f_CurrencyGetExchangeRateLL();

            SET @ExchangeRateEuro = Currencys.f_CurrencyGetExchangeRateEuro();

        END;

        BEGIN --Update t_UnityItem

            SET @Return = 0;

            MERGE Items.t_UnityItem AS t
            USING @Items_ AS s
            ON s.ID = t.ID
            WHEN MATCHED THEN
                UPDATE SET t.Price = s.PriceWithTax - ((s.PriceWithTax / (100.0 + s.TaxRate)) * s.TaxRate),
                           t.PriceWithTax = s.PriceWithTax,
                           t.PriceWithTaxF = Currencys.f_Format(s.CurrencyID, s.PriceWithTax),
                           t.PriceWithTaxD = s.PriceWithTax / s.ExchangeRate,
                           t.PriceWithTaxLL = (s.PriceWithTax / s.ExchangeRate) * @ExchangeRateLL,
                           t.PriceWithTaxEuro = (s.PriceWithTax / s.ExchangeRate) * @ExchangeRateEuro;

            MERGE Items.t_UnityItem AS t
            USING @Items_ AS s
            ON s.ID = t.ID
            WHEN MATCHED THEN
                UPDATE SET t.PriceF = Currencys.f_Format(s.CurrencyID, t.Price),
                           t.PriceD = t.Price / s.ExchangeRate,
                           t.PriceLL = (t.Price / s.ExchangeRate) * @ExchangeRateLL,
                           t.PriceEuro = (t.Price / s.ExchangeRate) * @ExchangeRateEuro;

        END;

        BEGIN --Update t_ItemShared

            DELETE FROM @Items_
            WHERE PrimaryIs = 0;

            WITH o
            AS (SELECT ROW_NUMBER() OVER (PARTITION BY s.ItemSharedID ORDER BY (SELECT 0)) AS RowCountIs
                FROM @Items_ AS s)
            DELETE FROM o
            WHERE o.RowCountIs > 1;

            MERGE Items.t_ItemShared AS t
            USING @Items_ AS s
            ON s.ItemSharedID = t.ID
            WHEN MATCHED THEN
                UPDATE SET t.Sell = s.PriceWithTax - ((s.PriceWithTax / (100.0 + s.TaxRate)) * s.TaxRate),
                           t.SellWithTax = s.PriceWithTax,
                           t.SellWithTaxF = Currencys.f_Format(s.CurrencyID, s.PriceWithTax),
                           t.SellWithTaxD = s.PriceWithTax / s.ExchangeRate,
                           t.SellWithTaxLL = (s.PriceWithTax / s.ExchangeRate) * @ExchangeRateLL,
                           t.SellWithTaxEuro = (s.PriceWithTax / s.ExchangeRate) * @ExchangeRateEuro;

            MERGE Items.t_ItemShared AS t
            USING @Items_ AS s
            ON s.ItemSharedID = t.ID
            WHEN MATCHED THEN
                UPDATE SET t.SellF = Currencys.f_Format(s.CurrencyID, t.Sell),
                           t.SellD = t.Sell / s.ExchangeRate,
                           t.SellLL = (t.Sell / s.ExchangeRate) * @ExchangeRateLL,
                           t.SellEuro = (t.Sell / s.ExchangeRate) * @ExchangeRateEuro;

        END;

        BEGIN --Rebuilding statistics

            UPDATE Items.t_ItemShared
            SET SellTotal = Sell * QtyCurrent,
                SellTotalF = Currencys.f_Format(SellCurrencyID, Sell * QtyCurrent),
                SellTotalD = SellD * QtyCurrent,
                SellTotalLL = SellLL * QtyCurrent,
                SellTotalEuro = SellEuro * QtyCurrent,
                SellTotalWithTax = SellWithTax * QtyCurrent,
                SellTotalWithTaxF = Currencys.f_Format(SellCurrencyID, SellWithTax * QtyCurrent),
                SellTotalWithTaxD = SellWithTaxD * QtyCurrent,
                SellTotalWithTaxLL = SellWithTaxLL * QtyCurrent,
                SellTotalWithTaxEuro = SellWithTaxEuro * QtyCurrent
            WHERE EXISTS
            (
                SELECT TOP (1)
                       s.ID
                FROM @Items_ AS s
                WHERE s.ItemSharedID = t_ItemShared.ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Items.t_ItemSharedMoving
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
                   REPLACE(@Event, '{0}', s1.Name),
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDs AS s
                LEFT JOIN Items.t_ItemShared AS s1
                    ON s1.ID = s.ID;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;









GO
