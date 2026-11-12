SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Invoices].[f_DeliveryServiceGetStatusIsAR] ( @StatusIs TINYINT )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @v NVARCHAR(MAX);

        END;

        BEGIN --Set

        
            SET @v = CASE @StatusIs
                       WHEN 0 THEN N'تم الاستلام'
                       WHEN 1 THEN N'معيين'
                       WHEN 2 THEN N'علي الطريق'
                       WHEN 3 THEN N'تم التوصيل'
                       WHEN 4 THEN N'مكتمل'
                       ELSE N'ألغيت'
                     END;

        END;

        RETURN @v;

    END;



GO
