SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionQuickStatementUpDate] @Name NVARCHAR(MAX) ,
  @ShortcutText NVARCHAR(MAX) ,
  @SectionID INT ,
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

      DECLARE @return INT;

    END;

    BEGIN --Update transaction

      SET @return = 0;

      UPDATE Transactions.t_TransactionQuickStatement
        SET Name = @Name ,
            ShortcutText = @ShortcutText ,
            SectionID = @SectionID
        WHERE ID = @ID;

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
