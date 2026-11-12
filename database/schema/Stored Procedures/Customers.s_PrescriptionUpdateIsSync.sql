SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_PrescriptionUpdateIsSync]
    @IsSync BIT ,
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

        DISABLE TRIGGER Customers.tr_Prescription ON Customers.t_Prescription;

        BEGIN --Insert

            UPDATE  Customers.t_Prescription
            SET     IsSync = @IsSync
            WHERE   ID = @ID;

        END;

        ENABLE TRIGGER Customers.tr_Prescription ON Customers.t_Prescription;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Customers.t_PrescriptionMoving
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
