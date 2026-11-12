SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_SubscriptionTypeTimePeriodENFFix]
  (
    @TypeIs TINYINT ,
    @NumberIs INT
  )
RETURNS NVARCHAR(max)
AS
BEGIN

  DECLARE @NumberIsF AS NVARCHAR(MAX) = FORMAT(@NumberIs, N'0');

  RETURN CASE @TypeIs
                                   WHEN 0 THEN @NumberIsF + N' Days'
                                   WHEN 1 THEN @NumberIsF + N' Weeks'
                                   WHEN 2 THEN @NumberIsF + N' Months'
                                   ELSE @NumberIsF + N' Years'
                                 END;

END;





GO
