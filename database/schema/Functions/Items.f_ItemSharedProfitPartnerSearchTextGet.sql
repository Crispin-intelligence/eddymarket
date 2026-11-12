SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Items].[f_ItemSharedProfitPartnerSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(t.ProfitPartner) + ', ' + 
			FORMAT(t.ProfitRatio, N'0.##') +
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_ItemsharedProfitPartner AS t
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;












GO
