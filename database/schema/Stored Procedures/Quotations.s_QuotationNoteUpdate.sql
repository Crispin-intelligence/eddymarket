SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationNoteUpdate] @Name NVARCHAR(MAX) ,
  @AutoInsert BIT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @SortAt FLOAT ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    SET ANSI_WARNINGS OFF;

    BEGIN TRANSACTION;
	
    BEGIN --Declare

      DECLARE @Return INT ,
        @NameOld NVARCHAR(450);

    END;

    BEGIN --Set info

      SELECT TOP ( 1 ) @NameOld = s.Name
        FROM Quotations.t_QuotationNote AS s
        WHERE s.ID = @ID
        ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE Quotations.t_QuotationNote
        SET Name = @Name ,
            AutoInsert = @AutoInsert ,
            DescriptionIs = @DescriptionIs ,
            SortAt = @SortAt
        WHERE ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Quotations.t_QuotationNoteMoving
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
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    --IF @NameOld COLLATE Arabic_CS_AS <> @Name COLLATE Arabic_CS_AS
        --BEGIN

        --    BEGIN --Fix t_Quotation

        --        UPDATE Quotations.t_Quotation
        --        SET Note = @Name
        --        WHERE NoteID = @ID;

        --    END;

        --    BEGIN --Fix t_QuotationHistory

        --        UPDATE Quotations.t_QuotationHistory
        --        SET Note = @Name
        --        WHERE NoteID = @ID;

        --    END;

        --END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;










GO
