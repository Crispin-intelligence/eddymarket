SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionDetailGetBalanceByLevel3]
(
    @NumberIs BIGINT,
    @CurrencyType TINYINT,
    @FromDate DATE,
    @ToDate DATE
)
RETURNS FLOAT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @v FLOAT = 0;

    END;

    IF @CurrencyType = 0
    BEGIN --Set D

        SELECT @v = COALESCE(SUM(t.BalanceD), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Company.t_Account AS t1
                ON t1.ID = t.AccountID
            LEFT JOIN Company.t_AccountLevel3 AS t2
                ON t2.ID = t1.Level3ID
        WHERE t2.NumberIs = @NumberIs
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;
    ELSE IF @CurrencyType = 1
    BEGIN --Set LL

        SELECT @v = COALESCE(SUM(t.BalanceLL), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Company.t_Account AS t1
                ON t1.ID = t.AccountID
            LEFT JOIN Company.t_AccountLevel3 AS t2
                ON t2.ID = t1.Level3ID
        WHERE t2.NumberIs = @NumberIs
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;
    ELSE IF @CurrencyType = 2
    BEGIN --Set Euro

        SELECT @v = COALESCE(SUM(t.BalanceEuro), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Company.t_Account AS t1
                ON t1.ID = t.AccountID
            LEFT JOIN Company.t_AccountLevel3 AS t2
                ON t2.ID = t1.Level3ID
        WHERE t2.NumberIs = @NumberIs
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;

    RETURN @v;

END;




GO
