SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_SocialMediaTypeRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Company.t_SocialMediaType
      SET     SocialMediaC = COALESCE(( SELECT  COUNT_BIG(*)
                                        FROM    Company.t_SocialMedia AS t
                                        WHERE   t.TypeID = t_SocialMediaType.ID
                                      ), 0);

      UPDATE  Company.t_SocialMediaType
      SET     SearchText = Company.f_SocialMediaTypeSearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_SocialMediaTypeMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
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
