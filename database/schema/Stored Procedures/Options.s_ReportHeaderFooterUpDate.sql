SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Options].[s_ReportHeaderFooterUpDate] @Name NVARCHAR(450) ,
  @ImageEN IMAGE ,
  @ImageEN2 IMAGE ,
  @TitleReportEN NVARCHAR(MAX) ,
  @HeaderEN NVARCHAR(MAX) ,
  @SignatureImageEN IMAGE ,
  @FooterEN NVARCHAR(MAX) ,
  @ImageAR IMAGE ,
  @ImageAR2 IMAGE ,
  @TitleReportAR NVARCHAR(MAX) ,
  @HeaderAR NVARCHAR(MAX) ,
  @SignatureImageAR IMAGE ,
  @FooterAR NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    SET ANSI_WARNINGS OFF;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Update

      SET @Return = 0;

      UPDATE Options.t_ReportHeaderFooter
        SET Name = @Name ,
            ImageEN = @ImageEN ,
            ImageEN2 = @ImageEN2 ,
            TitleReportEN = @TitleReportEN ,
            HeaderEN = @HeaderEN ,
            SignatureImageEN = @SignatureImageEN ,
            FooterEN = @FooterEN ,
            ImageAR = @ImageAR ,
            ImageAR2 = @ImageAR2 ,
            TitleReportAR = @TitleReportAR ,
            HeaderAR = @HeaderAR ,
            SignatureImageAR = @SignatureImageAR ,
            FooterAR = @FooterAR
        WHERE ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT INTO Options.t_ReportHeaderFooterMoving
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

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO
