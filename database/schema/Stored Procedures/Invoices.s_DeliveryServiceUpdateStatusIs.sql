SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_DeliveryServiceUpdateStatusIs]
    @StatusIs TINYINT ,
    @UserID UNIQUEIDENTIFIER ,
    @EventInsert NVARCHAR(MAX) ,
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

                UPDATE  Invoices.t_DeliveryService
                SET     StatusIs = @StatusIs ,
                        StatusIsAR = Invoices.f_DeliveryServiceGetStatusIsAR(@StatusIs) ,
                        StatusIsEN = Invoices.f_DeliveryServiceGetStatusIsEN(@StatusIs)
                WHERE   ID = @ID;

            END;

            BEGIN --Insert event

                SET @return = -1;

                INSERT  INTO Invoices.t_DeliveryServiceMoving
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
