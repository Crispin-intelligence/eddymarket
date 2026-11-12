SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_DeliveryServiceGetDeliveryChargeStatusAR]
    (
      @DeliveryChargeStatus TINYINT
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @v NVARCHAR(MAX);

        END;

        BEGIN --Set

            SET @v = CASE @DeliveryChargeStatus
                       WHEN 0 THEN N'غير مدفوع'
                       ELSE N'مدفوع'
                     END;

        END;

        RETURN @v;

    END;



GO
