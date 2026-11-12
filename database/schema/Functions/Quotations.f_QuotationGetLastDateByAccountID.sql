SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Quotations].[f_QuotationGetLastDateByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS DATE
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @D DATE;

  END;

  BEGIN --Set

    SET @D = ( SELECT TOP ( 1 ) o.DateIs
                FROM ( SELECT t.DateIs
                        FROM Quotations.t_Quotation AS t
                        WHERE t.AccountID = @ID AND t.StatusIs <> 5
                       UNION ALL
                       SELECT t.DateIs
                        FROM Quotations.t_QuotationHistory AS t
                        WHERE t.AccountID = @ID AND t.StatusIs <> 5
                     ) AS o
                ORDER BY o.DateIs DESC
             );

  END;

  RETURN COALESCE(@D, DATEFROMPARTS(2000, 1, 1));

END;





GO
