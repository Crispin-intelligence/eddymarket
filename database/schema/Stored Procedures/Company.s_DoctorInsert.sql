SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_DoctorInsert]
  @Name NVARCHAR(450) ,
  @NameAR NVARCHAR(MAX) ,
  @Phones Company.td_BookPhone READONLY ,
  @SocialMedia Company.dt_SocialMedia READONLY ,
  @Gender TINYINT ,
  @Birthday DATE ,
  @ImageIs IMAGE ,
  @ImagePath NVARCHAR(MAX) ,
  @Hospitals NVARCHAR(MAX) ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @DescriptionIs NVARCHAR(MAX) ,
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

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Company.t_Doctor
              ( ID ,
                Name ,
                NameAR ,
                Gender ,
                Birthday ,
                ImageIs ,
                ImagePath ,
                IsSyncImage ,
                Hospitals ,
                StatesID ,
                RegionID ,
                StreetID ,
                BuildingID ,
                FloorID ,
                PostalCodeID ,
                AddressNote ,
                DescriptionIs
              )
      VALUES  ( @ID ,
                @Name ,
                @NameAR ,
                @Gender ,
                @Birthday ,
                @ImageIs ,
                @ImagePath ,
                IIF(@ImagePath = N'', 0, 1) ,
                @Hospitals ,
                @StatesID ,
                @RegionID ,
                @StreetID ,
                @BuildingID ,
                @FloorID ,
                @PostalCodeID ,
                @AddressNote ,
                @DescriptionIs
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
              163 ,
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
              163 ,
              t.TypeID
      FROM    @SocialMedia AS t;

    END;

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE  Company.t_Doctor
      SET     Phones = Alls.f_FixXML(( SELECT N', ' + t.NumberIs + CASE t.ExtensionIs
                                                                     WHEN N'' THEN N''
                                                                     ELSE N': ' + t.ExtensionIs
                                                                   END AS [text()]
                                       FROM   Company.t_BookPhone AS t
                                       WHERE  t.OwnerID = t_Doctor.ID
                                              AND t.SectionID = 163
                                     FOR
                                       XML PATH('')
                                     )) ,
              PhonesC = ( SELECT  COUNT(t.ID)
                          FROM    Company.t_BookPhone AS t
                          WHERE   t.OwnerID = t_Doctor.ID
                                  AND t.SectionID = 163
                        ) ,
              SocialMedia = Alls.f_FixXML(( SELECT  N', ' + t.AccountIs AS [text()]
                                            FROM    Company.t_SocialMedia AS t
                                            WHERE   t.OwnerID = t_Doctor.ID
                                                    AND t.SectionID = 163
                                          FOR
                                            XML PATH('')
                                          )) ,
              SocialMediaC = ( SELECT COUNT(t.ID)
                               FROM   Company.t_SocialMedia AS t
                               WHERE  t.OwnerID = t_Doctor.ID
                                      AND t.SectionID = 163
                             ) ,
              AgeIs = DateTimes.f_GetAge(Birthday) ,
              StatesIs = Location.f_StatesGetName(StatesID) ,
              RegionIs = Location.f_RegionGetName(RegionID) ,
              Street = Location.f_StreetGetName(StreetID) ,
              Building = Location.f_BuildingGetName(BuildingID) ,
              FloorIs = Location.f_FloorGetName(FloorID) ,
              PostalCode = Location.f_PostalCodeGetName(PostalCodeID)
      WHERE   t_Doctor.ID = @ID;

      UPDATE  Company.t_Doctor
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
      WHERE   ID = @ID;

      UPDATE  Company.t_Doctor
      SET     SearchText = Company.f_DoctorSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_DoctorMoving
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

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @Return;

  END CATCH;

END;

GO
