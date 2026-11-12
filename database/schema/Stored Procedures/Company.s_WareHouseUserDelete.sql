SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Company].[s_WareHouseUserDelete]
  @WarehouseID UNIQUEIDENTIFIER ,
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

    BEGIN --DECLARE

      DECLARE @Return INT;

    END;

    BEGIN --Insert warehouse

      SET @Return = 0;

      DELETE  FROM Company.t_WarehouseUser
      WHERE   ID = @ID;

    END;

    BEGIN --Rebuilding statistics

      UPDATE  Company.t_WareHouse
      SET     UserC = ( SELECT  COUNT(*)
                        FROM    Company.t_WarehouseUser AS s
                        WHERE   s.WarehouseID = t_WareHouse.ID
                      ) ,
              UsersNames = Alls.f_FixXML(( SELECT ', ' + t1.Name AS [text()]
                                           FROM   Company.t_WarehouseUser AS t
                                           LEFT JOIN Users.t_User AS t1 ON t1.ID = t.UserID
                                           WHERE  t.WarehouseID = t_WareHouse.ID
                                         FOR
                                           XML PATH('')
                                         ))
      WHERE   ID = @WarehouseID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_WarehouseMoving
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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO
