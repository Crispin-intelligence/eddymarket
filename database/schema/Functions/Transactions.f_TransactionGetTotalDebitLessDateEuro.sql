SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionGetTotalDebitLessDateEuro]
(
    @AccountID UNIQUEIDENTIFIER,
    @DateIs DATE
)
RETURNS FLOAT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @v FLOAT;

    END;

    BEGIN --Set

        SELECT @v = ISNULL(SUM(t.DebitEuro), 0)
        FROM Transactions.t_TransactionDetail AS t
        WHERE t.AccountID = @AccountID
              AND t.DateOnly < @DateIs;

    END;

    RETURN @v;

END;

GO
