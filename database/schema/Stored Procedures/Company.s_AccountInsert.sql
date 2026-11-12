SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_AccountInsert]
  @Level3ID UNIQUEIDENTIFIER ,
  @NumberF NVARCHAR(MAX) ,
  @Name NVARCHAR(450) ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @Limit FLOAT ,
  @DescriptionIs NVARCHAR(MAX) ,
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

      DECLARE @Return INT ,
        @ExchangeRate DECIMAL(18, 2);

    END;

    BEGIN --Set Info

      SELECT  @ExchangeRate = ExchangeRate
      FROM    Currencys.t_Currency
      WHERE   ID = @CurrencyID;

    END;

    BEGIN --Insert

      SET @Return = 0;

      BEGIN --Insert

        SET @Return = 0;

        INSERT  INTO Company.t_Account
                ( ID ,
                  Level3ID ,
                  Level3 ,
                  NumberIs ,
                  NumberF ,
                  NumberNet ,
                  Name ,
                  CurrencyID ,
                  Currency ,
                  CurrencyTypeIs ,
                  Limit ,
                  LimitF ,
                  LimitD ,
                  DescriptionIs
                )
        VALUES  ( @ID ,
                  @Level3ID ,
                  Company.f_AccountLevel3GetName(@Level3ID) ,
                  @NumberF ,
                  @NumberF ,
                  SUBSTRING(@NumberF, 6, 5) ,
                  @Name ,
                  @CurrencyID ,
                  Currencys.f_CurrencyGetName(@CurrencyID) ,
                  Currencys.f_CurrencyGetTypeIs(@CurrencyID) ,
                  @Limit ,
                  Currencys.f_Format(@CurrencyID, @Limit) ,
                  @Limit * @ExchangeRate ,
                  @DescriptionIs
                );

        UPDATE  Company.t_Account
        SET     SearchText = Company.f_AccountSearchTextGet(ID)
        WHERE   ID = @ID;

      END;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Company.t_AccountMoving
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
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRAN;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;








GO
