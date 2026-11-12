SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Cars].[f_CarDriverSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(t.Name) + ', ' + 
			LOWER(t.DrivingLicense) + ', ' + 
			FORMAT(t.LicenseExpirationDate, N'dd-MM-yyyy') + ', '+
			LOWER(t.Phones) + ', ' + 
			LOWER(t.SocialMedia) + ', ' + 
			LOWER(t.Nationality) + ', ' + 
			LOWER(t.Title) + ', ' + 
			LOWER(t.Classification) + ', ' + 
			FORMAT(t.Birthday, N'dd-MM-yyyy') + ', '+
			LOWER(t.AgeIs) + ', ' + 
			LOWER(t.AddressIs) + ', ' +
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Cars.t_CarDriver AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;









GO
