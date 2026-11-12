SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_GymSubscriptionHistoryGetClassesNames] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  RETURN Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                              FROM Gym.t_GymSubscriptionHistoryClass AS t
                                              LEFT JOIN Gym.t_GymClass AS t1 ON t1.ID = t.ClassID
                                              WHERE t.SubscriptionID = @ID
                                           FOR
                                             XML PATH('')
                                           ));

END;



GO
