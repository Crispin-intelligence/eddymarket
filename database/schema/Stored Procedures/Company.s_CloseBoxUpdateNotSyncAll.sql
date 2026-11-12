SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_CloseBoxUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Company.tr_CloseBox ON Company.t_CloseBox;
    DISABLE TRIGGER Company.tr_CloseBoxDetail ON Company.t_CloseBoxDetail;

    BEGIN --Update

      UPDATE Company.t_CloseBox
        SET IsSync = 0;

      UPDATE Company.t_CloseBoxDetail
        SET IsSync = 0;

    END;

    ENABLE TRIGGER Company.tr_CloseBox ON Company.t_CloseBox;
    ENABLE TRIGGER Company.tr_CloseBoxDetail ON Company.t_CloseBoxDetail;
		  
    BEGIN --Live

      UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, CloseBox, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
