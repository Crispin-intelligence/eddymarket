SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_DeliveryServiceGetTotalByAccountCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS FLOAT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @V FLOAT;

  END;

  BEGIN --Set

    SET @V = ( SELECT COALESCE(SUM(CASE t1.CurrencyTypeIs
                                     WHEN 0 THEN t.DeliveryChargeD
                                     WHEN 1 THEN t.DeliveryChargeLL
                                     ELSE t.DeliveryChargeEuro
                                   END), 0)
                FROM Invoices.t_DeliveryService AS t
                  LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountCustomerID
                WHERE t.AccountCustomerID = @ID AND t.StatusIs <> 5
             ); 
	 
    SET @V += ( SELECT COALESCE(SUM(CASE t1.CurrencyTypeIs
                                      WHEN 0 THEN t.DeliveryChargeD
                                      WHEN 1 THEN t.DeliveryChargeLL
                                      ELSE t.DeliveryChargeEuro
                                    END), 0)
                  FROM Invoices.t_DeliveryServiceHistory AS t
                    LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountCustomerID
                  WHERE t.AccountCustomerID = @ID AND t.StatusIs <> 5
              );

  END;

  RETURN COALESCE(@V, 0);

END;











GO
