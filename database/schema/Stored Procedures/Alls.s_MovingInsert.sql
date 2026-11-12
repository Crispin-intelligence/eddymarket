SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_MovingInsert]
    (
      @SectionID BIGINT ,
      @UserID INT ,
      @Event NVARCHAR(MAX) ,
      @Table NVARCHAR(MAX)
    )
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION "Moving";
			
            DECLARE @ScriptIs NVARCHAR(MAX) = N'INSERT INTO ' + @Table
                + '(MovingUserID, MovingSectionID, MovingEvent) VALUES ('''
                + CAST(@UserID AS NVARCHAR(MAX)) + ''', '''
                + CAST(@SectionID AS NVARCHAR(MAX)) + ''', ''' + @Event + ''');';

            EXECUTE(@ScriptIs);
			
            COMMIT TRANSACTION "Moving";
            RETURN 1;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION "Moving";
            RETURN 0;
        END CATCH;
    END;







GO
