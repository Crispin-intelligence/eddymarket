SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Customers].[f_CustomerGetIDDoorByAccount]
  (
    @AccountID UNIQUEIDENTIFIER
  )
RETURNS INT
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @IDDoor INT;

  END;

  BEGIN --Set
  
    SELECT @IDDoor = t1.IDDoor
      FROM Company.t_Account AS t
      INNER JOIN Customers.t_Customer AS t1 ON t1.ID = t.LinkWithID AND t.SectionID = 15
      WHERE t.ID = @AccountID;

  END;

  RETURN COALESCE(@IDDoor, 0);

END;




GO
