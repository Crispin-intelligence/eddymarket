SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_MovingInserts]
    (
      @SectionID Alls.td_IDBigint READONLY ,
      @UserID INT ,
      @EventIs NVARCHAR(MAX) ,
      @EventType TINYINT ,
      @ComputerIP NVARCHAR(450) ,
      @Computer NVARCHAR(450) ,
      @ComputerAccount NVARCHAR(450) ,
      @Table NVARCHAR(MAX)
    )
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
			
            DECLARE @ID NVARCHAR(MAX);

            DECLARE Detail CURSOR FORWARD_ONLY
            FOR
                SELECT  CAST(t.ID AS NVARCHAR(MAX))
                FROM    @SectionID AS t; 

            OPEN Detail;

            FETCH NEXT FROM Detail INTO @ID;

            WHILE @@FETCH_STATUS = 0
                BEGIN
            
                    EXECUTE Alls.s_MovingInsert3 @ID, @UserID, @EventIs,
                        @EventType, @ComputerIP, @Computer, @ComputerAccount,
                        @Table;

                    FETCH NEXT FROM Detail INTO @ID;
                END;

            CLOSE Detail;
            DEALLOCATE Detail;

            COMMIT;
            RETURN 1;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            RETURN 0;
        END CATCH;
    END;




GO
