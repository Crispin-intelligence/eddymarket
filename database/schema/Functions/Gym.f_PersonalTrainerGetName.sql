SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Gym].[f_PersonalTrainerGetName] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @Name NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT @Name = t.Name
      FROM Gym.t_PersonalTrainer AS t
      WHERE t.ID = @ID;

  END;

  RETURN COALESCE(@Name, '');

END;







GO
