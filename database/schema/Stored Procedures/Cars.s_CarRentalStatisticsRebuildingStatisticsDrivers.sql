SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Cars].[s_CarRentalStatisticsRebuildingStatisticsDrivers]
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

      UPDATE  Cars.t_CarRentalStatistics
      SET     
	  Drivers = (SELECT COUNT(*) FROM Cars.t_CarDriver),
	  DriversGenderMale = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.Gender = 0),
	  DriversGenderFemale = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.Gender = 1),
	  DriversGenderUnknown = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.Gender = 2),
	  DriversBloodTypeUnknown = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 0),
	  DriversBloodTypeA_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 1),
	  DriversBloodTypeA_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 2),
	  DriversBloodTypeB_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 3),
	  DriversBloodTypeB_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 4),
	  DriversBloodTypeO_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 5),
	  DriversBloodTypeO_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 6),
	  DriversBloodTypeAB_Plus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 7),
	  DriversBloodTypeAB_Minus = (SELECT COUNT(*) FROM Cars.t_CarDriver AS s WHERE s.BloodType = 8);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarRentalStatisticsMoving
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
