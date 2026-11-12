SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_SubscriptionTypeGetFirstName] ( )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @Name NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 ) @Name = t.Name
      FROM Gym.t_SubscriptionType AS t
      ORDER BY t.DateCreate;

  END;

  RETURN COALESCE(@Name, '');

END;





GO
