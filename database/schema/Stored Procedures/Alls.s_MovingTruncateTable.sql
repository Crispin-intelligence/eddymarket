SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_MovingTruncateTable]
    (
      @UserID INT ,
      @EventIs NVARCHAR(MAX) ,
      @ComputerIP NVARCHAR(MAX) ,
      @Computer NVARCHAR(MAX) ,
      @ComputerAccount NVARCHAR(MAX) ,
      @Table NVARCHAR(MAX) ,
      @IsGuid bit
    )
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
		
            EXECUTE(N'TRUNCATE TABLE ' + @Table);

            DECLARE @ScriptIs NVARCHAR(MAX);

            IF @IsGuid = 0
                BEGIN

                    SET @ScriptIs = N'INSERT INTO ' + @Table
                        + '(UserID, SectionID, EventIs , EventType , ComputerIP , Computer ,ComputerAccount) VALUES ('''
                        + CAST(@UserID AS NVARCHAR(MAX)) + ''', 0 , '''
                        + @EventIs + ''', 4 , ''' + @ComputerIP + ''', '''
                        + @Computer + ''', ''' + @ComputerAccount + ''');';

                    EXECUTE(@ScriptIs);

                END;

            ELSE
                BEGIN

                    SET @ScriptIs = N'INSERT INTO ' + @Table
                        + '(UserID, SectionID, EventIs , EventType , ComputerIP , Computer ,ComputerAccount) VALUES ('''
                        + CAST(@UserID AS NVARCHAR(MAX)) + ''', '''
                        + CAST(NEWID() AS NVARCHAR(MAX)) + ''', ''' + @EventIs
                        + ''', 4 , ''' + @ComputerIP + ''', ''' + @Computer
                        + ''', ''' + @ComputerAccount + ''');';

                    EXECUTE(@ScriptIs);

                END;
            
            COMMIT TRANSACTION;

            RETURN 1;

        END TRY

        BEGIN CATCH

            ROLLBACK;

            RETURN 0;

        END CATCH;

    END;









GO
