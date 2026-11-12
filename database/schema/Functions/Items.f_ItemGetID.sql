SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_ItemGetID]
(
    @ItemSharedID UNIQUEIDENTIFIER,
    @WarehouseID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = t.ID
        FROM Items.t_Item AS t
        WHERE t.SharedID = @ItemSharedID
              AND t.WareHouseID = @WarehouseID
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;













GO
