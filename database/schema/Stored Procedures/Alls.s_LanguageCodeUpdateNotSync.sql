SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Alls].[s_LanguageCodeUpdateNotSync]
  @IDAndEvent Alls.tt_Guid READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Alls.tr_LanguageCode ON Alls.t_LanguageCode;

    BEGIN --Update

      UPDATE  Alls.t_LanguageCode
      SET     IsSync = 0
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_LanguageCode.ID );

    END;

    ENABLE TRIGGER Alls.tr_LanguageCode ON Alls.t_LanguageCode;
		  
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, LanguageCode, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaAll, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  0;

  END CATCH;

END;









GO
