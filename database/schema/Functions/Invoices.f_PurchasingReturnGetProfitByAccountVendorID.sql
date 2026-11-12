SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_PurchasingReturnGetProfitByAccountVendorID] ( @ID UNIQUEIDENTIFIER )
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
                FROM Invoices.t_PurchasingReturn AS t
                  INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountVendorID
                WHERE t.AccountVendorID = @ID
             ); 
	 
  END;

  RETURN COALESCE(@V, 0);

END;












GO
