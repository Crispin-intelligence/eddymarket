SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountSalesGetFirstID] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Company.t_Account AS t
        WHERE t.NumberIs
        BETWEEN 7010100000 AND 7010199999
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;












GO
