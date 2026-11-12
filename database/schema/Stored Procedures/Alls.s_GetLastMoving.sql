SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_GetLastMoving]
    @tbl NVARCHAR(MAX) ,
    @Name NVARCHAR(MAX) OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SQL NVARCHAR(MAX);

        SET @SQL = 'SELECT TOP 1 @Name = UserName + N''|'' + MovingEvent FROM '
            + @tbl
            + ' WHERE MovingDate >= GETDATE() - 0.00002 ORDER BY MovingID DESC';

        EXECUTE sp_executesql @SQL, N'@Name NVARCHAR(MAX) OUTPUT',
            @Name OUTPUT;

    END; 


GO
