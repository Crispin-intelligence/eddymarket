SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Currencys].[f_CurrencyGetFirstNameLL] ( )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @Name NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 ) @Name = t.Name
      FROM Currencys.t_Currency AS t
      WHERE t.TypeIs = 1;

  END;

  RETURN COALESCE(@Name, '');

END;




GO
