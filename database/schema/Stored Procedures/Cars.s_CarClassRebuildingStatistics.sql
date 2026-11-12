SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarClassRebuildingStatistics]
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

      UPDATE  Cars.t_CarClass
      SET     CarsCount = ( SELECT  COUNT(*)
                            FROM    Cars.t_Car AS s
                            WHERE   ( s.ClassID = t_CarClass.ID )
                          ) ,
              AvailableCarsCount = ( SELECT COUNT(*)
                                     FROM   Cars.t_Car AS s
                                     WHERE  s.ClassID = t_CarClass.ID
                                            AND s.AvailabilityIs = 0
                                   ) ,
              UnavailableCarsCount = ( SELECT COUNT(*)
                                       FROM   Cars.t_Car AS s
                                       WHERE  s.ClassID = t_CarClass.ID
                                              AND s.AvailabilityIs = 1
                                     );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarClassMoving
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
