SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_CustomerGroupUpdateNotSync] @IDs Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_CustomerGroup ON Customers.t_CustomerGroup;
    DISABLE TRIGGER Customers.tr_CustomerGroupDetail ON Customers.t_CustomerGroupDetail;

    BEGIN --Update

      UPDATE Customers.t_CustomerGroup
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_CustomerGroup.ID );
         
      UPDATE Customers.t_CustomerGroupDetail
        SET IsSync = 0
        WHERE EXISTS ( SELECT TOP ( 1 ) s.ID
                        FROM @IDs AS s
                        WHERE s.ID = t_CustomerGroupDetail.CustomerGroupID );

    END;

    ENABLE TRIGGER Customers.tr_CustomerGroup ON Customers.t_CustomerGroup;
    ENABLE TRIGGER Customers.tr_CustomerGroupDetail ON Customers.t_CustomerGroupDetail;
		   
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, CustomerGroup, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
