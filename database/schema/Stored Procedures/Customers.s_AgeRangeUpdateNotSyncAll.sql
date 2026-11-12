SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Customers].[s_AgeRangeUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Customers.tr_AgeRange ON Customers.t_AgeRange;

    BEGIN --Update

      UPDATE Customers.t_AgeRange
        SET IsSync = 0;

    END;
		   
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, AgeRange, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    ENABLE TRIGGER Customers.tr_AgeRange ON Customers.t_AgeRange;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;






GO
