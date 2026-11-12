SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Items].[f_ReasonStockAdjustmentGetFirstName] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @Name = t.Name
        FROM items.t_ReasonStockAdjustment AS t
        ORDER BY t.DateCreate;

    END;

    RETURN COALESCE(@Name, '');

END;





GO
