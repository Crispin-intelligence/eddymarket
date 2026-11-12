SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_DeliveryServiceGetTypeIsEN] ( @TypeIs TINYINT )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @v NVARCHAR(MAX);

        END;

        BEGIN --Set

            SET @v = CASE @TypeIs
                       WHEN 0 THEN N'Item Delivery'
                       ELSE N'Taxi'
                     END;

        END;

        RETURN @v;

    END;



GO
