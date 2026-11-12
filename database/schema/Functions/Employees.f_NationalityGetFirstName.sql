SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create FUNCTION [Employees].[f_NationalityGetFirstName] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @Name = t.Name
        FROM Employees.t_Nationality AS t
        ORDER BY t.DateCreate;

    END;

    RETURN COALESCE(@Name, '');

END;




GO
