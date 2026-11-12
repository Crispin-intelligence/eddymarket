SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Gym].[f_GymClassGetNumberOfActiveAccounts] ( @ID UNIQUEIDENTIFIER )
RETURNS INT
AS
BEGIN

  RETURN  ( SELECT COUNT(*)
        FROM Gym.t_GymSubscriptionClass AS s
        INNER JOIN Gym.t_GymSubscription AS s1 ON s1.ID = s.SubscriptionID
        WHERE s.ClassID = @ID AND s1.IsActive = 1
    );

END;






GO
