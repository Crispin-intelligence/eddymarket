SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerGroupInsertApp]
    @ID UNIQUEIDENTIFIER ,
    @Name NVARCHAR(MAX) ,
    @DescriptionIs NVARCHAR(MAX) ,
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT  INTO Customers.t_CustomerGroup
                    ( ID, Name, DescriptionIs )
            VALUES  ( @ID, @Name, @DescriptionIs );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT  INTO Customers.t_CustomerGroupMoving
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
                      9 ,
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
