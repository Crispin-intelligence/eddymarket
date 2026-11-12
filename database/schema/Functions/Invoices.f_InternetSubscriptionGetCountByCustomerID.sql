SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_InternetSubscriptionGetCountByCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT(t.ID)
                FROM Invoices.t_InternetSubscription AS t
                WHERE t.CustomerID = @ID
             ) + ( SELECT COUNT(t.ID)
                    FROM Invoices.t_InternetSubscriptionHistory AS t
                    WHERE t.CustomerID = @ID
                 );

  END;

  RETURN COALESCE(@C, 0);

END;

GO
