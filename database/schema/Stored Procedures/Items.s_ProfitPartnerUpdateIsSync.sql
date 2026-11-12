SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Items].[s_ProfitPartnerUpdateIsSync]
  @IsSync BIT ,
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

    DISABLE TRIGGER Items.tr_ProfitPartner ON Items.t_ProfitPartner;

    BEGIN --Insert

      UPDATE  Items.t_ProfitPartner
      SET     IsSync = @IsSync
      WHERE   ID = @ID;

    END;

    ENABLE TRIGGER Items.tr_ProfitPartner ON Items.t_ProfitPartner;

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
                7 ,
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
