SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_FrameJobOrderHistoryUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;
    DISABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;

    BEGIN --Update

      UPDATE Customers.t_FrameJobOrderHistory
        SET IsSync = 0;

      UPDATE Customers.t_FrameJobOrderHistoryDetail
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;
    ENABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;
  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, FrameJobOrder, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;










GO
