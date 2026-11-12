SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemGetNamesVendors] ( @SectionID INT )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        DECLARE @OutPut VARCHAR(MAX);

        SELECT  @OutPut = COALESCE(@OutPut + '; ', '') + t2.Name 
        FROM    Items.t_ItemSharedVendor AS t
                LEFT JOIN Vendors.t_Vendor AS t2 ON t.VendorID = t2.ID
        WHERE   t.SharedID = @SectionID;

        RETURN COALESCE( @OutPut , N'');

    END;







GO
