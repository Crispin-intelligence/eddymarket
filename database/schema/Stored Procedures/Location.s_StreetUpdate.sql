SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_StreetUpdate]
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
      FROM    Location.t_Street AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Location.t_Street
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

      UPDATE  Location.t_Street
      SET     SearchText = Location.f_StreetSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Location.t_StreetMoving
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
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix Bank

        UPDATE  Company.t_Bank
        SET     Street = @Name
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix Contact

        UPDATE  Company.t_Contact
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix Customer

        UPDATE  Customers.t_Customer
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix Employee

        UPDATE  Employees.t_Employee
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix SalesPerson

        UPDATE  Employees.t_SalesPerson
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix Vendor

        UPDATE  Vendors.t_Vendor
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix Warehouse

        UPDATE  Company.t_WareHouse
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix t_Bond

        UPDATE  Company.t_Bond
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, N'', N'', N'', N'', ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix t_BondHistory

        UPDATE  Company.t_BondHistory
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, N'', N'', N'', N'', ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix t_Doctor

        UPDATE  Company.t_Doctor
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix t_FrameJobOrder

        UPDATE  Customers.t_FrameJobOrder
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, N'', N'', N'', N'', ' - ', '-')
        WHERE   StreetID = @ID;

      END;

      BEGIN --Fix t_FrameJobOrderHistory

        UPDATE  Customers.t_FrameJobOrderHistory
        SET     Street = @Name ,
                AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, @Name, N'', N'', N'', N'', ' - ', '-')
        WHERE   StreetID = @ID;

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
