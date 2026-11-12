SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Gym].[f_GymSubscriptionDeletedGetClassCount] ( @ID UNIQUEIDENTIFIER )
RETURNS INT
AS
BEGIN

  RETURN (SELECT COUNT(s.ID) FROM Gym.t_GymSubscriptionDeletedClass AS s
  WHERE s.SubscriptionID = @ID);

END;






GO
