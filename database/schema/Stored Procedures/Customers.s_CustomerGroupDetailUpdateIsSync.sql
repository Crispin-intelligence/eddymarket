SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerGroupDetailUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Customers.tr_CustomerGroupDetail ON Customers.t_CustomerGroupDetail;

        BEGIN --Insert

            UPDATE  Customers.t_CustomerGroupDetail
            SET     IsSync = 1
            WHERE   ID = @ID;

        END;

        ENABLE TRIGGER Customers.tr_CustomerGroupDetail ON Customers.t_CustomerGroupDetail;
		
        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;








GO
