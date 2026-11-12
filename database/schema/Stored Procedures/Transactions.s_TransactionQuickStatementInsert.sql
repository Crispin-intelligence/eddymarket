SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Transactions].[s_TransactionQuickStatementInsert] @Name NVARCHAR(MAX) ,
  @ShortcutText NVARCHAR(MAX) ,
  @SectionID INT ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @return INT;

    END;

    BEGIN --Insert transaction

      SET @return = 0;

      INSERT INTO Transactions.t_TransactionQuickStatement
          ( Name ,
            ShortcutText ,
            SectionID ,
            CreateByID ,
            CreateBy
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Name ,
            @ShortcutText ,
            @SectionID ,
            @UserID ,
            Users.f_UserGetName(@UserID)
          );

      SET @ID = ( SELECT TOP ( 1 ) s.ID
                    FROM @IDs AS s
                    ORDER BY s.ID
                );

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Transactions.t_TransactionQuickStatementMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
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

    RETURN @return;

  END CATCH;

END;






GO
