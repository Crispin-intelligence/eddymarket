SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerUpdateInternetPackage]
  @InternetPackageID UNIQUEIDENTIFIER ,
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
      SET     InternetPackageID = @InternetPackageID ,
              InternetPackage = Customers.f_InternetPackageGetName(@InternetPackageID)
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

    BEGIN --Fix t_InternetPackage 

      UPDATE  Customers.t_InternetPackage
      SET     TotalCustomers = ( SELECT COUNT(*)
                                 FROM   Customers.t_Customer AS s
                                 WHERE  s.InternetPackageID = t_InternetPackage.ID
                               );

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
