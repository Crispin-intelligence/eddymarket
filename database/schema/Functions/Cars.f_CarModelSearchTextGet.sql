SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [Cars].[f_CarModelSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			CONVERT(NVARCHAR(MAX), t.ID) + ', ' + 
			LOWER(t.Name) + ', ' + 
			LOWER(t.CarMake) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.CarsCount, N'0') + ', ' + 
			FORMAT(t.AvailableCarsCount, N'0') + ', ' + 
			FORMAT(t.UnavailableCarsCount, N'0') + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Cars.t_CarModel AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;









GO
