SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Employees].[f_EmployeeGetInWorkNow]
(
    @ID UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @InWorkNow BIT;

    END;

    BEGIN --Set info

        SELECT TOP (1)
               @InWorkNow = IIF(t.ToIs IS NULL, 1, 0)
        FROM Employees.t_Shift AS t
        WHERE t.EmployeeID = @ID
        ORDER BY t.FromIs DESC,
                 t.ToIs DESC;

    END;

    RETURN COALESCE(@InWorkNow, 0);

END;



GO
