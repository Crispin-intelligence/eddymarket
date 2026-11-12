SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionGetTotalCreditLessDateDWithMerge1]
(
    @AccountID UNIQUEIDENTIFIER,
    @DateIs DATE,
    @CurrencyID UNIQUEIDENTIFIER
)
RETURNS FLOAT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @IDs AS TABLE
        (
            ID UNIQUEIDENTIFIER NOT NULL
        );

        DECLARE @v FLOAT;

    END;

    BEGIN --Set IDs

        INSERT INTO @IDs
        (
            ID
        )
        SELECT @AccountID
        UNION ALL
        SELECT s.AccountIDWith
        FROM Company.t_AccountMerge AS s
        WHERE s.AccountID = @AccountID;

    END;

    BEGIN --Set

        SELECT @v = ISNULL(SUM(t.CreditD), 0)
        FROM Transactions.t_TransactionDetail AS t
        WHERE EXISTS
        (
            SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t.AccountID
        )
              AND t.DateOnly < @DateIs
              AND t.CurrencyID = @CurrencyID;

    END;

    RETURN @v;

END;


GO
