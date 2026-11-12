SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Cars].[f_CarClassSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(Name) + ', ' + 
			LOWER(DescriptionIs) + ', ' + 
			FORMAT(CarsCount, N'0') + ', ' + 
			FORMAT(AvailableCarsCount, N'0') + ', ' + 
			FORMAT(UnavailableCarsCount, N'0') + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Cars.t_CarClass AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;








GO
