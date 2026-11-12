SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_FrameJobOrderHistoryUpdateIsSync]
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

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;

        BEGIN --Insert

            UPDATE  Customers.t_FrameJobOrderHistory
            SET     IsSync = 1
            WHERE   ID = @ID;

        END;

        ENABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Customers.t_FrameJobOrderMoving
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
                      7 ,
                      @ComputerIP ,
                      @Computer ,
                      @ComputerAccount
                    );

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;










GO
