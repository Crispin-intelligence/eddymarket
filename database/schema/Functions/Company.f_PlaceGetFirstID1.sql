SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_PlaceGetFirstID1]
(
    @WarehouseID UNIQUEIDENTIFIER
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @ID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set

        SELECT TOP (1)
               @ID = ID
        FROM Company.t_Place AS t
        WHERE t.WareHouseID = @WarehouseID
        ORDER BY t.DateCreate;

    END;

    RETURN @ID;

END;














GO
