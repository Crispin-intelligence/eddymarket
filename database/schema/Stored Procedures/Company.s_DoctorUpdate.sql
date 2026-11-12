SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_DoctorUpdate]
  @Name NVARCHAR(450) ,
  @NameAR NVARCHAR(MAX) ,
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

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Company.t_Doctor AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;
      UPDATE  Company.t_Doctor
      SET     Name = @Name ,
              NameAR = @NameAR ,
              Gender = @Gender ,
              Birthday = @Birthday ,
              ImageIs = @ImageIs ,
              ImagePath = @ImagePath ,
              IsSyncImage = IIF(@ImagePath = N'', 0, 1) ,
              Hospitals = @Hospitals ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;
		
    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE  Company.t_Doctor
      SET     AgeIs = DateTimes.f_GetAge(Birthday) ,
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

    IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
    BEGIN --Fix

      BEGIN --t_Customer

        UPDATE  Customers.t_Customer
        SET     PrescriptionDoctor = @Name
        WHERE   PrescriptionDoctorID = @ID;

      END;

      BEGIN --t_Prescription

        UPDATE  Customers.t_Prescription
        SET     Doctor = @Name
        WHERE   DoctorID = @ID;

      END;
     
      BEGIN --t_FrameJobOrder

        UPDATE  Customers.t_FrameJobOrder
        SET     Doctor = @Name
        WHERE   DoctorID = @ID;

      END;
	  
      BEGIN --t_FrameJobOrderHistory

        UPDATE  Customers.t_FrameJobOrderHistory
        SET     Doctor = @Name
        WHERE   DoctorID = @ID;

      END;

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

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;










GO
