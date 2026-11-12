SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_FrameJobOrderHistoryUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;
    DISABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;

    BEGIN --Update

      UPDATE Customers.t_FrameJobOrderHistory
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_FrameJobOrderHistory.ID );

      UPDATE Customers.t_FrameJobOrderHistoryDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_FrameJobOrderHistoryDetail.FrameJobOrderHistoryID );

    END;

    ENABLE TRIGGER Customers.tr_FrameJobOrderHistory ON Customers.t_FrameJobOrderHistory;
    ENABLE TRIGGER Customers.tr_FrameJobOrderHistoryDetail ON Customers.t_FrameJobOrderHistoryDetail;
  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, FrameJobOrder, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    SELECT 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT 0;

  END CATCH;

END;










GO
