SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Items].[f_UnityItemGetName]
    (
        @ID UNIQUEIDENTIFIER
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @Name NVARCHAR(MAX);

        END;

        BEGIN --Set

            SELECT @Name = t1.Name
            FROM   Items.t_UnityItem AS t
                   LEFT JOIN Items.t_Unity AS t1 ON t1.ID = t.UnityID
            WHERE  t.ID = @ID;

        END;

        RETURN COALESCE(@Name, '');

    END;






GO
