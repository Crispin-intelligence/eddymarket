SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Company].[f_AccountCustomerGetFirstID] ( )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @ID UNIQUEIDENTIFIER;

        END;

        BEGIN --Set

            SELECT TOP ( 1 )
                    @ID = ID
            FROM    Company.t_Account AS t
            WHERE   t.NumberIs BETWEEN 4110100000 AND 4110199999
            ORDER BY t.DateCreate;

        END;

        RETURN @ID;

    END;














GO
