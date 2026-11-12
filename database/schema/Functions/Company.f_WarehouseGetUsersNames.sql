SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_WarehouseGetUsersNames] ( @SectionID INT )
RETURNS NVARCHAR(MAX)
    BEGIN

        DECLARE @OutPut VARCHAR(MAX);

        SELECT  @OutPut = COALESCE(@OutPut + ' , ', '')
                + CAST(t1.Name AS NVARCHAR(MAX))
        FROM    Company.t_WarehouseUser AS t
                LEFT JOIN Users.t_User AS t1 ON t1.ID = t.UserID
        WHERE   t.WarehouseID = @SectionID;

        RETURN ISNULL( @OutPut , N'');

    END;

	



GO
