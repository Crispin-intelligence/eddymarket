SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_SalesPersonUpdate]
  @Name NVARCHAR(450) ,
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @BuildingID UNIQUEIDENTIFIER ,
  @FloorID UNIQUEIDENTIFIER ,
  @PostalCodeID UNIQUEIDENTIFIER ,
  @AddressNote NVARCHAR(MAX) ,
  @CommissionRate DECIMAL(4, 2) ,
  @CommissionRateType TINYINT ,
  @CommissionRateOn TINYINT ,
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
        @NameOld NVARCHAR(450) ,
        @AccountID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @NameOld = s.Name
      FROM    Employees.t_SalesPerson AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;
      UPDATE  Employees.t_SalesPerson
      SET     Name = @Name ,
              StatesID = @StatesID ,
              RegionID = @RegionID ,
              StreetID = @StreetID ,
              BuildingID = @BuildingID ,
              FloorID = @FloorID ,
              PostalCodeID = @PostalCodeID ,
              AddressNote = @AddressNote ,
              CommissionRate = @CommissionRate ,
              CommissionRateType = @CommissionRateType ,
              CommissionRateOn = @CommissionRateOn ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    BEGIN --Format

      EXECUTE [Employees].s_SalesPersonFormat @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Employees.t_SalesPersonMoving
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

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name
        WHERE   SectionID = 149
                AND LinkWithID = @ID;

      END;

      BEGIN --t_Account

        UPDATE  Company.t_Account
        SET     LinkWith = @Name ,
                Name = @Name + ' (عمولات البيع)'
        WHERE   SectionID = 149
                AND LinkWithID = @ID
                AND NumberIs BETWEEN 7010800000 AND 7010899999;

      END;

      BEGIN --t_Customer

        UPDATE  Customers.t_Customer
        SET     SalesPerson = @Name
        WHERE   SalesPersonID = @ID;

      END;

      BEGIN; --t_FrameJobOrder

        UPDATE  Customers.t_FrameJobOrder
        SET     Salesperson = @Name
        WHERE   SalespersonID = @ID;

      END;
     
      BEGIN; --t_FrameJobOrderHistory

        UPDATE  Customers.t_FrameJobOrderHistory
        SET     Salesperson = @Name
        WHERE   SalespersonID = @ID;

      END;

      BEGIN --Set info

        SELECT TOP ( 1 )
                @AccountID = s.ID
        FROM    Company.t_Account AS s
        WHERE   SectionID = 149
                AND LinkWithID = @ID
        ORDER BY s.ID;

      END;

      BEGIN; --t_Purchasing

        UPDATE  Invoices.t_Purchasing
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;
				
        UPDATE  Invoices.t_Purchasing
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

      END;

      BEGIN; --t_PurchasingReturn

        UPDATE  Invoices.t_PurchasingReturn
        SET     AccountVendor = @Name
        WHERE   AccountVendorID = @AccountID;

        UPDATE  Invoices.t_PurchasingReturn
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

      END;

      BEGIN; --t_Sold

        UPDATE  Invoices.t_Sold
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

        UPDATE  Invoices.t_Sold
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

        UPDATE  Invoices.t_Sold
        SET     Salesperson = @Name
        WHERE   SalespersonID = @ID;

      END;

      BEGIN; --t_SoldReturn

        UPDATE  Invoices.t_SoldReturn
        SET     AccountCustomer = @Name
        WHERE   AccountCustomerID = @AccountID;

        UPDATE  Invoices.t_SoldReturn
        SET     AccountBox = @Name
        WHERE   AccountBoxID = @AccountID;

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
