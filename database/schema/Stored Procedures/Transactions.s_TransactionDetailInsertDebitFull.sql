SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Transactions].[s_TransactionDetailInsertDebitFull]
  @RowNumber INT ,
  @TransactionID UNIQUEIDENTIFIER ,
  @AccountID UNIQUEIDENTIFIER ,
  @DateIs DATE ,
  @CID UNIQUEIDENTIFIER ,
  @V FLOAT ,
  @E DECIMAL(18, 2) ,
  @ELL DECIMAL(18, 2) ,
  @EEuro DECIMAL(18, 2) ,
  @StatementIs NVARCHAR(MAX) ,
  @TypeIs TINYINT ,
  @ChequeNumber NVARCHAR(MAX) ,
  @ChequeImage IMAGE ,
  @ChequeNote NVARCHAR(MAX) ,
  @ChequeDateGet DATE ,
  @ChequeStopNotificationGet BIT ,
  @NotificationTextAR NVARCHAR(MAX) ,
  @NotificationTextEN NVARCHAR(MAX)
AS
BEGIN
 
  BEGIN --Insert

    DECLARE @VD FLOAT ,
      @VLL FLOAT ,
      @VEuro FLOAT;

    SET @VD = @V / @E;
    SET @VLL = @VD * @ELL;
    SET @VEuro = @VD * @EEuro;

    INSERT  INTO Transactions.t_TransactionDetail
            ( RowNumber ,
              TransactionID ,
              AccountID ,
              Account ,
              DateIs ,
              DateOnly ,
              DateFirstDayInMonth ,
              DateFirstDayInYear ,
              CurrencyID ,
              Currency ,
              CurrencyTypeIs ,
              ExchangeRate ,
              Balance ,
              BalanceF ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro ,
              BalanceAR ,
              BalanceEN ,
              Debit ,
              DebitD ,
              DebitLL ,
              DebitEuro ,
              StatementIs ,
              TypeIs ,
              ChequeNumber ,
              ChequeImage ,
              ChequeNote ,
              ChequeDateGet ,
              ChequeStopNotificationGet ,
              NotificationTextAR ,
              NotificationTextEN
            )
    VALUES  ( @RowNumber ,
              @TransactionID ,
              @AccountID ,
              Company.f_AccountGetName(@AccountID) ,
              @DateIs ,
              @DateIs ,
              DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
              DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
              @CID ,
              Currencys.f_CurrencyGetName(@CID) ,
              Currencys.f_CurrencyGetTypeIs(@CID) ,
              @E ,
              @V ,
              Currencys.f_Format(@CID, @V) ,
              @VD ,
              @VLL ,
              @VEuro ,
              Currencys.f_ToWordAR(@V, @CID, 1) ,
              Currencys.f_ToWordEN(@V, @CID, 1) ,
              @V ,
              @VD ,
              @VLL ,
              @VEuro ,
              @StatementIs ,
              @TypeIs ,
              @ChequeNumber ,
              @ChequeImage ,
              @ChequeNote ,
              @ChequeDateGet ,
              @ChequeStopNotificationGet ,
              @NotificationTextAR ,
              @NotificationTextEN
            );

    UPDATE  Company.t_Account
    SET     StatusIs = 0 ,
            LastAction = GETDATE()
    WHERE   ID = @AccountID
            AND StatusIs = 1;

  END;

  RETURN 1;

END;









GO
