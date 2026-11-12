SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Users].[s_SettingPCInsert]
  @Computer NVARCHAR(450)
AS
BEGIN
  BEGIN TRY

    SET ANSI_WARNINGS OFF;

    BEGIN TRANSACTION;

    BEGIN --DECLARE
	    
      DECLARE @ID UNIQUEIDENTIFIER = NEWID();

    END;

    BEGIN --Insert

      INSERT  INTO Users.t_SettingPC
              ( ID, Computer )
      VALUES  ( @ID, @Computer );
   
      INSERT  INTO Users.t_SettingPC2
              ( ID, Computer )
      VALUES  ( @ID, @Computer );

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
