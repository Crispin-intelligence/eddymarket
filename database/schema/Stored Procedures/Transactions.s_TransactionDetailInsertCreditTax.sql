SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Transactions].[s_TransactionDetailInsertCreditTax] @RowNumber INT ,
  @TransactionID UNIQUEIDENTIFIER ,
  @AccountID UNIQUEIDENTIFIER ,
  @DateIs DATE ,
  @CID UNIQUEIDENTIFIER ,
  @V FLOAT ,
  @E DECIMAL(18, 2) ,
  @ELL DECIMAL(18, 2) ,
  @EEuro DECIMAL(18, 2) ,
  @Tax FLOAT ,
  @TaxELL DECIMAL(18, 2) ,
  @TaxEEuro DECIMAL(18, 2) ,
  @StatementIs NVARCHAR(MAX)
AS
BEGIN
 
  BEGIN --Insert

    DECLARE @VD FLOAT ,
      @VLL FLOAT ,
      @VEuro FLOAT;

    SET @VD = @V / @E;
    SET @VLL = ( ( ( @V - @Tax ) / @E ) * @ELL ) + ( ( @Tax / @E ) * @TaxELL );
    SET @VEuro = ( ( ( ( @V - @Tax ) / @E ) * @EEuro ) + ( ( @Tax / @E ) * @TaxEEuro ) );

    INSERT INTO Transactions.t_TransactionDetail
        ( RowNumber ,
          TransactionID ,
          AccountID ,
          Account ,
          DateIs ,
          DateOnly ,
          DateFirstDayInMonth ,
          DateFirstDayInYear ,
          Balance ,
          BalanceF ,
          BalanceD ,
          BalanceLL ,
          BalanceEuro ,
          BalanceAR ,
          BalanceEN ,
          Credit ,
          CreditD ,
          CreditLL ,
          CreditEuro ,
          StatementIs ,
          CurrencyID ,
          Currency ,
          CurrencyTypeIs ,
          ExchangeRate
        )
      VALUES
        ( @RowNumber ,
          @TransactionID ,
          @AccountID ,
          Company.f_AccountGetName(@AccountID) ,
          @DateIs ,
          @DateIs ,
          DATEFROMPARTS(YEAR(@DateIs), MONTH(@DateIs), 1) ,
          DATEFROMPARTS(YEAR(@DateIs), 1, 1) ,
          0 - @V ,
          Currencys.f_Format(@CID, 0 - @V) ,
          0 - @VD ,
          0 - @VLL ,
          0 - @VEuro ,
          Currencys.f_ToWordAR(@V, @CID, 1) ,
          Currencys.f_ToWordEN(@V, @CID, 1) ,
          @V ,
          @VD ,
          @VLL ,
          @VEuro ,
          @StatementIs ,
          @CID ,
          Currencys.f_CurrencyGetName(@CID) ,
          Currencys.f_CurrencyGetTypeIs(@CID) ,
          @E
        );

    UPDATE Company.t_Account
      SET StatusIs = 0 ,
          LastAction = GETDATE()
      WHERE ID = @AccountID AND StatusIs = 1;

  END;

  RETURN 1;

END;










GO
