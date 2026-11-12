SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountUpdateNotSyncAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    DISABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    DISABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    DISABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;
    DISABLE TRIGGER Company.tr_Account ON Company.t_Account;

    BEGIN --Update

      UPDATE  Company.t_AccountLevel1
      SET     IsSync = 0;

      UPDATE  Company.t_AccountLevel2
      SET     IsSync = 0;

      UPDATE  Company.t_AccountLevel3
      SET     IsSync = 0;

      UPDATE  Company.t_Account
      SET     IsSync = 0;

    END;

    ENABLE TRIGGER Company.tr_AccountLevel1 ON Company.t_AccountLevel1;
    ENABLE TRIGGER Company.tr_AccountLevel2 ON Company.t_AccountLevel2;
    ENABLE TRIGGER Company.tr_AccountLevel3 ON Company.t_AccountLevel3;
    ENABLE TRIGGER Company.tr_Account ON Company.t_Account;

    COMMIT TRANSACTION;
		   
    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;


GO
