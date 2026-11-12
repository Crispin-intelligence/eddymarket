SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_ItemUpdate]
  @PlaceID UNIQUEIDENTIFIER ,
  @QtyToReorder INT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @StockTakeEvery INT ,
  @StockTakeEveryType TINYINT ,
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
      FROM    Items.t_Item AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_Item
      SET     PlaceID = @PlaceID ,
              Place = Company.f_PlaceGetName(@PlaceID) ,
              QtyToReorder = @QtyToReorder ,
              DescriptionIs = @DescriptionIs ,
              StockTakeEvery = @StockTakeEvery ,
              StockTakeEveryType = @StockTakeEveryType
      WHERE   ID = @ID;

      UPDATE  Items.t_Item
      SET     SearchText = Items.f_ItemSearchTextGet(ID)
      WHERE   ID = @ID;

      UPDATE  Items.t_ItemShared
      SET     PlacesNames = Alls.f_FixXML(( SELECT  N', ' + t.Place AS [text()]
                                            FROM    Items.t_Item AS t
                                            WHERE   t.SharedID = t_ItemShared.ID
                                          FOR
                                            XML PATH('')
                                          ))
      WHERE   t_ItemShared.ID = @ItemSharedID;

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
