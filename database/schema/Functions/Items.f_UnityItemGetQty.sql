SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Items].[f_UnityItemGetQty]
    (
        @ID UNIQUEIDENTIFIER
    )
RETURNS DECIMAL(18,2)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @Qty DECIMAL(18,2);

        END;

        BEGIN --Set

            SELECT @Qty = t.Qty
            FROM   Items.t_UnityItem AS t
            WHERE  t.ID = @ID;

        END;

        RETURN COALESCE(@Qty, 0);

    END;
	


GO
