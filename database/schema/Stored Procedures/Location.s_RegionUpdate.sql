SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_RegionUpdate]
  @Name NVARCHAR(MAX) ,
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
      FROM    Location.t_Region AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Location.t_Region
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

      UPDATE  Location.t_Region
      SET     SearchText = Location.f_RegionSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Location.t_RegionMoving
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
    BEGIN --Fix

      BEGIN --Fix Address

        UPDATE  Location.t_Address
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix Bank

        UPDATE  Company.t_Bank
        SET     RegionIs = @Name
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix Contact

        UPDATE  Company.t_Contact
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix Customer

        UPDATE  Customers.t_Customer
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix Employee

        UPDATE  Employees.t_Employee
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix SalesPerson

        UPDATE  Employees.t_SalesPerson
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix Vendor

        UPDATE  Vendors.t_Vendor
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix Warehouse

        UPDATE  Company.t_WareHouse
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix t_Bond

        UPDATE  Company.t_Bond
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, N'', N'', N'', N'', ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix t_BondHistory

        UPDATE  Company.t_BondHistory
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, N'', N'', N'', N'', ' - ', '-')
        WHERE   RegionID = @ID;

      END;
      
      BEGIN --Fix t_Doctor

        UPDATE  Company.t_Doctor
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;

      END;

      BEGIN --Fix t_FrameJobOrder

        UPDATE  Customers.t_FrameJobOrder
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, N'', N'', N'', N'', ' - ', '-')
        WHERE   RegionID = @ID;

      END;
  
      BEGIN --Fix t_FrameJobOrderHistory

        UPDATE  Customers.t_FrameJobOrderHistory
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, N'', N'', N'', N'', ' - ', '-')
        WHERE   RegionID = @ID;

      END;
   
      BEGIN --Fix t_CarDriver

        UPDATE  Cars.t_CarDriver
        SET     RegionIs = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, @Name, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   RegionID = @ID;
 
        UPDATE  Cars.t_CarDriver
        SET     DrivingLicenseRegion = @Name
        WHERE   DrivingLicenseRegionID = @ID;
 
        UPDATE  Cars.t_CarDriver
        SET     BirthdayRegion = @Name
        WHERE   BirthdayRegionID = @ID;

      END;

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
