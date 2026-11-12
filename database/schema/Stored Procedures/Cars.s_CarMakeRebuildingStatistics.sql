SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarMakeRebuildingStatistics]
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

      UPDATE  Cars.t_CarMake
      SET     ModelsCount = ( SELECT  COUNT(*)
                              FROM    Cars.t_CarModel AS s
                              WHERE   ( s.CarMakeID = t_CarMake.ID )
                            ) ,
              CarsCount = ( SELECT  COUNT(*)
                            FROM    Cars.t_Car AS s
                            WHERE   ( s.MakeID = t_CarMake.ID )
                          ) ,
              AvailableCarsCount = ( SELECT COUNT(*)
                                     FROM   Cars.t_Car AS s
                                     WHERE  s.MakeID = t_CarMake.ID
                                            AND s.AvailabilityIs = 0
                                   ) ,
              UnavailableCarsCount = ( SELECT COUNT(*)
                                       FROM   Cars.t_Car AS s
                                       WHERE  s.MakeID = t_CarMake.ID
                                              AND s.AvailabilityIs = 1
                                     );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarMakeMoving
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
