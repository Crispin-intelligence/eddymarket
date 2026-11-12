SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Customers].[s_CustomerGroupUpdate]
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
      FROM    Customers.t_CustomerGroup AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE  Customers.t_CustomerGroup
      SET     Name = @Name ,
              DescriptionIs = @DescriptionIs
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_CustomerGroupMoving
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

      BEGIN --Customer

        DECLARE @CustomerIDs AS TABLE ( ID UNIQUEIDENTIFIER );

        INSERT  INTO @CustomerIDs
                ( ID
                )
        SELECT DISTINCT
                s.CustomerID
        FROM    Customers.t_CustomerGroupDetail AS s
        WHERE   s.CustomerGroupID = @ID;

        UPDATE  Customers.t_Customer
        SET     GroupNames = Alls.f_FixXML(( SELECT N', ' + t1.Name AS [text()]
                                             FROM   Customers.t_CustomerGroupDetail AS t
                                             LEFT JOIN Customers.t_CustomerGroup AS t1 ON t1.ID = t.CustomerGroupID
                                             WHERE  t.CustomerID = t_Customer.ID
                                           FOR
                                             XML PATH('')
                                           ))
        WHERE   EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @CustomerIDs AS s
                         WHERE  s.ID = t_Customer.ID );

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
