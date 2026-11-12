SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_SoldProfitPartnerUpdatePaid]
  @Paid BIT ,
  @UserID UNIQUEIDENTIFIER ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT = 0;

    END;

    BEGIN --Update 

      UPDATE  Invoices.t_SoldProfitPartner
      SET     Paid = @Paid
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDAndEvent AS s
                       WHERE  s.ID = t_SoldProfitPartner.ID );

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Invoices.t_SoldMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s1.SoldID ,
              s.EventIs ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @IDAndEvent AS s
      INNER JOIN Invoices.t_SoldProfitPartner AS s1 ON s1.ID = s.ID;

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
