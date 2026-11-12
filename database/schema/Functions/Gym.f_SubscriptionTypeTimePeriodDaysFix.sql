SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Gym].[f_SubscriptionTypeTimePeriodDaysFix]
  (
    @TypeIs TINYINT ,
    @NumberIs INT
  )
RETURNS INT
AS
BEGIN

  RETURN CASE @TypeIs
                               WHEN 0 THEN @NumberIs
                               WHEN 1 THEN @NumberIs * 7
                               WHEN 2 THEN @NumberIs * 31
                               ELSE @NumberIs * 366
                             END;

END;


GO
