SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Gym].[f_GymSubscriptionDeletedGetClassesEmployeesNames] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  RETURN Alls.f_FixXML(( SELECT DISTINCT ', ' + t1.Name AS [text()]
                                              FROM Gym.t_GymSubscriptionDeletedClass AS t
                                              LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountEmployeeID
                                              WHERE t.SubscriptionID = @ID
                                           FOR
                                             XML PATH('')
                                           ));

END;





GO
