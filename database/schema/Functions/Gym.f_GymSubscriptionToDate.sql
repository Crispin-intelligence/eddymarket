SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Gym].[f_GymSubscriptionToDate]
  (
    @SubscriptionTypeID UNIQUEIDENTIFIER ,
    @DateIs DATE
  )
RETURNS DATE
AS
BEGIN

  BEGIN --DECLARE
  
    DECLARE @TypeIs TINYINT ,
      @NumberIs INT;
	  
  END;

  BEGIN --Set Info
      
    SELECT TOP ( 1 ) @TypeIs = s.TypeIs ,
        @NumberIs = s.NumberIs
      FROM Gym.t_SubscriptionType AS s
      WHERE s.ID = @SubscriptionTypeID;

  END;

  RETURN CASE @TypeIs
                       WHEN 0 THEN
                           DATEADD(DAY, @NumberIs,DATEADD(DAY,-1, @DateIs))
                       WHEN 1 THEN
                           DATEADD(WEEK, @NumberIs, DATEADD(DAY,-1, @DateIs))
                       WHEN 2 THEN
                           DATEADD(MONTH, @NumberIs, DATEADD(DAY,-1, @DateIs))
                       ELSE
                           DATEADD(YEAR, @NumberIs, DATEADD(DAY,-1, @DateIs))
                   END;
  
END;


GO
