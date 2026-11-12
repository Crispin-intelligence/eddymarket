SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Customers].[s_CustomerUpdateAdditionalProperty]
  @AdditionalProperty1 NVARCHAR(MAX) ,
  @AdditionalProperty2 NVARCHAR(MAX) ,
  @AdditionalProperty3 NVARCHAR(MAX) ,
  @AdditionalProperty4 NVARCHAR(MAX) ,
  @AdditionalProperty5 NVARCHAR(MAX) ,
  @AdditionalProperty6 NVARCHAR(MAX) ,
  @AdditionalProperty7 NVARCHAR(MAX) ,
  @AdditionalProperty8 NVARCHAR(MAX) ,
  @AdditionalProperty9 NVARCHAR(MAX) ,
  @AdditionalProperty10 NVARCHAR(MAX) ,
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

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Update 

      SET @Return = 0;

      UPDATE  Customers.t_Customer
      SET     AdditionalProperty1 = @AdditionalProperty1 ,
              AdditionalProperty2 = @AdditionalProperty2 ,
              AdditionalProperty3 = @AdditionalProperty3 ,
              AdditionalProperty4 = @AdditionalProperty4 ,
              AdditionalProperty5 = @AdditionalProperty5 ,
              AdditionalProperty6 = @AdditionalProperty6 ,
              AdditionalProperty7 = @AdditionalProperty7 ,
              AdditionalProperty8 = @AdditionalProperty8 ,
              AdditionalProperty9 = @AdditionalProperty9 ,
              AdditionalProperty10 = @AdditionalProperty10
      WHERE   ID = @ID;

      UPDATE  Customers.t_Customer
      SET     SearchText = Customers.f_CustomerSearchTextGet(ID)
      WHERE   ID = @ID;
	  
    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Customers.t_CustomerMoving
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
