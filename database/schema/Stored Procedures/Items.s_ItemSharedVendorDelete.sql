SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemSharedVendorDelete]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT ,
        @ItemSharedID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @ItemSharedID = s.SharedID
      FROM    Items.t_ItemSharedVendor AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Items.t_ItemSharedVendor
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Items.t_ItemShared
      SET     VendorC -= 1 ,
              VendorNames = Alls.f_FixXML(( SELECT  N', ' + t.Vendor AS [text()]
                                            FROM    Items.t_ItemSharedVendor AS t
                                            WHERE   t.SharedID = t_ItemShared.ID
                                          FOR
                                            XML PATH('')
                                          ))
      WHERE   ID = @ItemSharedID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ItemSharedMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ItemSharedID ,
                @Event ,
                @EventType ,
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
