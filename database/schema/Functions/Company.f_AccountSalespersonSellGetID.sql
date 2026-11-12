SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Company].[f_AccountSalespersonSellGetID]
  (
    @SalespersonID UNIQUEIDENTIFIER
  )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @ID UNIQUEIDENTIFIER;

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
               @ID = ID
      FROM Company.t_Account AS t
      WHERE t.LinkWithID = @SalespersonID AND t.NumberIs BETWEEN 7010800000 AND 7010899999
      ORDER BY t.DateCreate;

  END;

  RETURN @ID;

END;













GO
