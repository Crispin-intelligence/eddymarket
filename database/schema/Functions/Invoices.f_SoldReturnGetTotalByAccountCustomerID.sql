SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_SoldReturnGetTotalByAccountCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS FLOAT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @V FLOAT;

  END;

  BEGIN --Set

    SET @V = ( SELECT COALESCE(SUM(CASE t1.CurrencyTypeIs
                                     WHEN 0 THEN t.NetIsD
                                     WHEN 1 THEN t.NetIsLL
                                     ELSE t.NetIsEuro
                                   END), 0)
                FROM Invoices.t_SoldReturn AS t
                  INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountCustomerID
                WHERE t.AccountCustomerID = @ID
             ); 
	 
  END;

  RETURN COALESCE(@V, 0);

END;













GO
