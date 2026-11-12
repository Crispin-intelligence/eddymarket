SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeUpdateAddress]
  @StatesID UNIQUEIDENTIFIER ,
  @RegionID UNIQUEIDENTIFIER ,
  @StreetID UNIQUEIDENTIFIER ,
  @UserID UNIQUEIDENTIFIER ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Update 

      SET @Return = 0;

      UPDATE  Employees.t_Employee
      SET     StatesID = @StatesID ,
              StatesIs = Location.f_StatesGetName(@StatesID) ,
              RegionID = @RegionID ,
              RegionIs = Location.f_RegionGetName(@RegionID) ,
              StreetID = @StreetID ,
              Street = Location.f_StreetGetName(@StreetID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_Employee.ID );

      UPDATE  Employees.t_Employee
      SET     AddressIs = Location.f_ConcetFullAddress(StatesIs, RegionIs, Street, Building, FloorIs, PostalCode, AddressNote, ' - ', '-')
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_Employee.ID );

      UPDATE  Employees.t_Employee
      SET     SearchText = Employees.f_EmployeeSearchTextGet(ID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_Employee.ID );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Employees.t_EmployeeMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s.ID ,
              s.EventIs ,
              1 ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @IDAndEvent AS s;

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
