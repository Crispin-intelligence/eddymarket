SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_PurchasingRefPaperGetLast]
(
    @AccountVendorID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @RefPaper NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @RefPaper = t.RefPaper
        FROM Invoices.t_Purchasing AS t
        WHERE t.AccountVendorID = @AccountVendorID
        ORDER BY t.DateIs DESC;

    END;

    RETURN COALESCE(@RefPaper, '');

END;


GO
