SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Location].[s_BuildingRebuildingStatistics]
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

      UPDATE  Location.t_Building
      SET     AddressC = ( SELECT COUNT(*)
                           FROM   Location.t_Address AS s
                           WHERE  s.BuildingID = t_Building.ID
                         ) ,
              BankC = ( SELECT  COUNT(*)
                        FROM    Company.t_Bank AS s
                        WHERE   s.BuildingID = t_Building.ID
                      ) ,
              ContactC = ( SELECT COUNT(*)
                           FROM   Company.t_Contact AS s
                           WHERE  s.BuildingID = t_Building.ID
                         ) ,
              CustomerC = ( SELECT  COUNT(*)
                            FROM    Customers.t_Customer AS s
                            WHERE   s.BuildingID = t_Building.ID
                          ) ,
              EmployeeC = ( SELECT  COUNT(*)
                            FROM    Employees.t_Employee AS s
                            WHERE   s.BuildingID = t_Building.ID
                          ) ,
              SalesPersonC = ( SELECT COUNT(*)
                               FROM   Employees.t_SalesPerson AS s
                               WHERE  s.BuildingID = t_Building.ID
                             ) ,
              VendorC = ( SELECT  COUNT(*)
                          FROM    Vendors.t_Vendor AS s
                          WHERE   s.BuildingID = t_Building.ID
                        ) ,
              WarehouseC = ( SELECT COUNT(*)
                             FROM   Company.t_WareHouse AS s
                             WHERE  s.BuildingID = t_Building.ID
                           );

      UPDATE  Location.t_Building
      SET     SearchText = Location.f_BuildingSearchTextGet(ID);

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Location.t_BuildingMoving
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
