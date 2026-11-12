SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Invoices].[f_DeliveryServiceGetDeliveryChargeStatusEN]
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
                       WHEN 0 THEN N'Unpaid'
                       ELSE N'Paid'
                     END;

        END;

        RETURN @v;

    END;



GO
