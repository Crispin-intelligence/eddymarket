SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_MovingInsert3]
(
    @SectionID UNIQUEIDENTIFIER,
    @UserID UNIQUEIDENTIFIER,
    @EventIs NVARCHAR(MAX),
    @EventType TINYINT,
    @ComputerIP NVARCHAR(450),
    @Computer NVARCHAR(450),
    @ComputerAccount NVARCHAR(450),
    @Table NVARCHAR(MAX)
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION "Moving";

        DECLARE @ScriptIs NVARCHAR(MAX)
            = N'INSERT INTO ' + @Table
              + '(UserID, SectionID, EventIs , EventType , ComputerIP , Computer ,ComputerAccount) VALUES ('''
              + CAST(@UserID AS NVARCHAR(MAX)) + ''', ''' + CAST(@SectionID AS NVARCHAR(MAX)) + ''', ''' + @EventIs
              + ''', ''' + CAST(@EventType AS NVARCHAR(MAX)) + ''', ''' + @ComputerIP + ''', ''' + @Computer + ''', '''
              + @ComputerAccount + ''');';

        EXECUTE (@ScriptIs);

        COMMIT TRANSACTION "Moving";
        RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION "Moving";
        RETURN 0;
    END CATCH;
END;











GO
