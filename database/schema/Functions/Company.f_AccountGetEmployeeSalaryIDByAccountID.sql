SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Company].[f_AccountGetEmployeeSalaryIDByAccountID] ( @ID UNIQUEIDENTIFIER )
RETURNS UNIQUEIDENTIFIER
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @ID_ UNIQUEIDENTIFIER ,
      @EmployeeID UNIQUEIDENTIFIER;

  END;

  BEGIN --Get
      
    SELECT TOP ( 1 ) @EmployeeID = t.LinkWithID
      FROM Company.t_Account AS t
      WHERE t.ID = @ID;

  END;

  BEGIN --Set

    SELECT TOP ( 1 ) @ID_ = t.ID
      FROM Company.t_Account AS t
      WHERE t.LinkWithID = @EmployeeID AND t.NumberIs BETWEEN 6310100000 AND 6310199999
      ORDER BY t.DateCreate;

  END;

  RETURN @ID_;

END;














GO
