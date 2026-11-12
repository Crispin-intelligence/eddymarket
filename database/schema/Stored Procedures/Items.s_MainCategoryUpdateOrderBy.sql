SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Items].[s_MainCategoryUpdateOrderBy]
  @UserID UNIQUEIDENTIFIER ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @IDAndEvent Alls.tt_IDOrderByEvent READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Update 

      SET @Return = 0;

      MERGE Items.t_MainCategory AS t
      USING @IDAndEvent AS s
      ON t.ID = s.ID
      WHEN MATCHED THEN
        UPDATE SET
               t.OrderBy = s.OrderBy;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Items.t_MainCategoryMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s.ID ,
              s.EventIs ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @IDAndEvent AS s;

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
