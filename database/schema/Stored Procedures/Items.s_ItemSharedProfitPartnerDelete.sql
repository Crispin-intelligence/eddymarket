SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedProfitPartnerDelete]
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
        @ProfitPartnerID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @ItemSharedID = s.ItemSharedID ,
              @ProfitPartnerID = s.ProfitPartnerID
      FROM    Items.t_ItemSharedProfitPartner AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Insert

      DELETE  FROM Items.t_ItemSharedProfitPartner
      WHERE   ID = @ID;
	  
    END;

    BEGIN --Fix t_Car

      UPDATE  Items.t_ProfitPartner
      SET     ItemsCount = ( SELECT COUNT(s.ID)
                             FROM   Items.t_ItemSharedProfitPartner AS s
                             WHERE  s.ProfitPartnerID = t_ProfitPartner.ID
                           )
      WHERE   ID = @ProfitPartnerID;

      UPDATE  Items.t_ItemShared
      SET     ProfitPartnersCount = ( SELECT  COUNT(s.ID)
                                      FROM    Items.t_ItemSharedProfitPartner AS s
                                      WHERE   s.ItemSharedID = t_ItemShared.ID
                                    ) ,
              ProfitPartners = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + s1.Name AS [text()]
                                               FROM   Items.t_ItemSharedProfitPartner AS s
                                               INNER JOIN Items.t_ProfitPartner AS s1 ON s1.ID = s.ProfitPartnerID
                                               WHERE  s.ItemSharedID = t_ItemShared.ID
                                             FOR
                                               XML PATH('')
                                             ))
      WHERE   ID = @ItemSharedID;

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
