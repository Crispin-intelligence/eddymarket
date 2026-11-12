SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_GymSubscriptionGetCountByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT_BIG(t.ID)
                FROM Gym.t_GymSubscription AS t
                WHERE t.AccountID = @ID
             ) + ( SELECT COUNT_BIG(t.ID)
                    FROM Gym.t_GymSubscriptionHistory AS t
                    WHERE t.AccountID = @ID
                 );

  END;

  RETURN COALESCE(@C, 0);

END;







GO
