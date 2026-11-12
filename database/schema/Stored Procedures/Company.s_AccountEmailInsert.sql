SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountEmailInsert]
    @Name NVARCHAR(450) ,
    @Password NVARCHAR(MAX) ,
    @Note NVARCHAR(450) ,
    @UserID INT ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX)
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
		
            BEGIN --Declare

                DECLARE @IDs TABLE ( ID SMALLINT );

                DECLARE @IDn NVARCHAR(MAX) ,
                    @ID SMALLINT ,
                    @return INT;

            END;

            --BEGIN --Insert

            --    INSERT  INTO Company.t_AccountEmail
            --            ( Name, [Password], Note )
            --    OUTPUT  Inserted.ID
            --            INTO @IDs ( ID )
            --    VALUES  ( @Name, @Password, @Note );


            --    SET @ID = ( SELECT TOP 1
            --                        ID
            --                FROM    @IDs
            --              );

            --END;
            
            --BEGIN --Insert event

            --    SET @IDn = CAST(@ID AS NVARCHAR(MAX));

            --    EXECUTE @return = Alls.s_MovingInsert3 @IDn, @UserID, @Event,
            --        0, @ComputerIP, @Computer, @ComputerAccount,
            --        'Company.t_AccountEmailMoving';
            --    IF @return = -1
            --        BEGIN 
            --            ROLLBACK;
            --            RETURN -1;
            --        END;
            --END;
					
            COMMIT TRAN;
            RETURN 1;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            RETURN 0;
        END CATCH;
    END;










GO
