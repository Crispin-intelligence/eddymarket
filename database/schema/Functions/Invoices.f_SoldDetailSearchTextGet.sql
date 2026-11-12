SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_SoldDetailSearchTextGet] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(MAX)
AS
BEGIN

  BEGIN --DECLARE

    DECLARE @SearchText NVARCHAR(MAX);

  END;

  BEGIN --Set

    SELECT TOP ( 1 )
            @SearchText = 
			LOWER(t1.RefF) + ', ' + 
			FORMAT(t1.DateOnly, N'dd-MM-yyyy') + ', ' + 
			LOWER(t1.AccountCustomer) + ', ' + 
			LOWER(t2.Name) + ', ' + 
			LOWER(t2.Barcode) + ', ' + 
			LOWER(t3.WareHouse) + ', ' + 
			LOWER(t3.Place) + ', ' + 
			LOWER(t.QtyWithUnity) + ', ' + 
			LOWER(t.PriceF) + ', ' + 
			LOWER(t.TotalF) + ', ' + 
			LOWER(t.RefPurchaseOrder) + ', ' + 
			LOWER(t.DescriptionIs)
    FROM    Invoices.t_SoldDetail AS t
        INNER JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SoldID
        INNER JOIN Items.t_ItemShared AS t2 ON t2.ID = t.ItemSharedID
        INNER JOIN Items.t_Item AS t3 ON t3.ID = t.ItemID
    WHERE   t.ID = @ID;

  END;

  RETURN COALESCE(@SearchText, '');

END;




GO
