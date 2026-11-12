SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountDelete]
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
    BEGIN TRANSACTION accountDelete;

    BEGIN --Declare

      DECLARE @Return INT ,
        @SectionID INT ,
        @LinkWithID UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @SectionID = s.SectionID ,
              @LinkWithID = s.LinkWithID
      FROM    Company.t_Account AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Delete t_InternetSubscription

      DELETE  FROM Invoices.t_InternetSubscription
      WHERE   AccountBoxID = @ID;

    END;

    BEGIN --Delete profile

      SET @Return = 0;

      IF @SectionID = 15
      BEGIN

        EXECUTE Customers.s_CustomerDelete @UserID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount, @LinkWithID;

      END;

      IF @SectionID = 33
      BEGIN

        EXECUTE Employees.s_EmployeeDelete @UserID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount, @LinkWithID;

      END;

      IF @SectionID = 38
      BEGIN

        EXECUTE Company.s_BankDelete @UserID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount, @LinkWithID;

      END;

      IF @SectionID = 67
      BEGIN

        EXECUTE Vendors.s_VendorDelete @UserID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount, @LinkWithID;

      END;

      IF @SectionID = 149
      BEGIN

        EXECUTE Employees.s_SalesPersonDelete @UserID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount, @LinkWithID;

      END;
 
      IF @SectionID = 179
      BEGIN

        EXECUTE Cars.s_CarOwnersProfileDelete @UserID, @Event, @EventType, @ComputerIP, @Computer, @ComputerAccount, @LinkWithID;

      END;

    END;

    BEGIN --Delete

      DELETE  FROM Company.t_AccountItemPrice
      WHERE   AccountID = @ID;

      DELETE  FROM Company.t_Account
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_AccountMoving
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

    COMMIT TRANSACTION accountDelete;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK TRANSACTION accountDelete;

    RETURN @Return;

  END CATCH;

END;








GO
