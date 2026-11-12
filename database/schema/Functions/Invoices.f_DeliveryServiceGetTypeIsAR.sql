SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_DeliveryServiceGetTypeIsAR] ( @TypeIs TINYINT )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @v NVARCHAR(MAX);

        END;

        BEGIN --Set

            SET @v = CASE @TypeIs
                       WHEN 0 THEN N'تسليم بضاعة'
                       ELSE N'تاكسي'
                     END;

        END;

        RETURN @v;

    END;



GO
