SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[f_LanguageCodeGetLebanonID] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Alls.t_LanguageCode AS t
		WHERE t.CountryCallingCode = N'961'
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;










GO
