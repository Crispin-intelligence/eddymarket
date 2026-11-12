SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Employees].[f_NationalitySearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			CONVERT(NVARCHAR(MAX), ID) + ', ' + 
			LOWER(Name) + ', ' + 
			LOWER(DescriptionIs) + ', ' + 
			FORMAT(EmployeeC, N'0') + ', ' + 
			FORMAT(CustomerC, N'0') + ', ' + 
			FORMAT(DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Employees.t_Nationality AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;










GO
