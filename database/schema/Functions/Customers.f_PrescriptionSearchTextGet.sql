SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Customers].[f_PrescriptionSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.RefF) + ', ' + 
			LOWER(t.RefPaper) + ', ' + 
			FORMAT(t.DateIs, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.Customer) + ', ' + 
			LOWER(t.Doctor) + ', ' + 
			LOWER(t.Brand) + ', ' + 
			LOWER(t.TypeIs) + ', ' + 
			LOWER(t.Focal) + ', ' +  
			LOWER(t.BaseRight) + ', ' + 
			LOWER(t.BaseLeft) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Customers.t_Prescription AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;
GO
