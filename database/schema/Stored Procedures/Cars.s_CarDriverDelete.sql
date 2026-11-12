SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarDriverDelete]
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

      DECLARE @Gender_Old TINYINT ,
        @BloodType_Old TINYINT ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @Gender_Old = s.Gender ,
              @BloodType_Old = s.BloodType
      FROM    Cars.t_CarDriver AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Cars.t_CarDriver
      WHERE   ID = @ID;

    END;
   
    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarDriverMoving
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

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Drivers -= 1 ,
              DriversGenderMale -= IIF(@Gender_Old = 0, 1, 0) ,
              DriversGenderFemale -= IIF(@Gender_Old = 1, 1, 0) ,
              DriversGenderUnknown -= IIF(@Gender_Old = 2, 1, 0) ,
              DriversBloodTypeUnknown -= IIF(@BloodType_Old = 0, 1, 0) ,
              DriversBloodTypeA_Plus -= IIF(@BloodType_Old = 1, 1, 0) ,
              DriversBloodTypeA_Minus -= IIF(@BloodType_Old = 2, 1, 0) ,
              DriversBloodTypeB_Plus -= IIF(@BloodType_Old = 3, 1, 0) ,
              DriversBloodTypeB_Minus -= IIF(@BloodType_Old = 4, 1, 0) ,
              DriversBloodTypeO_Plus -= IIF(@BloodType_Old = 5, 1, 0) ,
              DriversBloodTypeO_Minus -= IIF(@BloodType_Old = 6, 1, 0) ,
              DriversBloodTypeAB_Plus -= IIF(@BloodType_Old = 7, 1, 0) ,
              DriversBloodTypeAB_Minus -= IIF(@BloodType_Old = 8, 1, 0);

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
