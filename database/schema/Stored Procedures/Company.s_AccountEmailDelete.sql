SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountEmailDelete]
    @UserID INT ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @ID SMALLINT
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
		
            BEGIN --Declare

                DECLARE @IDn NVARCHAR(MAX) ,
                    @return INT;

            END;

            --BEGIN --Delete

            --    DELETE  FROM Company.t_AccountEmail
            --    WHERE   ID = @ID;

            --END;

            --BEGIN --Insert event

            --    SET @IDn = CAST(@ID AS NVARCHAR(MAX));

            --    EXECUTE @return = Alls.s_MovingInsert3 @IDn, @UserID, @Event,
            --        2, @ComputerIP, @Computer, @ComputerAccount,
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
