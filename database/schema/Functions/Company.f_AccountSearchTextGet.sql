SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Company].[f_AccountSearchTextGet] ( @ID UNIQUEIDENTIFIER )
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
			LOWER(t.Level3) + ', ' + 
			LOWER(t.LinkWith) + ', ' + 
			LOWER(t.NumberF) + ', ' + 
			LOWER(t.Name) + ', ' + 
			LOWER(t.BalanceF) + ', ' + 
			LOWER(t.Currency) + ', ' + 
			LOWER(t.LimitF) + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			LOWER(t.UsersNames) + ', ' + 
			LOWER(t.AccountMergeNames) + ', ' + 
			LOWER(t.WhyThisStatus) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Company.t_Account AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;


GO
