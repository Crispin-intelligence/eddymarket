SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_CloseBoxUpdate]
    @DescriptionIs NVARCHAR(MAX),
    @Detail [Company].[tt_CloseBoxDetail] READONLY,
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

            DECLARE @Detail1 AS TABLE
            (
                CurrencyTypeIs TINYINT NOT NULL,
                Total FLOAT NOT NULL
            );

            DECLARE @ExchangeRate DECIMAL(18,2),
                    @return INT;

        END;

        BEGIN --Set info

            SELECT TOP (1)
                   @ExchangeRate = s.ExchangeRate
            FROM Company.t_CloseBox AS s
            WHERE s.ID = @ID
            ORDER BY s.ID;

        END;

        BEGIN --Insert

            SET @return = 0;

            UPDATE Company.t_CloseBox
            SET TotalD = 0,
                TotalDF = '',
                TotalLL = 0,
                TotalLLF = '',
                TotalEuro = 0,
                TotalEuroF = '',
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

        END;

        BEGIN --Insert detail

            DELETE FROM Company.t_CloseBoxDetail
            WHERE CloseBoxID = @ID;

            INSERT INTO Company.t_CloseBoxDetail
            (
                CloseBoxID,
                CurrencyID,
                Currency,
                CurrencyTypeIs,
                Price,
                PriceF,
				PriceD,
                Qty,
                Total,
                TotalF,
				DescriptionIs
            )
            OUTPUT Inserted.CurrencyTypeIs,
                   Inserted.Total
            INTO @Detail1
            SELECT @ID,
                   s.CurrencyID,
                   s1.Name,
                   s1.TypeIs,
                   s.Price,
                   Currencys.f_Format(s.CurrencyID, s.Price),
				   s.Price / @ExchangeRate,
                   s.Qty,
                   s.Price * s.Qty,
                   Currencys.f_Format(s.CurrencyID, s.Price * s.Qty),
				   s.DescriptionIs
            FROM @Detail AS s
                LEFT JOIN Currencys.t_Currency AS s1
                    ON s1.ID = s.CurrencyID;

        END;

        BEGIN --Rebuilding Statistics

            UPDATE Company.t_CloseBox
            SET TotalD =
                (
                    SELECT COALESCE(SUM(s.Total), 0)
                    FROM @Detail1 AS s
                    WHERE s.CurrencyTypeIs = 0
                ),
                TotalLL =
                (
                    SELECT COALESCE(SUM(s.Total), 0)
                    FROM @Detail1 AS s
                    WHERE s.CurrencyTypeIs = 1
                ),
                TotalEuro =
                (
                    SELECT COALESCE(SUM(s.Total), 0)
                    FROM @Detail1 AS s
                    WHERE s.CurrencyTypeIs = 2
                )
            WHERE ID = @ID;

            UPDATE Company.t_CloseBox
            SET TotalDF = Currencys.f_FormatD(TotalD),
                TotalLLF = Currencys.f_FormatLL(TotalLL),
                TotalEuroF = Currencys.f_FormatEuro(TotalEuro)
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @return = -1;

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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @return;

    END CATCH;

END;








GO
