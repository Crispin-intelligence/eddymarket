SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_GetLastMoving2]
    @tbl NVARCHAR(MAX) ,
    @Name NVARCHAR(MAX) OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SQL NVARCHAR(MAX);

        SET @SQL = 'SELECT TOP 1 @Name = UserIs + N''|'' + EventIs FROM '
            + @tbl + ' WHERE DateIs >= GETDATE() - 0.00003 ORDER BY ID DESC';

        EXECUTE sp_executesql @SQL, N'@Name NVARCHAR(MAX) OUTPUT',
            @Name OUTPUT;

    END; 


GO
