SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Cars].[f_CarGetAvailabilityIsNow] ( @ID UNIQUEIDENTIFIER )
RETURNS BIT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @CountIs INT = 0;

  END;

  BEGIN --Set

    SELECT  @CountIs = COUNT(*)
    FROM    Cars.t_CarRental AS t
    WHERE   t.CarID = @ID
            AND ( ( t.StatusIs = 0
                    AND t.FromDate >= CONVERT(DATE, GETDATE())
                  )
                  OR t.StatusIs = 1
                );

  END;

  RETURN IIF(@CountIs = 0, 0, 1);

END;
GO
