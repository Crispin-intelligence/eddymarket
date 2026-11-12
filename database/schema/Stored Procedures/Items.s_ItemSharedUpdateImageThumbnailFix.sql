SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedUpdateImageThumbnailFix]
    @ImageThumbnail IMAGE ,
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @return INT;

        END;

        BEGIN --Update

            SET @return = 0;

            UPDATE  Items.t_ItemShared
            SET     ImageThumbnail = @ImageThumbnail ,
                    ImageThumbnailFixed = 1
            WHERE   ID = @ID
                    AND ImageThumbnailFixed = 0;

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT  INTO Items.t_ItemSharedMoving
                    ( UserID ,
                      SectionID ,
                      EventIs ,
                      EventType ,
                      ComputerIP ,
                      Computer ,
                      ComputerAccount
                    )
            VALUES  ( @UserID ,
                      @ID ,
                      @Event ,
                      1 ,
                      @ComputerIP ,
                      @Computer ,
                      @ComputerAccount
                    );

        END;

        COMMIT TRANSACTION;

        RETURN  1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN  @return;

    END CATCH;

END;







GO
