SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Quotations].[f_QuotationGetCountByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT(t.ID)
                FROM Quotations.t_Quotation AS t
                WHERE t.AccountID = @ID AND t.StatusIs <> 5
             ) + ( SELECT COUNT(t.ID)
                    FROM Quotations.t_QuotationHistory AS t
                    WHERE t.AccountID = @ID AND t.StatusIs <> 5
                 );

  END;

  RETURN COALESCE(@C, 0);

END;






GO
