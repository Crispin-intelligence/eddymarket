SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountUpdateStatusIs]
  @StatusIs TINYINT ,
  @WhyThisStatus NVARCHAR(MAX) ,
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

    BEGIN --Update 

      SET @Return = 0;

      UPDATE  Company.t_Account
      SET     StatusIs = @StatusIs ,
              WhyThisStatus = @WhyThisStatus
      WHERE   ID = @ID;

      UPDATE  Company.t_Account
      SET     SearchText = Company.f_AccountSearchTextGet(ID)
      WHERE   ID = @ID;

      IF @SectionID = 15
      BEGIN

        UPDATE  Customers.t_Customer
        SET     StatusIs = @StatusIs ,
                WhyThisStatus = @WhyThisStatus
        WHERE   ID = @LinkWithID;

      END;
      ELSE
        IF @SectionID = 33
        BEGIN

          UPDATE  Employees.t_Employee
          SET     StatusIs = @StatusIs ,
                  WhyThisStatus = @WhyThisStatus
          WHERE   ID = @LinkWithID;

        END;
        ELSE
          IF @SectionID = 149
          BEGIN

            UPDATE  Employees.t_SalesPerson
            SET     StatusIs = @StatusIs ,
                    WhyThisStatus = @WhyThisStatus
            WHERE   ID = @LinkWithID;

          END;

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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;






GO
