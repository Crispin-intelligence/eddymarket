SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Transactions].[f_TransactionCheckHaveLinkTypeSub]
  (
    @LinkType TINYINT ,
    @LinkID UNIQUEIDENTIFIER
  )
RETURNS BIT
AS
BEGIN
	
  IF EXISTS ( SELECT TOP ( 1 )
                      s.ID
              FROM    Transactions.t_Transaction AS s
              WHERE   s.LinkType = @LinkType
                      AND s.LinkTypeSub <> 0
                      AND s.LinkID = @LinkID )
  BEGIN
      
    RETURN 1;

  END;

  RETURN 0;

END;



GO
