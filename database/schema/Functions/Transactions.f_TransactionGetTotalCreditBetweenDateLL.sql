SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Transactions].[f_TransactionGetTotalCreditBetweenDateLL]
    (
      @AccountID UNIQUEIDENTIFIER ,
      @FromDate DATE ,
      @ToDate DATE
    )
RETURNS FLOAT
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @v FLOAT;

        END;

        BEGIN --Set

            SELECT  @v = ISNULL(SUM(t.CreditLL), 0)
            FROM    Transactions.t_TransactionDetail AS t
            WHERE   t.AccountID = @AccountID
                    AND t.DateOnly BETWEEN @FromDate AND @ToDate;

        END;

        RETURN @v;

    END;


GO
