SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_FrameJobOrderUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_FrameJobOrder ON Customers.t_FrameJobOrder;
    DISABLE TRIGGER Customers.tr_FrameJobOrderDetail ON Customers.t_FrameJobOrderDetail;

    BEGIN --Update

      UPDATE Customers.t_FrameJobOrder
        SET IsSync = 0;

      UPDATE Customers.t_FrameJobOrderDetail
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Customers.tr_FrameJobOrder ON Customers.t_FrameJobOrder;
    ENABLE TRIGGER Customers.tr_FrameJobOrderDetail ON Customers.t_FrameJobOrderDetail;
  
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
