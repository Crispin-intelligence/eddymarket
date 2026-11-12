SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarDriverUpdate]
  @Name NVARCHAR(450) ,
  @DrivingLicense NVARCHAR(MAX) ,
  @DrivingLicenseIssuanceDate DATE ,
  @LicenseExpirationDate DATE ,
  @DrivingLicenseStatesID UNIQUEIDENTIFIER ,
  @DrivingLicenseRegionID UNIQUEIDENTIFIER ,
  @BloodType TINYINT ,
  @Gender TINYINT ,
  @NationalityID UNIQUEIDENTIFIER ,
  @TitleID UNIQUEIDENTIFIER ,
  @ClassificationID UNIQUEIDENTIFIER ,
  @Birthday DATE ,
  @BirthdayStatesID UNIQUEIDENTIFIER ,
  @BirthdayRegionID UNIQUEIDENTIFIER ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
  @ImageIs IMAGE ,
  @ImageThumbnail IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
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

      DECLARE @NameOld NVARCHAR(450) ,
        @Gender_Old TINYINT ,
        @BloodType_Old TINYINT ,
        @Return INT = 0;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name ,
              @Gender_Old = s.Gender ,
              @BloodType_Old = s.BloodType
      FROM    Cars.t_CarDriver AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Insert
	
      UPDATE  Cars.t_CarDriver
      SET     ID = @ID ,
              Name = @Name ,
              DrivingLicense = @DrivingLicense ,
              DrivingLicenseIssuanceDate = @DrivingLicenseIssuanceDate ,
              LicenseExpirationDate = @LicenseExpirationDate ,
              DrivingLicenseStatesID = @DrivingLicenseStatesID ,
              DrivingLicenseRegionID = @DrivingLicenseRegionID ,
              BloodType = @BloodType ,
              Gender = @Gender ,
              NationalityID = @NationalityID ,
              TitleID = @TitleID ,
              ClassificationID = @ClassificationID ,
              Birthday = @Birthday ,
              BirthdayStatesID = @BirthdayStatesID ,
              BirthdayRegionID = @BirthdayRegionID ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              DescriptionIs = @DescriptionIs ,
              ImageIs = @ImageIs ,
              ImageThumbnail = @ImageThumbnail ,
              ImagePath = IIF(@ImagePath = '', 0, 1)
      WHERE   ID = @ID;

    END;

    BEGIN --Format

      EXECUTE Cars.s_CarDriverFormat @ID;

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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN 

      UPDATE  Cars.t_CarRentalDriver
      SET     CarDriver = @Name
      WHERE   CarDriverID = @ID;
   
      UPDATE  Cars.t_CarRentalHistoryDriver
      SET     CarDriver = @Name
      WHERE   CarDriverID = @ID;

    END;

    BEGIN --Update t_CarRentalStatistics
    
      UPDATE  Cars.t_CarRentalStatistics
      SET     DriversGenderMale -= IIF(@Gender_Old = 0, 1, 0) ,
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

      UPDATE  Cars.t_CarRentalStatistics
      SET     DriversGenderMale += IIF(@Gender = 0, 1, 0) ,
              DriversGenderFemale += IIF(@Gender = 1, 1, 0) ,
              DriversGenderUnknown += IIF(@Gender = 2, 1, 0) ,
              DriversBloodTypeUnknown += IIF(@BloodType = 0, 1, 0) ,
              DriversBloodTypeA_Plus += IIF(@BloodType = 1, 1, 0) ,
              DriversBloodTypeA_Minus += IIF(@BloodType = 2, 1, 0) ,
              DriversBloodTypeB_Plus += IIF(@BloodType = 3, 1, 0) ,
              DriversBloodTypeB_Minus += IIF(@BloodType = 4, 1, 0) ,
              DriversBloodTypeO_Plus += IIF(@BloodType = 5, 1, 0) ,
              DriversBloodTypeO_Minus += IIF(@BloodType = 6, 1, 0) ,
              DriversBloodTypeAB_Plus += IIF(@BloodType = 7, 1, 0) ,
              DriversBloodTypeAB_Minus += IIF(@BloodType = 8, 1, 0);

    END;

    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @Return;

  END CATCH;

END;






GO
