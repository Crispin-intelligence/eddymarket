SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerUpdateEmployeeIDInternet]
  @EmployeeIDInternet UNIQUEIDENTIFIER ,
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

      UPDATE  Customers.t_Customer
      SET     EmployeeIDInternet = @EmployeeIDInternet ,
              EmployeeInternet = Employees.f_EmployeeGetName(@EmployeeIDInternet)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_Customer.ID );

      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_Customer.ID );
	 
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_CustomerMoving
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
