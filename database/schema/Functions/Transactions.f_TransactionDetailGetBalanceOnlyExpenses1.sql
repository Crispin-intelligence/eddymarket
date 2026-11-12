SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionDetailGetBalanceOnlyExpenses1]
(
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
        WHERE t1.NumberIs
              BETWEEN 6260400000 AND 6269999999
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;
    ELSE IF @CurrencyType = 1
    BEGIN --Set LL

        SELECT @v = COALESCE(SUM(t.BalanceLL), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Company.t_Account AS t1
                ON t1.ID = t.AccountID
        WHERE t1.NumberIs
              BETWEEN 6260400000 AND 6269999999
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;
    ELSE IF @CurrencyType = 2
    BEGIN --Set Euro

        SELECT @v = COALESCE(SUM(t.BalanceEuro), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Company.t_Account AS t1
                ON t1.ID = t.AccountID
        WHERE t1.NumberIs
              BETWEEN 6260400000 AND 6269999999
              AND t.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;

    RETURN @v;

END;





GO
