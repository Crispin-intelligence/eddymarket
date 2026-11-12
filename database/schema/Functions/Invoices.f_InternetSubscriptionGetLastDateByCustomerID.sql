SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Invoices].[f_InternetSubscriptionGetLastDateByCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS DATE
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @D DATE;

  END;

  BEGIN --Set

    SET @D = ( SELECT TOP ( 1 ) o.DateIs
                FROM ( SELECT t.DateIs
                        FROM Invoices.t_InternetSubscription AS t
                        WHERE t.CustomerID = @ID
                       UNION ALL
                       SELECT t.DateIs
                        FROM Invoices.t_InternetSubscriptionHistory AS t
                        WHERE t.CustomerID = @ID
                     ) AS o
                ORDER BY o.DateIs DESC
             );

  END;

  RETURN COALESCE(@D, DATEFROMPARTS(2000, 1, 1));

END;





GO
