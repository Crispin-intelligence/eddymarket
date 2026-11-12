SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Gym].[f_PersonalTrainerNameFFix]
  (
    @Name NVARCHAR(450) ,
    @PriceF NVARCHAR(MAX)
  )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  RETURN @Name + ' - ' + @PriceF;

END;





GO
