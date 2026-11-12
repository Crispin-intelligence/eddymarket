SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Options].[f_ReportHeaderFooterGetFirstID] ( )
RETURNS NVARCHAR(MAX)
AS
    BEGIN

        BEGIN --DECLARE

            DECLARE @ID UNIQUEIDENTIFIER;

        END;

        BEGIN --Set

            SELECT TOP ( 1 )
                    @ID = ID
            FROM    Options.t_ReportHeaderFooter AS t
            ORDER BY t.DateCreate;

        END;

        RETURN @ID;

    END;












GO
