SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_LanguageCodeSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.ShortCode) + ', ' + 
			LOWER(t.FullCode) + ', ' + 
			LOWER(t.CountryCallingCode) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Alls.t_LanguageCode AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;


GO
