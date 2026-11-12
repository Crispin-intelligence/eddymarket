SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_FrameJobOrderHistoryDetailUpdateIsSync] @ID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        DISABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail

        BEGIN --Insert

            UPDATE  Customers.t_FrameJobOrderHistoryDetail
            SET     IsSync = 1
            WHERE   ID = @ID;

        END;

        ENABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;
		
        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;











GO
