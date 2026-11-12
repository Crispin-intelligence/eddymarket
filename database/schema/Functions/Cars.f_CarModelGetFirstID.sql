SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [Cars].[f_CarModelGetFirstID] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Cars.t_CarModel AS t
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;













GO
