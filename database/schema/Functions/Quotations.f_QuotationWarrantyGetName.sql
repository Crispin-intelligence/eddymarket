SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Quotations].[f_QuotationWarrantyGetName]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT @Name = t.Name
        FROM Quotations.t_QuotationWarranty AS t
        WHERE t.ID = @ID;

    END;

    RETURN COALESCE(@Name, '');

END;





GO
