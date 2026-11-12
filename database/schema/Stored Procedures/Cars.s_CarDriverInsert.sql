SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarDriverInsert]
  @Name NVARCHAR(450) ,
  @DrivingLicense NVARCHAR(MAX) ,
  @DrivingLicenseIssuanceDate DATE ,
  @LicenseExpirationDate DATE ,
  @DrivingLicenseStatesID UNIQUEIDENTIFIER ,
  @DrivingLicenseRegionID UNIQUEIDENTIFIER ,
  @BloodType TINYINT ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
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

      DECLARE @SectionID INT = 184 ,
        @Return INT = 0;

    END;

    BEGIN --Insert
	
      INSERT  INTO Cars.t_CarDriver
              ( ID ,
                Name ,
                DrivingLicense ,
                DrivingLicenseIssuanceDate ,
                LicenseExpirationDate ,
                DrivingLicenseStatesID ,
                DrivingLicenseRegionID ,
                BloodType ,
                Gender ,
                NationalityID ,
                TitleID ,
                ClassificationID ,
                Birthday ,
                BirthdayStatesID ,
                BirthdayRegionID ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                DescriptionIs ,
                ImageIs ,
                ImageThumbnail ,
                ImagePath
              )
      VALUES  ( @ID ,
                @Name ,
                @DrivingLicense ,
                @DrivingLicenseIssuanceDate ,
                @LicenseExpirationDate ,
                @DrivingLicenseStatesID ,
                @DrivingLicenseRegionID ,
                @BloodType ,
                @Gender ,
                @NationalityID ,
                @TitleID ,
                @ClassificationID ,
                @Birthday ,
                @BirthdayStatesID ,
                @BirthdayRegionID ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @DescriptionIs ,
                @ImageIs ,
                @ImageThumbnail ,
                IIF(@ImagePath = '', 0, 1)
              );

    END;

    BEGIN --Insert phones

      SET @Return = -2;

      INSERT  INTO Company.t_BookPhone
              ( OwnerID ,
                NumberIs ,
                SectionID ,
                NumberType ,
                LanguageCodeID ,
                ExtensionIs
              )
      SELECT DISTINCT
              @ID ,
              t.NumberIs ,
              @SectionID ,
              t.TypeIs ,
              t.LanguageCodeID ,
              t.ExtensionIs
      FROM    @Phones AS t;

    END;

    BEGIN --Insert social media

      SET @Return = -4;

      INSERT  INTO Company.t_SocialMedia
              ( OwnerID ,
                AccountIs ,
                SectionID ,
                TypeID
              )
      SELECT  @ID ,
              t.AccountIs ,
              @SectionID ,
              t.TypeID
      FROM    @SocialMedia AS t;

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

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     Drivers += 1 ,
              DriversGenderMale += IIF(@Gender = 0, 1, 0) ,
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

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @Return;

  END CATCH;

END;






GO
