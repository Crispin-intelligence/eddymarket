SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_InvoiceTitleGetFirstName] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @Name = t.Name
        FROM Invoices.t_InvoiceTitle AS t
        ORDER BY t.DateCreate;

    END;

    RETURN COALESCE(@Name, '');

END;





GO
