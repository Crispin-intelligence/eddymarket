SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Company].[f_AccountLevel3SearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.Level2) + ', ' + 
			LOWER(t.NumberF) + ', ' + 
			LOWER(t.Name) + ', ' + 
			FORMAT(t.BalanceD, N'0') + ', ' + 
			FORMAT(t.BalanceLL, N'0') + ', ' + 
			FORMAT(t.BalanceEuro, N'0') + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Company.t_AccountLevel3 AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;


GO
