SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Invoices].[f_DeliveryServiceGetCountByAccountCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT(t.ID)
                FROM Invoices.t_DeliveryService AS t
                WHERE t.AccountCustomerID = @ID AND t.StatusIs <> 5
             ) + ( SELECT COUNT(t.ID)
                    FROM Invoices.t_DeliveryServiceHistory AS t
                    WHERE t.AccountCustomerID = @ID AND t.StatusIs <> 5
                 );

  END;

  RETURN COALESCE(@C, 0);

END;





GO
