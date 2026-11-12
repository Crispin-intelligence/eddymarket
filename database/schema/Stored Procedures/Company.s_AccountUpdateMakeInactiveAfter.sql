SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountUpdateMakeInactiveAfter]
    @MakeInactiveAfter INT,
    @MakeInactiveAfterType TINYINT,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE Company.t_Account
            SET MakeInactiveAfter = @MakeInactiveAfter,
                MakeInactiveAfterType = @MakeInactiveAfterType
            WHERE ID = @ID;

            UPDATE Company.t_Account
            SET StatusIs = 1
            WHERE ID = @ID
                  AND StatusIs = 0
                  AND MakeInactiveAfter <> 0
                  AND CASE MakeInactiveAfterType
                          WHEN 2 THEN
                              DATEADD(DAY, MakeInactiveAfter, LastAction)
                          WHEN 1 THEN
                              DATEADD(MONTH, MakeInactiveAfter, LastAction)
                          ELSE
                              DATEADD(YEAR, MakeInactiveAfter, LastAction)
                      END < GETDATE();

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_AccountMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            VALUES
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
