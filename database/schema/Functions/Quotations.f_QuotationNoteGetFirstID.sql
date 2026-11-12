SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [Quotations].[f_QuotationNoteGetFirstID] ()
RETURNS UNIQUEIDENTIFIER
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Quotations.t_QuotationNote AS t
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;












GO
