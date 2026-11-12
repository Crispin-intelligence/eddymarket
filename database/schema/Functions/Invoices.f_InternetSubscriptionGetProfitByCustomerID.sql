SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_InternetSubscriptionGetProfitByCustomerID] ( @ID UNIQUEIDENTIFIER )
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
                FROM Invoices.t_InternetSubscription AS t
                  INNER JOIN Company.t_Account AS t1 ON t1.LinkWithID = t.CustomerID AND t1.IsMasterLink = 1 AND t1.SectionID = 15
                WHERE t.CustomerID = @ID
             ); 
	 
    SET @V += ( SELECT COALESCE(SUM(CASE t1.CurrencyTypeIs
                                      WHEN 0 THEN t.ProfitD
                                      WHEN 1 THEN t.ProfitLL
                                      ELSE t.ProfitEuro
                                    END), 0)
                  FROM Invoices.t_InternetSubscriptionHistory AS t
                    INNER JOIN Company.t_Account AS t1 ON t1.LinkWithID = t.CustomerID AND t1.IsMasterLink = 1 AND t1.SectionID = 15
                  WHERE t.CustomerID = @ID
              );

  END;

  RETURN COALESCE(@V, 0);

END;












GO
