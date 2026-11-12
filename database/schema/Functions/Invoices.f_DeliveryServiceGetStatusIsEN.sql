SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Invoices].[f_DeliveryServiceGetStatusIsEN] ( @StatusIs TINYINT )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @v NVARCHAR(MAX);

        END;

        BEGIN --Set

        
            SET @v = CASE @StatusIs
                       WHEN 0 THEN N'Received'
                       WHEN 1 THEN N'Assigned'
                       WHEN 2 THEN N'On the Way'
                       WHEN 3 THEN N'Delivered'
                       WHEN 4 THEN N'Completed'
                       ELSE N'Canceled'
                     END;

        END;

        RETURN @v;

    END;



GO
