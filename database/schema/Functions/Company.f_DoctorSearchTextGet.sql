SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_DoctorSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.NameAR) + ', ' + 
			LOWER(t.Phones) + ', ' + 
			LOWER(t.SocialMedia) + ', ' + 
			FORMAT(t.Birthday, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.AgeIs) + ', ' + 
			LOWER(t.Hospitals) + ', ' + 
			LOWER(t.AddressIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Company.t_Doctor AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;

GO
