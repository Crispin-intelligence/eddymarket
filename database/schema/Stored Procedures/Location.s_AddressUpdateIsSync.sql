SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Location].[s_AddressUpdateIsSync]
  @IsSync BIT ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Location.tr_Address ON Location.t_Address;

    BEGIN --Insert

      UPDATE  Location.t_Address
      SET     IsSync = @IsSync
      WHERE   ID = @ID;

    END;

    ENABLE TRIGGER Location.tr_Address ON Location.t_Address;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;

GO
