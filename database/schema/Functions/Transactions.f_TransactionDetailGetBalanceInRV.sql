SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionDetailGetBalanceInRV]
(
    @CurrencyType TINYINT
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
        WHERE t1.TypeIs = 'RV'
              AND t1.LinkType IN ( 69, 1 )
              AND t.BalanceD > 0;

    END;
    ELSE IF @CurrencyType = 1
    BEGIN --Set LL

        SELECT @v = COALESCE(SUM(t.BalanceLL), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Transactions.t_Transaction AS t1
                ON t1.ID = t.TransactionID
        WHERE t1.TypeIs = 'RV'
              AND t1.LinkType IN ( 69, 1 )
              AND t.BalanceLL > 0;

    END;
    ELSE IF @CurrencyType = 2
    BEGIN --Set Euro

        SELECT @v = COALESCE(SUM(t.BalanceEuro), 0)
        FROM Transactions.t_TransactionDetail AS t
            LEFT JOIN Transactions.t_Transaction AS t1
                ON t1.ID = t.TransactionID
        WHERE t1.TypeIs = 'RV'
              AND t1.LinkType IN ( 69, 1 )
              AND t.BalanceEuro > 0;

    END;

    RETURN @v;

END;




GO
