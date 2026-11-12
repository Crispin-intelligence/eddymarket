SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_PlaceGetFirstName1]
(
    @WarehouseID UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @Name NVARCHAR(MAX);

    END;

    BEGIN --Set

        SELECT TOP (1)
               @Name = t.Name
        FROM Company.t_Place AS t
        WHERE t.WareHouseID = @WarehouseID
        ORDER BY t.DateCreate;

    END;

    RETURN COALESCE(@Name, '');

END;














GO
