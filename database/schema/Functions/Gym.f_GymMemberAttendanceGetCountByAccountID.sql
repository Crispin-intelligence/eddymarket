SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Gym].[f_GymMemberAttendanceGetCountByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS BIGINT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @C BIGINT;

  END;

  BEGIN --Set

    SET @C = ( SELECT COUNT_BIG(t.ID)
                FROM Gym.t_GymMemberAttendance AS t
                WHERE t.AccountID = @ID
             );

  END;

  RETURN COALESCE(@C, 0);

END;







GO
