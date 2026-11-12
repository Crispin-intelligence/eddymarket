SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarRentalOwnerDeletePaid]
  @UserID UNIQUEIDENTIFIER ,
  @EventBase NVARCHAR(MAX) ,
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
	   
      DECLARE @TrnIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @CarRentalID UNIQUEIDENTIFIER ,
        @TrnLinkType TINYINT = 185 ,
        @TrnLinkTypeSub TINYINT = 11 ,
        @return INT = 0;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @CarRentalID = s.CarRentalID
      FROM    Cars.t_CarRentalOwner AS s
      WHERE   s.ID = @ID;
	      
    END;

    BEGIN --Update

      UPDATE  Cars.t_CarRentalOwner
      SET     Paid = 0
      WHERE   ID = @ID;  
	  
    END;
	
    BEGIN --Insert t_CarRentalMoving

      SET @return = -1;

      INSERT  INTO Cars.t_CarRentalMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @CarRentalID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;
 
    BEGIN --Delete t_Transaction

      INSERT  INTO @TrnIDs
              ( ID ,
                RefF
              )
      SELECT  s.ID ,
              s.RefF
      FROM    Transactions.t_Transaction AS s
      WHERE   s.LinkType = @TrnLinkType
              AND s.LinkTypeSub = @TrnLinkTypeSub
              AND s.LinkID = @CarRentalID
              AND s.SubLinkID = @ID;

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = @TrnLinkType
              AND LinkTypeSub = @TrnLinkTypeSub
              AND LinkID = @CarRentalID
              AND SubLinkID = @ID;

    END;

    BEGIN --Insert t_TransactionMoving

      SET @return = -1;

      INSERT  INTO Transactions.t_TransactionMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      SELECT  @UserID ,
              s.ID ,
              @EventBase + N': ' + s.RefF ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @TrnIDs AS s;

    END;
	
    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @return;

  END CATCH;

END;



GO
