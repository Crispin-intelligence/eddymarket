SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Options].[s_ReportHeaderFooterInsert] @Name NVARCHAR(450) ,
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

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT INTO Options.t_ReportHeaderFooter
          ( Name ,
            ImageEN ,
            ImageEN2 ,
            TitleReportEN ,
            HeaderEN ,
            SignatureImageEN ,
            FooterEN ,
            ImageAR ,
            ImageAR2 ,
            TitleReportAR ,
            HeaderAR ,
            SignatureImageAR ,
            FooterAR
          )
        OUTPUT Inserted.ID
          INTO @IDs ( ID )
        VALUES
          ( @Name ,
            @ImageEN ,
            @ImageEN2 ,
            @TitleReportEN ,
            @HeaderEN ,
            @SignatureImageEN ,
            @FooterEN ,
            @ImageAR ,
            @ImageAR2 ,
            @TitleReportAR ,
            @HeaderAR ,
            @SignatureImageAR ,
            @FooterAR
          );

      SET @ID = ( SELECT TOP ( 1 ) ID
                    FROM @IDs
                    ORDER BY ID
                );

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
            0 ,
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
