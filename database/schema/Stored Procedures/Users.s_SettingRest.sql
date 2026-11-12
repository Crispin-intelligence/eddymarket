SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Users].[s_SettingRest]
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Rest
   
      UPDATE Users.t_SettingPC
        SET FontData = DEFAULT ,
            FontLabel = DEFAULT ,
            FontReportData = DEFAULT ,
            FontReportLabel = DEFAULT ,
            FontReportMainTitle = DEFAULT ,
            FontTitle = DEFAULT ,
            FontTitle14 = DEFAULT ,
            FontTitle24 = DEFAULT;

    END;

    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  0;

  END CATCH;

END;

	



GO
