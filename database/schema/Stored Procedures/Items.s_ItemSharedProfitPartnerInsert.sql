SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedProfitPartnerInsert]
  @ItemSharedID UNIQUEIDENTIFIER ,
  @ProfitPartnerID UNIQUEIDENTIFIER ,
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
	
      DECLARE @Return INT;

    END;
	
    BEGIN --Insert

      INSERT  INTO Items.t_ItemSharedProfitPartner
              ( ID ,
                ItemSharedID ,
                ProfitPartnerID ,
                ProfitPartner ,
                ProfitRatio 
	          )
      VALUES  ( @ID ,
                @ItemSharedID ,
                @ProfitPartnerID ,
                Items.f_ProfitPartnerGetName(@ProfitPartnerID) ,
                @ProfitRatio
              );

      UPDATE  Items.t_ItemSharedProfitPartner
      SET     SearchText = Items.f_ItemSharedProfitPartnerSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Fix t_ProfitPartner, t_ItemShared

      UPDATE  Items.t_ProfitPartner
      SET     ItemsCount = ( SELECT COUNT(s.ID)
                             FROM   Items.t_ItemSharedProfitPartner AS s
                             WHERE  s.ProfitPartnerID = t_ProfitPartner.ID
                           )
      WHERE   ID = @ProfitPartnerID;

      UPDATE  Items.t_ProfitPartner
      SET     SearchText = Items.f_ProfitPartnerSearchTextGet(ID)
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

      UPDATE  Items.t_ItemShared
      SET     SearchText = Items.f_ItemSharedSearchTextGet(ID)
      WHERE   ID = @ItemSharedID;

    END;

    BEGIN --Insert t_ItemSharedMoving

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
