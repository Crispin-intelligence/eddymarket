SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Transactions].[f_TransactionGetBalanceLessDate]
    (
      @AccountID UNIQUEIDENTIFIER ,
      @DateIs DATETIME ,
      @CurrencyID UNIQUEIDENTIFIER
    )
RETURNS FLOAT
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @Balance FLOAT ,
                @CurrencyType TINYINT;

        END;

        BEGIN --Set

            SET @CurrencyType = Currencys.f_CurrencyGetTypeIs(@CurrencyID);

        END;

        BEGIN --Get
		
            IF @CurrencyType = 0
                BEGIN

                    SELECT  @Balance = SUM(t.BalanceD)
                    FROM    Transactions.t_TransactionDetail AS t
                    WHERE   t.AccountID = @AccountID
                            AND t.DateIs <= @DateIs;
					             
                END;
            ELSE
                IF @CurrencyType = 1
                    BEGIN
					
                        SELECT  @Balance = SUM(t.BalanceLL)
                        FROM    Transactions.t_TransactionDetail AS t
                        WHERE   t.AccountID = @AccountID
                                AND t.DateIs <= @DateIs;
									                               
                    END;
                ELSE
                    IF @CurrencyType = 2
                        BEGIN

                            SELECT  @Balance = SUM(t.BalanceEuro)
                            FROM    Transactions.t_TransactionDetail AS t
                            WHERE   t.AccountID = @AccountID
                                    AND t.DateIs <= @DateIs;	
							                               
                        END;

        END;

        RETURN ISNULL(@Balance,0);

    END;


GO
