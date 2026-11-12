SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(t1.Name) + ', ' + 
			LOWER(t1.Barcodes) + ', ' + 
			LOWER(t.WareHouse) + ', ' + 
			LOWER(t.Place) + ', ' + 
			FORMAT(t.QtyCurrent, N'0.####') + ', ' + 
			LOWER(t.QtyCurrentByUnit) + ', ' + 
			FORMAT(t.QtyToReorder, N'0') + ', ' + 
			LOWER(t.DescriptionIs) + ', ' + 
			FORMAT(t.LastStockTakeDate, N'dd-MM-yyyy') + 
			LOWER(t.StockTakeEveryARF) + ', ' + 
			LOWER(t.StockTakeEveryENF) + ', ' + 
			FORMAT(t.StockTakeEveryNotificationDate, N'dd-MM-yyyy') + 
			FORMAT(t.DateCreate, N'dd-MM-yyyy hh:mm tt')
    FROM    Items.t_Item AS t
	    INNER JOIN Items.t_ItemShared AS t1	ON t1.ID = t.SharedID
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;









GO
