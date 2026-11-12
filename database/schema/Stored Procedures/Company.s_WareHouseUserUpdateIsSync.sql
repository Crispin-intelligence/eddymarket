SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_WareHouseUserUpdateIsSync]
  @IsSync BIT ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;
	
    DISABLE TRIGGER Company.tr_WareHouseUser ON Company.t_WarehouseUser;

    BEGIN --Insert

      UPDATE  Company.t_WarehouseUser
      SET     IsSync = @IsSync
      WHERE   ID = @ID;

    END;

    ENABLE TRIGGER Company.tr_WareHouseUser ON Company.t_WarehouseUser;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;




GO
