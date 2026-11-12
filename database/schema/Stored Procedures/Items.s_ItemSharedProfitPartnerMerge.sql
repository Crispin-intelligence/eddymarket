SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ItemSharedProfitPartnerMerge]
  @ProfitPartnerID UNIQUEIDENTIFIER ,
  @ItemSharedProfitPartner Items.tt_ItemSharedProfitPartner READONLY ,
  @UserID UNIQUEIDENTIFIER ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare
	
      DECLARE @ItemSharedProfitPartnerNewEdit AS	TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          ItemSharedID UNIQUEIDENTIFIER NOT NULL ,
          ProfitRatio DECIMAL(5, 2) NOT NULL ,
          EventIs NVARCHAR(MAX) NOT NULL
        );

      DECLARE @Return INT;

    END;

    BEGIN
    
      INSERT  INTO @ItemSharedProfitPartnerNewEdit
              ( ID ,
                ItemSharedID ,
                ProfitRatio ,
                EventIs
	          )
      SELECT  s.ID ,
              s.ItemSharedID ,
              s.ProfitRatio ,
              s.EventIs
      FROM    @ItemSharedProfitPartner AS s
      WHERE   s.ProfitRatio <> 0;

    END;

    BEGIN --Delete
	    
      DELETE  FROM Items.t_ItemSharedProfitPartner
      WHERE   ProfitPartnerID = @ProfitPartnerID
              AND EXISTS ( SELECT TOP ( 1 )
                                  s.ID
                           FROM   @ItemSharedProfitPartner AS s
                           WHERE  s.ProfitRatio = 0
                                  AND s.ItemSharedID = t_ItemSharedProfitPartner.ItemSharedID );

    END;

    BEGIN --Merge
	    
      MERGE Items.t_ItemSharedProfitPartner AS t
      USING @ItemSharedProfitPartnerNewEdit AS s
      ON s.ItemSharedID = t.ItemSharedID
        AND @ProfitPartnerID = t.ProfitPartnerID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ItemSharedID ,
                 ProfitPartnerID ,
                 ProfitPartner ,
                 ProfitRatio
               )
        VALUES ( s.ItemSharedID ,
                 @ProfitPartnerID ,
                 Items.f_ProfitPartnerGetName(@ProfitPartnerID) ,
                 s.ProfitRatio
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.ProfitRatio = s.ProfitRatio;

      UPDATE  Items.t_ItemSharedProfitPartner
      SET     SearchText = Items.f_ItemSharedProfitPartnerSearchTextGet(ID)
      WHERE   ProfitPartnerID = @ProfitPartnerID;

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
      SELECT  @UserID ,
              s.ItemSharedID ,
              s.EventIs ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @ItemSharedProfitPartner AS s;

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
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @ItemSharedProfitPartner AS s
                       WHERE  s.ItemSharedID = t_ItemShared.ID );

      UPDATE  Items.t_ItemShared
      SET     SearchText = Items.f_ItemSharedSearchTextGet(ID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @ItemSharedProfitPartner AS s
                       WHERE  s.ItemSharedID = t_ItemShared.ID );

    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @Return;

  END CATCH;

END;








GO
