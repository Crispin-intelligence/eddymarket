SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_GymSubscriptionGetActiveToByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS DATE
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @D DATE;

  END;

  BEGIN --Set

    SET @D = ( SELECT TOP ( 1 ) o.ToDate
                FROM ( SELECT t.ToDate
                        FROM Gym.t_GymSubscription AS t
                        WHERE t.AccountID = @ID
                       UNION ALL
                       SELECT t.ToDate
                        FROM Gym.t_GymSubscriptionHistory AS t
                        WHERE t.AccountID = @ID
                     ) AS o
                ORDER BY o.ToDate DESC
             );

  END;

  RETURN COALESCE(@D, DATEFROMPARTS(2000, 1, 1));

END;






GO
