SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_ClassificationRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Rebuilding statistics

      SET @Return = 0;

      UPDATE  Customers.t_Classification
      SET     CustomerC = ( SELECT  COUNT(*)
                            FROM    Customers.t_Customer AS s
                            WHERE   s.ClassificationID = t_Classification.ID
                          ) ,
              VendorC = ( SELECT  COUNT(*)
                          FROM    Vendors.t_Vendor AS s
                          WHERE   s.ClassificationID = t_Classification.ID
                        );

      UPDATE  Customers.t_Classification
      SET     SearchText = Customers.f_ClassificationSearchTextGet(ID);
	  
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_ClassificationMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
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
