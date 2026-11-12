SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Customers].[f_FrameJobOrderGetCountByCustomerID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT(t.ID)
                FROM Customers.t_FrameJobOrder AS t
                WHERE t.CustomerID = @ID AND t.StatusIs <> 4
             ) + ( SELECT COUNT(t.ID)
                    FROM Customers.t_FrameJobOrderHistory AS t
                    WHERE t.CustomerID = @ID AND t.StatusIs <> 4
                 );

  END;

  RETURN COALESCE(@C, 0);

END;


GO
