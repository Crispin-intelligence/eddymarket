SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Transactions].[f_TransactionGetTotalDebitLessDateLLWithMerge]
(
    @AccountID UNIQUEIDENTIFIER,
    @DateIs DATE
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

        SELECT @v = ISNULL(SUM(t.DebitLL), 0)
        FROM Transactions.t_TransactionDetail AS t
        WHERE EXISTS
        (
            SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t.AccountID
        )
              AND t.DateOnly < @DateIs;

    END;

    RETURN @v;

END;

GO
