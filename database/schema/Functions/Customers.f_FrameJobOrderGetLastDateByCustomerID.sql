SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Customers].[f_FrameJobOrderGetLastDateByCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS DATE
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @D DATE;

  END;

  BEGIN --Set

    SET @D = ( SELECT TOP ( 1 ) o.DateIs
                FROM ( SELECT t.DateIs
                        FROM Customers.t_FrameJobOrder AS t
                        WHERE t.CustomerID = @ID AND t.StatusIs <> 4
                       UNION ALL
                       SELECT t.DateIs
                        FROM Customers.t_FrameJobOrderHistory AS t
                        WHERE t.CustomerID = @ID AND t.StatusIs <> 4
                     ) AS o
                ORDER BY o.DateIs DESC
             );

  END;

  RETURN COALESCE(@D, DATEFROMPARTS(2000, 1, 1));

END;






GO
