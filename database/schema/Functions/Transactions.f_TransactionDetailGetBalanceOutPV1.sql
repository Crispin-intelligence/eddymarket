SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Transactions].[f_TransactionDetailGetBalanceOutPV1]
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
            LEFT JOIN Transactions.t_Transaction AS t1
                ON t1.ID = t.TransactionID
        WHERE t1.TypeIs = 'PV'
              AND t1.LinkType IN ( 3, 69 )
              AND t.BalanceD < 0
              AND t1.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;
    ELSE IF @CurrencyType = 1
    BEGIN --Set LL

        SELECT @v = COALESCE(SUM(t.BalanceLL), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Transactions.t_Transaction AS t1
                ON t1.ID = t.TransactionID
        WHERE t1.TypeIs = 'PV'
              AND t1.LinkType IN ( 3, 69 )
              AND t.BalanceLL < 0
              AND t1.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;
    ELSE IF @CurrencyType = 2
    BEGIN --Set Euro

        SELECT @v = COALESCE(SUM(t.BalanceEuro), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Transactions.t_Transaction AS t1
                ON t1.ID = t.TransactionID
        WHERE t1.TypeIs = 'PV'
              AND t1.LinkType IN ( 3, 69 )
              AND t.BalanceEuro < 0
              AND t1.DateOnly
              BETWEEN @FromDate AND @ToDate;

    END;

    RETURN @v;

END;





GO
