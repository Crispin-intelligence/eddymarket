SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Customers].[s_FrameJobOrderUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_FrameJobOrder ON Customers.t_FrameJobOrder;
    DISABLE TRIGGER Customers.tr_FrameJobOrderDetail ON Customers.t_FrameJobOrderDetail;

    BEGIN --Update

      UPDATE Customers.t_FrameJobOrder
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_FrameJobOrder.ID );

      UPDATE Customers.t_FrameJobOrderDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_FrameJobOrderDetail.FrameJobOrderID );

    END;

    ENABLE TRIGGER Customers.tr_FrameJobOrder ON Customers.t_FrameJobOrder;
    ENABLE TRIGGER Customers.tr_FrameJobOrderDetail ON Customers.t_FrameJobOrderDetail;
  
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
