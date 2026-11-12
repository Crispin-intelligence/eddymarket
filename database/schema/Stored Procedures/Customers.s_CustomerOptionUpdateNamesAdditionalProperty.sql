SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerOptionUpdateNamesAdditionalProperty]
    @ARAdditionalProperty1 NVARCHAR(MAX),
    @ARAdditionalProperty2 NVARCHAR(MAX),
    @ARAdditionalProperty3 NVARCHAR(MAX),
    @ARAdditionalProperty4 NVARCHAR(MAX),
    @ARAdditionalProperty5 NVARCHAR(MAX),
    @ARAdditionalProperty6 NVARCHAR(MAX),
    @ARAdditionalProperty7 NVARCHAR(MAX),
    @ARAdditionalProperty8 NVARCHAR(MAX),
    @ARAdditionalProperty9 NVARCHAR(MAX),
    @ARAdditionalProperty10 NVARCHAR(MAX),
    @ENAdditionalProperty1 NVARCHAR(MAX),
    @ENAdditionalProperty2 NVARCHAR(MAX),
    @ENAdditionalProperty3 NVARCHAR(MAX),
    @ENAdditionalProperty4 NVARCHAR(MAX),
    @ENAdditionalProperty5 NVARCHAR(MAX),
    @ENAdditionalProperty6 NVARCHAR(MAX),
    @ENAdditionalProperty7 NVARCHAR(MAX),
    @ENAdditionalProperty8 NVARCHAR(MAX),
    @ENAdditionalProperty9 NVARCHAR(MAX),
    @ENAdditionalProperty10 NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @return INT;

        END;

        BEGIN --Update Customer shared

            SET @return = 0;

            UPDATE Customers.t_CustomerOption
            SET ARAdditionalProperty1 = @ARAdditionalProperty1,
                ARAdditionalProperty2 = @ARAdditionalProperty2,
                ARAdditionalProperty3 = @ARAdditionalProperty3,
                ARAdditionalProperty4 = @ARAdditionalProperty4,
                ARAdditionalProperty5 = @ARAdditionalProperty5,
                ARAdditionalProperty6 = @ARAdditionalProperty6,
                ARAdditionalProperty7 = @ARAdditionalProperty7,
                ARAdditionalProperty8 = @ARAdditionalProperty8,
                ARAdditionalProperty9 = @ARAdditionalProperty9,
                ARAdditionalProperty10 = @ARAdditionalProperty10,
                ENAdditionalProperty1 = @ENAdditionalProperty1,
                ENAdditionalProperty2 = @ENAdditionalProperty2,
                ENAdditionalProperty3 = @ENAdditionalProperty3,
                ENAdditionalProperty4 = @ENAdditionalProperty4,
                ENAdditionalProperty5 = @ENAdditionalProperty5,
                ENAdditionalProperty6 = @ENAdditionalProperty6,
                ENAdditionalProperty7 = @ENAdditionalProperty7,
                ENAdditionalProperty8 = @ENAdditionalProperty8,
                ENAdditionalProperty9 = @ENAdditionalProperty9,
                ENAdditionalProperty10 = @ENAdditionalProperty10;

        END;

        BEGIN --Insert event

            SET @return = -1;

            INSERT INTO Customers.t_CustomerMoving
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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

        END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @return;

    END CATCH;

END;





GO
