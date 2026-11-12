SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Gym].[f_SubscriptionTypeNameFFix]
    (
      @Name NVARCHAR(450) ,
      @TypeIs TINYINT ,
      @PriceF NVARCHAR(MAX)
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

  --RETURN @Name + ' - ' + CASE @TypeIs
  --                                 WHEN 0 THEN N'daily'
  --                                 WHEN 1 THEN N'weekly'
  --                                 WHEN 2 THEN N'monthly'
  --                                 ELSE N'yearly'
  --                               END + N' - ' + @PriceF;

        RETURN @Name + ' - ' + @PriceF;

    END;



GO
