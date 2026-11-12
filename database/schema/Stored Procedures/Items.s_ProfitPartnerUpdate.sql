SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Items].[s_ProfitPartnerUpdate]
  @Name NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
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
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Items.t_ProfitPartner AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Items.t_ProfitPartner
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs ,
              IsEnabled = 1
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_ProfitPartnerMoving
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
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      UPDATE  Items.t_ItemSharedProfitPartner
      SET     ProfitPartner = @Name
      WHERE   ProfitPartnerID = @ID;

      UPDATE  Invoices.t_SoldProfitPartner
      SET     ProfitPartner = @Name
      WHERE   ProfitPartnerID = @ID;
    
      UPDATE  Invoices.t_SoldDetailProfitPartner
      SET     ProfitPartner = @Name
      WHERE   ProfitPartnerID = @ID;

      UPDATE  Items.t_ItemShared
      SET     ProfitPartners = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + s.ProfitPartner AS [text()]
                                               FROM   Items.t_ItemSharedProfitPartner AS s
                                               WHERE  s.ItemSharedID = t_ItemShared.ID
                                             FOR
                                               XML PATH('')
                                             ))
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   Items.t_ItemSharedProfitPartner AS s
                       WHERE  s.ProfitPartnerID = @ID
                              AND s.ItemSharedID = t_ItemShared.ID );

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
