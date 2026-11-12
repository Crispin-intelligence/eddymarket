SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Company].[s_ExpenseInsertsPART]
  @LinkedType INT ,
  @LinkID UNIQUEIDENTIFIER ,
  @LinkRef NVARCHAR(MAX) ,
  @DateIs DATE ,
  @Expenses Company.tt_Expenses READONLY ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN

  IF NOT EXISTS ( SELECT  s.ID
                  FROM    @Expenses AS s )
  BEGIN

    RETURN 0;

  END;
                  
  BEGIN --Declare
  
    DECLARE @ID UNIQUEIDENTIFIER ,
      @BoxAccountID UNIQUEIDENTIFIER ,
      @ExpenseAccountID UNIQUEIDENTIFIER ,
      @VendorAccountID UNIQUEIDENTIFIER ,
      @VendorTaxAccountID UNIQUEIDENTIFIER ,
      @PaymentMethod TINYINT ,
      @CurrencyID UNIQUEIDENTIFIER ,
      @ExchangeRate DECIMAL(18, 2) ,
      @ExchangeRateLL DECIMAL(18, 2) ,
      @ExchangeRateEuro DECIMAL(18, 2) ,
      @TaxExchangeRateLL DECIMAL(18, 2) ,
      @TaxExchangeRateEuro DECIMAL(18, 2) ,
      @TaxExchangeRateEvent NVARCHAR(MAX) ,
      @Balance FLOAT ,
      @TaxRate DECIMAL(4, 2) ,
      @TaxValue FLOAT ,
      @NetIs FLOAT ,
      @TransactionDetailTypeIs TINYINT ,
      @ChequeNumber NVARCHAR(MAX) ,
      @ChequeImage VARBINARY(MAX) ,
      @ChequeNote NVARCHAR(MAX) ,
      @ChequeDateGet DATE ,
      @ChequeStopNotificationGet BIT ,
      @NotificationTextAR NVARCHAR(MAX) ,
      @NotificationTextEN NVARCHAR(MAX) ,
      @DescriptionIs NVARCHAR(MAX) ,
      @StatementIs NVARCHAR(MAX); 

  END;
  
  DECLARE i CURSOR FORWARD_ONLY
  FOR
  SELECT  s.ID
  FROM    @Expenses AS s;

  OPEN i;
  FETCH NEXT FROM i
    INTO @ID;
  WHILE @@FETCH_STATUS = 0
  BEGIN
	
    BEGIN --Set info

      SELECT TOP ( 1 )
              @BoxAccountID = s.BoxAccountID ,
              @ExpenseAccountID = s.ExpenseAccountID ,
              @VendorAccountID = s.VendorAccountID ,
              @VendorTaxAccountID = s.VendorTaxAccountID ,
              @PaymentMethod = s.PaymentMethod ,
              @CurrencyID = s.CurrencyID ,
              @ExchangeRate = s.ExchangeRate ,
              @ExchangeRateLL = s.ExchangeRateLL ,
              @ExchangeRateEuro = s.ExchangeRateEuro ,
              @TaxExchangeRateLL = s.TaxExchangeRateLL ,
              @TaxExchangeRateEuro = s.TaxExchangeRateEuro ,
              @TaxExchangeRateEvent = s.TaxExchangeRateEvent ,
              @Balance = s.Balance ,
              @TaxRate = s.TaxRate ,
              @TaxValue = s.TaxValue ,
              @NetIs = s.NetIs ,
              @TransactionDetailTypeIs = s.TransactionDetailTypeIs ,
              @ChequeNumber = s.ChequeNumber ,
              @ChequeImage = s.ChequeImage ,
              @ChequeNote = s.ChequeNote ,
              @ChequeDateGet = s.ChequeDateGet ,
              @ChequeStopNotificationGet = s.ChequeStopNotificationGet ,
              @NotificationTextAR = s.NotificationTextAR ,
              @NotificationTextEN = s.NotificationTextEN ,
              @DescriptionIs = s.DescriptionIs ,
              @StatementIs = s.StatementIs
      FROM    @Expenses AS s
      WHERE   s.ID = @ID;

    END;

    EXECUTE Company.s_ExpenseInsertPART @LinkedType, @LinkID, @LinkRef, @DateIs, @BoxAccountID, @ExpenseAccountID, @VendorAccountID, @VendorTaxAccountID, @PaymentMethod,
      @CurrencyID, @ExchangeRate, @ExchangeRateLL, @ExchangeRateEuro, @TaxExchangeRateLL, @TaxExchangeRateEuro, @TaxExchangeRateEvent, @Balance, @TaxRate,
      @TaxValue, @NetIs, @TransactionDetailTypeIs, @ChequeNumber, @ChequeImage, @ChequeNote, @ChequeDateGet, @ChequeStopNotificationGet, @NotificationTextAR,
      @NotificationTextEN, @DescriptionIs, @StatementIs, @UserID, @Event, @ComputerIP, @Computer, @ComputerAccount, @ID; 
	
    FETCH NEXT FROM i
        INTO @ID;
  END;
  CLOSE i;
  DEALLOCATE i;
  
  RETURN 1;

END;


GO
