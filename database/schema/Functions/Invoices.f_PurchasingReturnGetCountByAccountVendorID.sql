SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_PurchasingReturnGetCountByAccountVendorID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT(t.ID)
                FROM Invoices.t_PurchasingReturn AS t
                WHERE t.AccountVendorID = @ID
             );

  END;

  RETURN COALESCE(@C, 0);

END;






GO
