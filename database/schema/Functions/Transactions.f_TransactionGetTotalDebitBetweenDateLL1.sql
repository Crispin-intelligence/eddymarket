SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionGetTotalDebitBetweenDateLL1]
(
    @AccountID UNIQUEIDENTIFIER,
    @FromDate DATE,
    @ToDate DATE,
    @WithOpeningBalance BIT,
    @WithEndingBalance BIT
)
RETURNS FLOAT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @v FLOAT;

        DECLARE @BalanceTypes AS TABLE
        (
            BalanceType TINYINT NOT NULL
        );

    END;

    BEGIN --Set @BalanceTypes

        INSERT INTO @BalanceTypes
        (
            BalanceType
        )
        VALUES
        (0  );

        IF (@WithOpeningBalance = 1)
        BEGIN

            INSERT INTO @BalanceTypes
            (
                BalanceType
            )
            VALUES
            (1  );

        END;

        IF (@WithEndingBalance = 1)
        BEGIN

            INSERT INTO @BalanceTypes
            (
                BalanceType
            )
            VALUES
            (2  );

        END;

    END;

    BEGIN --Set

        SELECT @v = ISNULL(SUM(t.DebitLL), 0)
        FROM Transactions.t_TransactionDetail AS t
        WHERE t.AccountID = @AccountID
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate
              AND EXISTS
        (
            SELECT TOP (1)
                   s.BalanceType
            FROM @BalanceTypes AS s
            WHERE s.BalanceType = t.BalanceType
        );

    END;

    RETURN @v;

END;



GO
