SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Gym].[f_GymSubscriptionGetClassCount] ( @ID UNIQUEIDENTIFIER )
RETURNS INT
AS
BEGIN

  RETURN (SELECT COUNT(s.ID) FROM Gym.t_GymSubscriptionClass AS s
  WHERE s.SubscriptionID = @ID);

END;




GO
