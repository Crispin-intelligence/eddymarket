SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Quotations].[f_QuotationGetProfitByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS FLOAT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @V FLOAT;

  END;

  BEGIN --Set

    SET @V = ( SELECT COALESCE(SUM(CASE t1.CurrencyTypeIs
                                     WHEN 0 THEN t.ProfitD
                                     WHEN 1 THEN t.ProfitLL
                                     ELSE t.ProfitEuro
                                   END), 0)
                FROM Quotations.t_Quotation AS t
                  INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                WHERE t.AccountID = @ID AND t.StatusIs <> 5
             ); 
	 
    SET @V += ( SELECT COALESCE(SUM(CASE t1.CurrencyTypeIs
                                      WHEN 0 THEN t.ProfitD
                                      WHEN 1 THEN t.ProfitLL
                                      ELSE t.ProfitEuro
                                    END), 0)
                  FROM Quotations.t_Quotation AS t
                    INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
                  WHERE t.AccountID = @ID AND t.StatusIs <> 5
              );  

  END;

  RETURN COALESCE(@V, 0);

END;












GO
