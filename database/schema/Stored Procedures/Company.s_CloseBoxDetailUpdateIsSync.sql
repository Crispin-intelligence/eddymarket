SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_CloseBoxDetailUpdateIsSync] 
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT = 0;

    END;

    DISABLE TRIGGER Company.tr_CloseBoxDetail ON Company.t_CloseBoxDetail;

    BEGIN --Insert

      UPDATE Company.t_CloseBoxDetail
        SET IsSync = 1
        WHERE ID = @ID;

    END;

    ENABLE TRIGGER Company.tr_CloseBoxDetail ON Company.t_CloseBoxDetail;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;




GO
