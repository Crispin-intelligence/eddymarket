SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_BankUpdateTemplate]
  @CurrencyX FLOAT ,
  @CurrencyY FLOAT ,
  @PriceX FLOAT ,
  @PriceY FLOAT ,
  @NoteX FLOAT ,
  @NoteY FLOAT ,
  @BeneficiaryX FLOAT ,
  @BeneficiaryY FLOAT ,
  @PriceWordX FLOAT ,
  @PriceWordY FLOAT ,
  @AddressX FLOAT ,
  @AddressY FLOAT ,
  @DateX FLOAT ,
  @DateY FLOAT ,
  @UnderlinedX FLOAT ,
  @UnderlinedY FLOAT ,
  @UnderlinedH FLOAT ,
  @UnderlinedW FLOAT ,
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
      UPDATE  Company.t_Bank
      SET     CurrencyX = @CurrencyX ,
              CurrencyY = @CurrencyY ,
              PriceX = @PriceX ,
              PriceY = @PriceY ,
              NoteX = @NoteX ,
              NoteY = @NoteY ,
              BeneficiaryX = @BeneficiaryX ,
              BeneficiaryY = @BeneficiaryY ,
              PriceWordX = @PriceWordX ,
              PriceWordY = @PriceWordY ,
              AddressX = @AddressX ,
              AddressY = @AddressY ,
              DateX = @DateX ,
              DateY = @DateY ,
              UnderlinedX = @UnderlinedX ,
              UnderlinedY = @UnderlinedY ,
              UnderlinedH = @UnderlinedH ,
              UnderlinedW = @UnderlinedW
      WHERE   ID = @ID;

      UPDATE  Company.t_Bank
      SET     SearchText = Company.f_BankSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_BankMoving
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
