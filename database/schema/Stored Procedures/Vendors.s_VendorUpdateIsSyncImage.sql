SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Vendors].[s_VendorUpdateIsSyncImage]
  @ImagePath NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Vendors.tr_Vendor ON Vendors.t_Vendor;

    BEGIN --Insert

      UPDATE  Vendors.t_Vendor
      SET     IsSyncImage = IIF(@ImagePath = '', 0, 1) ,
              ImagePath = @ImagePath
      WHERE   ID = @ID;

    END;

    ENABLE TRIGGER Vendors.tr_Vendor ON Vendors.t_Vendor;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Vendors.t_VendorMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                8 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;










GO
