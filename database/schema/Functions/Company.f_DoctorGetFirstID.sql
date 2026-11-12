SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [Company].[f_DoctorGetFirstID] ( )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @ID UNIQUEIDENTIFIER;

        END;

        BEGIN --Set

            SELECT TOP ( 1 )
                    @ID = ID
            FROM    Company.t_Doctor AS t
            ORDER BY t.DateCreate;

        END;

        RETURN ISNULL(@ID,'00000000-0000-0000-0000-000000000000');

    END;
	

GO
