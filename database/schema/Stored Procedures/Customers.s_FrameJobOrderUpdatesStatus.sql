SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_FrameJobOrderUpdatesStatus]
    @StatusIs TINYINT ,
    @DaysForProduction INT ,
    @DaysForCustomerDelivery INT ,
    @UserID UNIQUEIDENTIFIER ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @IDs Alls.tt_IDAndEvent READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update

            IF @StatusIs = 0
            BEGIN
		    
                UPDATE  Customers.t_FrameJobOrder
                SET     StatusIs = @StatusIs ,
                        DateInProcess = DATEFROMPARTS(2000, 1, 1) ,
                        DateInProcessNotification = DATEFROMPARTS(2000, 1, 1) ,
                        DateReady = DATEFROMPARTS(2000, 1, 1) ,
                        DateReadyNotification = DATEFROMPARTS(2000, 1, 1)
                WHERE   EXISTS ( SELECT TOP ( 1 )
                                        s.ID
                                 FROM   @IDs AS s
                                 WHERE  s.ID = t_FrameJobOrder.ID );

            END;
            ELSE
                IF @StatusIs = 1
                BEGIN
		    
                    UPDATE  Customers.t_FrameJobOrder
                    SET     StatusIs = @StatusIs ,
                            DateInProcess = GETDATE() ,
                            DateInProcessNotification = DATEADD(DAY, @DaysForProduction, GETDATE()) ,
                            DateReady = DATEFROMPARTS(2000, 1, 1) ,
                            DateReadyNotification = DATEFROMPARTS(2000, 1, 1)
                    WHERE   EXISTS ( SELECT TOP ( 1 )
                                            s.ID
                                     FROM   @IDs AS s
                                     WHERE  s.ID = t_FrameJobOrder.ID );

                END;
                ELSE
                    IF @StatusIs = 2
                    BEGIN
		    
                        UPDATE  Customers.t_FrameJobOrder
                        SET     StatusIs = @StatusIs ,
                                DateInProcess = DATEFROMPARTS(2000, 1, 1) ,
                                DateInProcessNotification = DATEFROMPARTS(2000, 1, 1) ,
                                DateReady = GETDATE() ,
                                DateReadyNotification = DATEADD(DAY, @DaysForCustomerDelivery, GETDATE())
                        WHERE   EXISTS ( SELECT TOP ( 1 )
                                                s.ID
                                         FROM   @IDs AS s
                                         WHERE  s.ID = t_FrameJobOrder.ID );

                    END;

        END;

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
                    SELECT  @UserID ,
                            s.ID ,
                            s.EventIs ,
                            1 ,
                            @ComputerIP ,
                            @Computer ,
                            @ComputerAccount
                    FROM    @IDs AS s;

        END;

        COMMIT TRANSACTION;

        SELECT  1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT  @Return;

    END CATCH;

END;


GO
