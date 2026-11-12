SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_SubscriptionTypeTimePeriodARFFix]
  (
    @TypeIs TINYINT ,
    @NumberIs INT
  )
RETURNS NVARCHAR(max)
AS
BEGIN

  DECLARE @NumberIsF AS NVARCHAR(MAX) = FORMAT(@NumberIs, N'0');

  RETURN CASE @TypeIs
                                   WHEN 0 THEN @NumberIsF + N' أيام'
                                   WHEN 1 THEN @NumberIsF + N' أسابيع'
                                   WHEN 2 THEN @NumberIsF + N' أشهر'
                                   ELSE @NumberIsF + N' سنوات'
                                 END;

END;





GO
