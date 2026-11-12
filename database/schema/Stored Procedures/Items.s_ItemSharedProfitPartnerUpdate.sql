SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Items].[s_ItemSharedProfitPartnerUpdate]
  @ProfitRatio DECIMAL(5, 2) ,
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
	
      DECLARE @ItemSharedID UNIQUEIDENTIFIER ,
        @Return INT;

    END;
	
    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @ItemSharedID = s.ItemSharedID
      FROM    Items.t_ItemSharedProfitPartner AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Insert

      UPDATE  Items.t_ItemSharedProfitPartner
      SET     ProfitRatio = @ProfitRatio
      WHERE   ID = @ID;

      UPDATE  Items.t_ItemSharedProfitPartner
      SET     SearchText = Items.f_ItemSharedProfitPartnerSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert t_CarMoving

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

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @Return;

  END CATCH;

END;







GO
