SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_FrameJobOrderDetailUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Customers.tr_FrameJobOrderDetail ON Customers.t_FrameJobOrderDetail;

        BEGIN --Insert

            UPDATE  Customers.t_FrameJobOrderDetail
            SET     IsSync = 1
            WHERE   ID = @ID;

        END;

        ENABLE TRIGGER Customers.tr_FrameJobOrderDetail ON Customers.t_FrameJobOrderDetail;
		
        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;










GO
