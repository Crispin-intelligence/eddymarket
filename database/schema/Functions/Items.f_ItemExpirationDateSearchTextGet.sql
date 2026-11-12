SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemExpirationDateSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(t.RefF) + ', ' + 
			LOWER(t1.Name) + ', ' + 
			LOWER(t1.Barcodes) + ', ' + 
			LOWER(t.WareHouse) + ', ' + 
			LOWER(t.Place) + ', ' + 
			LOWER(t.Barcode) + ', ' + 
			FORMAT(t.Qtys, N'0') + ', ' + 
			FORMAT(t.ProductionDate, N'dd-MM-yyyy') + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_ItemExpirationDate AS t
        INNER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.ItemSharedID
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;








GO
