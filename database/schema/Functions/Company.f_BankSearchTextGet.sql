SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_BankSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			CONVERT(NVARCHAR(MAX), t1.ID) + ', ' + 
			FORMAT(t1.NumberIs, N'0') + ', ' + 
			FORMAT(t1.Balance, N'0.####') + ', ' + 
			LOWER(t.Phones) + ', ' + 
			LOWER(t.SocialMedia) + ', ' + 
			LOWER(t.StatesIs) + ', ' + 
			LOWER(t.RegionIs) + ', ' + 
			LOWER(t.Street) + ', ' + 
			LOWER(t.Building) + ', ' + 
			LOWER(t.FloorIs) + ', ' + 
			LOWER(t.PostalCode) + ', ' + 
			LOWER(t.AddressNote) + ', ' + 
			LOWER(t.AddressIs) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			LOWER(t.WhyThisStatus) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Company.t_Bank AS t
    INNER  JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                           AND t1.SectionID = 38
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;











GO
