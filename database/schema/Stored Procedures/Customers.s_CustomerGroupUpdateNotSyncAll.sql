SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_CustomerGroupUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_CustomerGroup ON Customers.t_CustomerGroup;
    DISABLE TRIGGER Customers.tr_CustomerGroupDetail ON Customers.t_CustomerGroupDetail;

    BEGIN --Update

      UPDATE Customers.t_CustomerGroup
        SET IsSync = 0;

      UPDATE Customers.t_CustomerGroupDetail
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Customers.tr_CustomerGroup ON Customers.t_CustomerGroup;
    ENABLE TRIGGER Customers.tr_CustomerGroupDetail ON Customers.t_CustomerGroupDetail;

    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, CustomerGroup, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
