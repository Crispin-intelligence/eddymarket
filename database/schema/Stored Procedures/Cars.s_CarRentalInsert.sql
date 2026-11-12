SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRentalInsert]
  @PaperRef NVARCHAR(MAX) ,
  @AccountID UNIQUEIDENTIFIER ,
  @AccountTaxID UNIQUEIDENTIFIER ,
  @AccountBoxID UNIQUEIDENTIFIER ,
  @AccountSellNonTaxableID UNIQUEIDENTIFIER ,
  @AccountSellTaxableID UNIQUEIDENTIFIER ,
  @CarID UNIQUEIDENTIFIER ,
  @DateIs DATETIME ,
  @AgreementDate DATE ,
  @FromDate DATE ,
  @ToDate DATE ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @ExchangeRate DECIMAL(18, 2) ,
  @ExchangeRateLL DECIMAL(18, 2) ,
  @ExchangeRateEuro DECIMAL(18, 2) ,
  @DayPrice FLOAT ,
  @DayQty INT ,
  @DayTotalPrice FLOAT ,
  @WeekPrice FLOAT ,
  @WeekQty INT ,
  @WeekTotalPrice FLOAT ,
  @MonthPrice FLOAT ,
  @MonthQty INT ,
  @MonthTotalPrice FLOAT ,
  @Subtotal FLOAT ,
  @Discount FLOAT ,
  @Total FLOAT ,
  @PaymentMethod TINYINT ,
  @FirstPayment FLOAT ,
  @PaidUp FLOAT ,
  @Rest FLOAT ,
  @Paid TINYINT ,
  @OfficeRatio DECIMAL(5, 2) ,
  @OfficeValue FLOAT ,
  @DailyTax FLOAT ,
  @TotalTax FLOAT ,
  @TaxRate DECIMAL(5, 2) ,
  @OfficeValueAfterTax FLOAT ,
  @Profit FLOAT ,
  @CheckOutDate DATETIME ,
  @CheckOutFuel INT ,
  @CheckOutOdometer INT ,
  @CheckInDate DATETIME ,
  @CheckInFuel INT ,
  @CheckInOdometer INT ,
  @StatusIs TINYINT ,
  @DescriptionIs NVARCHAR(MAX) ,
  @Notes NVARCHAR(MAX) ,
  @CarRentalOwner AS Cars.tt_CarRentalOwner READONLY ,
  @CarRentalDriver AS Cars.tt_CarRentalDriver READONLY ,
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

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @TrnIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @CarRentalOwner_ TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          CarRentalID UNIQUEIDENTIFIER NOT NULL ,
          OwnerProfileID UNIQUEIDENTIFIER NOT NULL ,
          OwnerProfile NVARCHAR(MAX) NOT NULL ,
          ProfitRatio DECIMAL(5, 2) NOT NULL ,
          Profit FLOAT NOT NULL ,
          ProfitF NVARCHAR(MAX) NOT NULL ,
          ProfitD FLOAT NOT NULL ,
          ProfitLL FLOAT NOT NULL ,
          ProfitEuro FLOAT NOT NULL
        );

      DECLARE @Ref BIGINT ,
        @RefF NVARCHAR(MAX) ,
        @Account NVARCHAR(MAX) ,
        @AccountNumberF NVARCHAR(MAX) ,
        @AccountBox NVARCHAR(MAX) ,
        @AccountBoxNumberF NVARCHAR(MAX) ,
        @Car NVARCHAR(MAX) ,
        @Currency NVARCHAR(MAX) ,
        @DayPriceF NVARCHAR(MAX) ,
        @DayPriceD FLOAT ,
        @DayPriceLL FLOAT ,
        @DayPriceEuro FLOAT ,
        @DayTotalPriceF NVARCHAR(MAX) ,
        @DayTotalPriceD FLOAT ,
        @DayTotalPriceLL FLOAT ,
        @DayTotalPriceEuro FLOAT ,
        @WeekPriceF NVARCHAR(MAX) ,
        @WeekPriceD FLOAT ,
        @WeekPriceLL FLOAT ,
        @WeekPriceEuro FLOAT ,
        @WeekTotalPriceF NVARCHAR(MAX) ,
        @WeekTotalPriceD FLOAT ,
        @WeekTotalPriceLL FLOAT ,
        @WeekTotalPriceEuro FLOAT ,
        @MonthPriceF NVARCHAR(MAX) ,
        @MonthPriceD FLOAT ,
        @MonthPriceLL FLOAT ,
        @MonthPriceEuro FLOAT ,
        @MonthTotalPriceF NVARCHAR(MAX) ,
        @MonthTotalPriceD FLOAT ,
        @MonthTotalPriceLL FLOAT ,
        @MonthTotalPriceEuro FLOAT ,
        @SubtotalF NVARCHAR(MAX) ,
        @SubtotalD FLOAT ,
        @SubtotalLL FLOAT ,
        @SubtotalEuro FLOAT ,
        @DiscountF NVARCHAR(MAX) ,
        @DiscountD FLOAT ,
        @DiscountLL FLOAT ,
        @DiscountEuro FLOAT ,
        @TotalF NVARCHAR(MAX) ,
        @TotalD FLOAT ,
        @TotalLL FLOAT ,
        @TotalEuro FLOAT ,
        @FirstPaymentF NVARCHAR(MAX) ,
        @FirstPaymentD FLOAT ,
        @FirstPaymentLL FLOAT ,
        @FirstPaymentEuro FLOAT ,
        @PaidUpF NVARCHAR(MAX) ,
        @PaidUpD FLOAT ,
        @PaidUpLL FLOAT ,
        @PaidUpEuro FLOAT ,
        @RestF NVARCHAR(MAX) ,
        @RestD FLOAT ,
        @RestLL FLOAT ,
        @RestEuro FLOAT ,
        @OfficeValueF NVARCHAR(MAX) ,
        @OfficeValueD FLOAT ,
        @OfficeValueLL FLOAT ,
        @OfficeValueEuro FLOAT ,
        @DailyTaxF NVARCHAR(MAX) ,
        @DailyTaxD FLOAT ,
        @DailyTaxLL FLOAT ,
        @DailyTaxEuro FLOAT ,
        @TotalTaxF NVARCHAR(MAX) ,
        @TotalTaxD FLOAT ,
        @TotalTaxLL FLOAT ,
        @TotalTaxEuro FLOAT ,
        @OfficeValueAfterTaxF NVARCHAR(MAX) ,
        @OfficeValueAfterTaxD FLOAT ,
        @OfficeValueAfterTaxLL FLOAT ,
        @OfficeValueAfterTaxEuro FLOAT ,
        @ProfitF NVARCHAR(MAX) ,
        @ProfitD FLOAT ,
        @ProfitLL FLOAT ,
        @ProfitEuro FLOAT ,
        @OdometerConsumed INT = @CheckInOdometer - @CheckOutOdometer ,
        @DurationInMinutes BIGINT = DATEDIFF(MINUTE, @CheckOutDate, @CheckInDate) ,
        @DurationF NVARCHAR(MAX) = DateTimes.f_DateTimeDiff(@CheckOutDate, @CheckInDate, 'd', 1, '', 'NA') ,
        @TrnID UNIQUEIDENTIFIER ,
        @TrnRef BIGINT ,
        @TrnRN INT ,
        @TrnStatementBase NVARCHAR(MAX) ,
        @TrnStatement NVARCHAR(MAX) ,
        @TrnLinkType TINYINT = 185 ,
        @CID UNIQUEIDENTIFIER ,
        @E DECIMAL(18, 2) ,
        @ELL DECIMAL(18, 2) ,
        @EEuro DECIMAL(18, 2) ,
        @V FLOAT ,
        @return INT = 0;

    END;

    BEGIN --Set info

      SELECT  @Ref = COALESCE(MAX(o.Ref), 0) + 1
      FROM    ( SELECT  s.Ref
                FROM    Cars.t_CarRental AS s
                UNION ALL
                SELECT  s.Ref
                FROM    Cars.t_CarRentalHistory AS s
              ) AS o;
      SET @RefF = FORMAT(@Ref, 'n0');
      SET @TrnStatementBase = N'CR:' + @RefF;
      SET @Account = Company.f_AccountGetName(@AccountID);
      SET @AccountNumberF = Company.f_AccountGetNumberF(@AccountID);
      SET @AccountBox = Company.f_AccountGetName(@AccountBoxID);
      SET @AccountBoxNumberF = Company.f_AccountGetNumberF(@AccountBoxID);
      SET @Car = Cars.f_CarGetName(@CarID);
    
      SET @Currency = Currencys.f_CurrencyGetName(@CurrencyID);
      SET @CID = @CurrencyID;
      SET @E = @ExchangeRate;
      SET @ELL = @ExchangeRateLL;
      SET @EEuro = @ExchangeRateEuro;

      SET @DayPriceF = Currencys.f_Format(@CID, @DayPrice);
      SET @DayPriceD = @DayPrice / @E;
      SET @DayPriceLL = @DayPriceD * @ELL;
      SET @DayPriceEuro = @DayPriceD * @EEuro;

      SET @DayTotalPriceF = Currencys.f_Format(@CID, @DayTotalPrice);
      SET @DayTotalPriceD = @DayTotalPrice / @E;
      SET @DayTotalPriceLL = @DayTotalPriceD * @ELL;
      SET @DayTotalPriceEuro = @DayTotalPriceD * @EEuro;

      SET @WeekPriceF = Currencys.f_Format(@CID, @WeekPrice);
      SET @WeekPriceD = @WeekPrice / @E;
      SET @WeekPriceLL = @WeekPriceD * @ELL;
      SET @WeekPriceEuro = @WeekPriceD * @ExchangeRateEuro;

      SET @WeekTotalPriceF = Currencys.f_Format(@CID, @WeekTotalPrice);
      SET @WeekTotalPriceD = @WeekTotalPrice / @E;
      SET @WeekTotalPriceLL = @WeekTotalPriceD * @ELL;
      SET @WeekTotalPriceEuro = @WeekTotalPriceD * @EEuro;

      SET @MonthPriceF = Currencys.f_Format(@CID, @MonthPrice);
      SET @MonthPriceD = @MonthPrice / @E;
      SET @MonthPriceLL = @MonthPriceD * @ELL;
      SET @MonthPriceEuro = @MonthPriceD * @EEuro;

      SET @MonthTotalPriceF = Currencys.f_Format(@CID, @MonthTotalPrice);
      SET @MonthTotalPriceD = @MonthTotalPrice / @E;
      SET @MonthTotalPriceLL = @MonthTotalPriceD * @ELL;
      SET @MonthTotalPriceEuro = @MonthTotalPriceD * @EEuro;

      SET @SubtotalF = Currencys.f_Format(@CID, @Subtotal);
      SET @SubtotalD = @Subtotal / @E;
      SET @SubtotalLL = @SubtotalD * @ELL;
      SET @SubtotalEuro = @SubtotalD * @EEuro;

      SET @DiscountF = Currencys.f_Format(@CID, @Discount);
      SET @DiscountD = @Discount / @E;
      SET @DiscountLL = @DiscountD * @ELL;
      SET @DiscountEuro = @DiscountD * @EEuro;

      SET @TotalF = Currencys.f_Format(@CID, @Total);
      SET @TotalD = @Total / @E;
      SET @TotalLL = @TotalD * @ELL;
      SET @TotalEuro = @TotalD * @EEuro;

      SET @FirstPaymentF = Currencys.f_Format(@CID, @FirstPayment);
      SET @FirstPaymentD = @FirstPayment / @E;
      SET @FirstPaymentLL = @FirstPaymentD * @ELL;
      SET @FirstPaymentEuro = @FirstPaymentD * @EEuro;

      SET @PaidUpF = Currencys.f_Format(@CID, @PaidUp);
      SET @PaidUpD = @PaidUp / @E;
      SET @PaidUpLL = @PaidUpD * @ELL;
      SET @PaidUpEuro = @PaidUpD * @EEuro;

      SET @RestF = Currencys.f_Format(@CID, @Rest);
      SET @RestD = @Rest / @E;
      SET @RestLL = @RestD * @ELL;
      SET @RestEuro = @RestD * @EEuro;
    
      SET @OfficeValueF = Currencys.f_Format(@CID, @OfficeValue);
      SET @OfficeValueD = @OfficeValue / @E;
      SET @OfficeValueLL = @OfficeValueD * @ELL;
      SET @OfficeValueEuro = @OfficeValueD * @EEuro;
	  
      SET @DailyTaxF = Currencys.f_Format(@CID, @DailyTax);
      SET @DailyTaxD = @DailyTax / @E;
      SET @DailyTaxLL = @DailyTaxD * @ELL;
      SET @DailyTaxEuro = @DailyTaxD * @EEuro;

      SET @TotalTaxF = Currencys.f_Format(@CID, @TotalTax);
      SET @TotalTaxD = @TotalTax / @E;
      SET @TotalTaxLL = @TotalTaxD * @ELL;
      SET @TotalTaxEuro = @TotalTaxD * @EEuro;
    
      SET @OfficeValueAfterTaxF = Currencys.f_Format(@CID, @OfficeValueAfterTax);
      SET @OfficeValueAfterTaxD = @OfficeValueAfterTax / @E;
      SET @OfficeValueAfterTaxLL = @OfficeValueAfterTaxD * @ELL;
      SET @OfficeValueAfterTaxEuro = @OfficeValueAfterTaxD * @EEuro;

      SET @ProfitF = Currencys.f_Format(@CID, @Profit);
      SET @ProfitD = @Profit / @E;
      SET @ProfitLL = @ProfitD * @ELL;
      SET @ProfitEuro = @ProfitD * @EEuro;

      INSERT  INTO @CarRentalOwner_
              ( ID ,
                CarRentalID ,
                OwnerProfileID ,
                OwnerProfile ,
                ProfitRatio ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  s.ID ,
              @ID ,
              s.OwnerProfileID ,
              Cars.f_CarOwnersProfileGetName(s.OwnerProfileID) ,
              s.ProfitRatio ,
              s.Profit ,
              Currencys.f_Format(@CID, s.Profit) ,
              s.Profit / @E ,
              ( s.Profit / @E ) * @ELL ,
              ( s.Profit / @E ) * @EEuro
      FROM    @CarRentalOwner AS s;

    END;

    BEGIN --Insert

      INSERT  INTO Cars.t_CarRental
              ( ID ,
                Ref ,
                RefF ,
                PaperRef ,
                AccountID ,
                Account ,
                AccountNumberF ,
                AccountBoxID ,
                AccountBox ,
                AccountBoxNumberF ,
                CarID ,
                Car ,
                AgreementDate ,
                FromDate ,
                ToDate ,
                CurrencyID ,
                Currency ,
                ExchangeRate ,
                ExchangeRateLL ,
                ExchangeRateEuro ,
                DayPrice ,
                DayPriceF ,
                DayPriceD ,
                DayPriceLL ,
                DayPriceEuro ,
                DayQty ,
                DayTotalPrice ,
                DayTotalPriceF ,
                DayTotalPriceD ,
                DayTotalPriceLL ,
                DayTotalPriceEuro ,
                WeekPrice ,
                WeekPriceF ,
                WeekPriceD ,
                WeekPriceLL ,
                WeekPriceEuro ,
                WeekQty ,
                WeekTotalPrice ,
                WeekTotalPriceF ,
                WeekTotalPriceD ,
                WeekTotalPriceLL ,
                WeekTotalPriceEuro ,
                MonthPrice ,
                MonthPriceF ,
                MonthPriceD ,
                MonthPriceLL ,
                MonthPriceEuro ,
                MonthQty ,
                MonthTotalPrice ,
                MonthTotalPriceF ,
                MonthTotalPriceD ,
                MonthTotalPriceLL ,
                MonthTotalPriceEuro ,
                Subtotal ,
                SubtotalF ,
                SubtotalD ,
                SubtotalLL ,
                SubtotalEuro ,
                Discount ,
                DiscountF ,
                DiscountD ,
                DiscountLL ,
                DiscountEuro ,
                Total ,
                TotalF ,
                TotalD ,
                TotalLL ,
                TotalEuro ,
                PaymentMethod ,
                FirstPayment ,
                FirstPaymentF ,
                FirstPaymentD ,
                FirstPaymentLL ,
                FirstPaymentEuro ,
                PaidUp ,
                PaidUpF ,
                PaidUpD ,
                PaidUpLL ,
                PaidUpEuro ,
                Rest ,
                RestF ,
                RestD ,
                RestLL ,
                RestEuro ,
                Paid ,
                OfficeRatio ,
                OfficeValue ,
                OfficeValueF ,
                OfficeValueD ,
                OfficeValueLL ,
                OfficeValueEuro ,
                DailyTax ,
                DailyTaxF ,
                DailyTaxD ,
                DailyTaxLL ,
                DailyTaxEuro ,
                TotalTax ,
                TotalTaxF ,
                TotalTaxD ,
                TotalTaxLL ,
                TotalTaxEuro ,
                TaxRate ,
                PaidTax ,
                OfficeValueAfterTax ,
                OfficeValueAfterTaxF ,
                OfficeValueAfterTaxD ,
                OfficeValueAfterTaxLL ,
                OfficeValueAfterTaxEuro ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                CheckOutDate ,
                CheckOutFuel ,
                CheckOutOdometer ,
                CheckInDate ,
                CheckInFuel ,
                CheckInOdometer ,
                DurationInMinutes ,
                DurationF ,
                OdometerConsumed ,
                StatusIs ,
                DescriptionIs ,
                Notes
              )
      VALUES  ( @ID ,
                @Ref ,
                @RefF ,
                @PaperRef ,
                @AccountID ,
                @Account ,
                @AccountNumberF ,
                @AccountBoxID ,
                @AccountBox ,
                @AccountBoxNumberF ,
                @CarID ,
                @Car ,
                @AgreementDate ,
                @FromDate ,
                @ToDate ,
                @CurrencyID ,
                @Currency ,
                @ExchangeRate ,
                @ExchangeRateLL ,
                @ExchangeRateEuro ,
                @DayPrice ,
                @DayPriceF ,
                @DayPriceD ,
                @DayPriceLL ,
                @DayPriceEuro ,
                @DayQty ,
                @DayTotalPrice ,
                @DayTotalPriceF ,
                @DayTotalPriceD ,
                @DayTotalPriceLL ,
                @DayTotalPriceEuro ,
                @WeekPrice ,
                @WeekPriceF ,
                @WeekPriceD ,
                @WeekPriceLL ,
                @WeekPriceEuro ,
                @WeekQty ,
                @WeekTotalPrice ,
                @WeekTotalPriceF ,
                @WeekTotalPriceD ,
                @WeekTotalPriceLL ,
                @WeekTotalPriceEuro ,
                @MonthPrice ,
                @MonthPriceF ,
                @MonthPriceD ,
                @MonthPriceLL ,
                @MonthPriceEuro ,
                @MonthQty ,
                @MonthTotalPrice ,
                @MonthTotalPriceF ,
                @MonthTotalPriceD ,
                @MonthTotalPriceLL ,
                @MonthTotalPriceEuro ,
                @Subtotal ,
                @SubtotalF ,
                @SubtotalD ,
                @SubtotalLL ,
                @SubtotalEuro ,
                @Discount ,
                @DiscountF ,
                @DiscountD ,
                @DiscountLL ,
                @DiscountEuro ,
                @Total ,
                @TotalF ,
                @TotalD ,
                @TotalLL ,
                @TotalEuro ,
                @PaymentMethod ,
                @FirstPayment ,
                @FirstPaymentF ,
                @FirstPaymentD ,
                @FirstPaymentLL ,
                @FirstPaymentEuro ,
                @PaidUp ,
                @PaidUpF ,
                @PaidUpD ,
                @PaidUpLL ,
                @PaidUpEuro ,
                @Rest ,
                @RestF ,
                @RestD ,
                @RestLL ,
                @RestEuro ,
                @Paid ,
                @OfficeRatio ,
                @OfficeValue ,
                @OfficeValueF ,
                @OfficeValueD ,
                @OfficeValueLL ,
                @OfficeValueEuro ,
                @DailyTax ,
                @DailyTaxF ,
                @DailyTaxD ,
                @DailyTaxLL ,
                @DailyTaxEuro ,
                @TotalTax ,
                @TotalTaxF ,
                @TotalTaxD ,
                @TotalTaxLL ,
                @TotalTaxEuro ,
                @TaxRate ,
                IIF(@TotalTax = 0, 1, 0) ,
                @OfficeValueAfterTax ,
                @OfficeValueAfterTaxF ,
                @OfficeValueAfterTaxD ,
                @OfficeValueAfterTaxLL ,
                @OfficeValueAfterTaxEuro ,
                @Profit ,
                @ProfitF ,
                @ProfitD ,
                @ProfitLL ,
                @ProfitEuro ,
                @CheckOutDate ,
                @CheckOutFuel ,
                @CheckOutOdometer ,
                @CheckInDate ,
                @CheckInFuel ,
                @CheckInOdometer ,
                @DurationInMinutes ,
                @DurationF ,
                @OdometerConsumed ,
                @StatusIs ,
                @DescriptionIs ,
                @Notes
              );
  
      UPDATE  Cars.t_CarRental
      SET     SearchText = ''
      WHERE   ID = @ID;

    END;

    BEGIN --Insert t_CarRentalOwner

      INSERT  INTO Cars.t_CarRentalOwner
              ( ID ,
                CarRentalID ,
                OwnerProfileID ,
                OwnerProfile ,
                ProfitRatio ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro
              )
      SELECT  s.ID ,
              s.CarRentalID ,
              s.OwnerProfileID ,
              s.OwnerProfile ,
              s.ProfitRatio ,
              s.Profit ,
              s.ProfitF ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro
      FROM    @CarRentalOwner_ AS s;

      UPDATE  Cars.t_CarRentalOwner
      SET     SearchText = ''
      WHERE   CarRentalID = @ID;

    END;

    BEGIN --Insert t_CarRentalDriver

      INSERT  INTO Cars.t_CarRentalDriver
              ( ID ,
                CarRentalID ,
                CarDriverID ,
                CarDriver 
              )
      SELECT  s.ID ,
              @ID ,
              s.CarDriverID ,
              Cars.f_CarDriverGetName(s.CarDriverID)
      FROM    @CarRentalDriver AS s;

      UPDATE  Cars.t_CarRentalDriver
      SET     SearchText = ''
      WHERE   CarRentalID = @ID;

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
                @ID ,
                @Event + N': ' + @RefF ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;
 
    IF @Total > 0 --t_Transaction
    BEGIN 

      DELETE  FROM @IDs;

      BEGIN --Set info

        SET @return = 0;

        SELECT  @TrnRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'JV';
    
      END;

      BEGIN --Insert t_Transaction

        INSERT  INTO Transactions.t_Transaction
                ( Ref ,
                  TypeIs ,
                  DateIs ,
                  DescriptionIs ,
                  LinkType ,
                  LinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TrnRef ,
                  N'JV' ,
                  @DateIs ,
                  @TrnStatementBase ,
                  @TrnLinkType ,
                  @ID ,
                  @UserID
                );

        SET @TrnID = ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       ORDER BY s.ID
                     );
	
        INSERT  @TrnIDs
                ( ID, RefF )
        VALUES  ( @TrnID, FORMAT(@TrnRef, 'n0') );

      END;  

      BEGIN --t_TransactionDetail

        SET @V = @Total;
        SET @TrnRN = 1;
        SET @TrnStatement = @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
		
        IF @TotalTax > 0
        BEGIN 

          SET @V = @Total - @TotalTax;
          SET @TrnRN += 1;
          SET @TrnStatement = @TrnStatementBase + ' \ ' + @Account;
          EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountSellTaxableID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

          SET @V = @TotalTax;
          SET @TrnRN += 1;
          SET @TrnStatement = @TrnStatementBase;
          EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountTaxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
		
        END;
        ELSE
        BEGIN

          SET @TrnRN += 1;
          SET @TrnStatement = @TrnStatementBase + ' \ ' + @Account;
          EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountSellNonTaxableID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

        END;

      END;

    END;

    IF @FirstPayment > 0 --t_Transaction
    BEGIN 

      DELETE  FROM @IDs;

      BEGIN --Set info

        SET @return = 0;

        SELECT  @TrnRef = ISNULL(MAX(s.Ref), 0) + 1
        FROM    Transactions.t_Transaction AS s
        WHERE   s.TypeIs = N'RV';

      END;

      BEGIN --t_Transaction

        INSERT  INTO Transactions.t_Transaction
                ( Ref ,
                  TypeIs ,
                  DateIs ,
                  DescriptionIs ,
                  LinkType ,
                  LinkID ,
                  UserID
                )
        OUTPUT  Inserted.ID
                INTO @IDs ( ID )
        VALUES  ( @TrnRef ,
                  N'RV' ,
                  @DateIs ,
                  @TrnStatementBase ,
                  @TrnLinkType ,
                  @ID ,
                  @UserID
                );

        SET @TrnID = ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @IDs AS s
                       ORDER BY s.ID
                     );

        INSERT  @TrnIDs
                ( ID, RefF )
        VALUES  ( @TrnID, FORMAT(@TrnRef, 'n0') );

      END;

      BEGIN --t_TransactionDetail

        SET @V = @FirstPayment;
        SET @TrnRN = 1;
        SET @TrnStatement = @TrnStatementBase + ' \ ' + @Account;
        EXECUTE Transactions.s_TransactionDetailInsertDebit @TrnRN, @TrnID, @AccountBoxID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;
		
        SET @TrnRN += 1;
        SET @TrnStatement = @TrnStatementBase;
        EXECUTE Transactions.s_TransactionDetailInsertCredit @TrnRN, @TrnID, @AccountID, @DateIs, @CID, @V, @E, @ELL, @EEuro, @TrnStatement;

      END;

    END;

    BEGIN --Update t_Account, t_Transaction

      UPDATE  Company.t_Account
      SET     StatusIs = 0 ,
              LastAction = GETDATE()
      WHERE   ID IN ( @AccountID, @AccountBoxID, @AccountSellNonTaxableID, @AccountTaxID, @AccountSellTaxableID )
              AND StatusIs = 1;
               
      UPDATE  Transactions.t_Transaction
      SET     RefF = FORMAT(Ref, 'n0') ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              AccountsNames = Alls.f_FixXML(( SELECT DISTINCT
                                                      ', ' + t.Account AS [text()]
                                              FROM    Transactions.t_TransactionDetail AS t
                                              WHERE   t.TransactionID = @TrnID
                                            FOR
                                              XML PATH('')
                                            )) ,
              BalanceD = COALESCE(( SELECT  SUM(s.Balance)
                                    FROM    Transactions.t_TransactionDetail AS s
                                    WHERE   s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 0
                                            AND s.Balance > 0
                                  ), 0) ,
              BalanceLL = COALESCE(( SELECT SUM(s.Balance)
                                     FROM   Transactions.t_TransactionDetail AS s
                                     WHERE  s.TransactionID = t_Transaction.ID
                                            AND s.CurrencyTypeIs = 1
                                            AND s.Balance > 0
                                   ), 0) ,
              BalanceEuro = COALESCE(( SELECT SUM(s.Balance)
                                       FROM   Transactions.t_TransactionDetail AS s
                                       WHERE  s.TransactionID = t_Transaction.ID
                                              AND s.CurrencyTypeIs = 2
                                              AND s.Balance > 0
                                     ), 0) ,
              UserIs = Users.f_UserGetName(UserID)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @TrnIDs AS s
                       WHERE  s.ID = t_Transaction.ID );

      UPDATE  Transactions.t_TransactionDetail
      SET     Account = Company.f_AccountGetName(AccountID) ,
              DateOnly = DateIs ,
              DateFirstDayInMonth = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
              DateFirstDayInYear = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              CurrencyTypeIs = Currencys.f_CurrencyGetTypeIs(CurrencyID) ,
              BalanceF = Currencys.f_Format(CurrencyID, Balance) ,
              BalanceAR = Currencys.f_ToWordAR(Balance, CurrencyID, 1) ,
              BalanceEN = Currencys.f_ToWordEN(Balance, CurrencyID, 1)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   @TrnIDs AS s
                       WHERE  s.ID = t_TransactionDetail.TransactionID );

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
              @Event + s.RefF ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @TrnIDs AS s;

    END;

    BEGIN --Update t_Car

      UPDATE  Cars.t_Car
      SET     Odometer = IIF(@StatusIs = 2
              AND @CheckInOdometer > 0, @CheckInOdometer, Odometer) ,
              AvailabilityIs = Cars.f_CarGetAvailabilityIsNow(ID) ,
              CarRentalCount += 1 ,
              TotalCarRentsD += @TotalD ,
              TotalCarRentsLL += @TotalLL ,
              TotalCarRentsEuro += @TotalEuro ,
              ProfitCarRentsD += @ProfitD ,
              ProfitCarRentsLL += @ProfitLL ,
              ProfitCarRentsEuro += @ProfitEuro
      WHERE   ID = @CarID;

      UPDATE  Cars.t_Car
      SET     ProfitD = ProfitCarRentsD - TotalExpensesD ,
              ProfitLL = ProfitCarRentsLL - TotalExpensesLL ,
              ProfitEuro = ProfitCarRentsEuro - TotalExpensesEuro
      WHERE   ID = @CarID;

    END;

    BEGIN --Update t_CarOwnersProfile

      UPDATE  Cars.t_CarOwnersProfile
      SET     CarRentalCount += ( SELECT  COUNT(*)
                                  FROM    @CarRentalOwner_ AS s
                                  WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                ) ,
              TotalProfitD += ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                FROM    @CarRentalOwner_ AS s
                                WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                              ) ,
              TotalProfitLL += ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                 FROM   @CarRentalOwner_ AS s
                                 WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                               ) ,
              TotalProfitEuro += ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                   FROM   @CarRentalOwner_ AS s
                                   WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                 ) ,
              CarRentalUnpaidCount += ( SELECT  COUNT(*)
                                        FROM    @CarRentalOwner_ AS s
                                        WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                      ) ,
              UnpaidTotalProfitD += ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                      FROM    @CarRentalOwner_ AS s
                                      WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                    ) ,
              UnpaidTotalProfitLL += ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                       FROM   @CarRentalOwner_ AS s
                                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                     ) ,
              UnpaidTotalProfitEuro += ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                         FROM   @CarRentalOwner_ AS s
                                         WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                       )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.OwnerProfileID
                       FROM   @CarRentalOwner_ AS s
                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID );

    END;

    BEGIN --Update t_CarDriver

      UPDATE  Cars.t_CarDriver
      SET     CarRentalCount += ( SELECT  COUNT(*)
                                  FROM    @CarRentalDriver AS s
                                  WHERE   s.CarDriverID = t_CarDriver.ID
                                )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.CarDriverID
                       FROM   @CarRentalDriver AS s
                       WHERE  s.CarDriverID = t_CarDriver.ID );

    END;

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics
      SET     CarsAvailabilityAvailable = ( SELECT  COUNT(*)
                                            FROM    Cars.t_Car AS s
                                            WHERE   s.AvailabilityIs = 0
                                          ) ,
              CarsAvailabilityUnavailable = ( SELECT  COUNT(*)
                                              FROM    Cars.t_Car AS s
                                              WHERE   s.AvailabilityIs = 1
                                            ) ,
              Rentals += 1 ,
              RentalsSubtotalD += @SubtotalD ,
              RentalsSubtotalLL += @SubtotalLL ,
              RentalsSubtotalEuro += @SubtotalEuro ,
              RentalsDiscountD += @DiscountD ,
              RentalsDiscountLL += @DiscountLL ,
              RentalsDiscountEuro += @DiscountEuro ,
              RentalsTotalD += @TotalD ,
              RentalsTotalLL += @TotalLL ,
              RentalsTotalEuro += @TotalEuro ,
              RentalsTotalTaxD += @TotalTaxD ,
              RentalsTotalTaxLL += @TotalTaxLL ,
              RentalsTotalTaxEuro += @TotalTaxEuro ,
              RentalsProfitD += @ProfitD ,
              RentalsProfitLL += @ProfitLL ,
              RentalsProfitEuro += @ProfitEuro;
   
      UPDATE  Cars.t_CarRentalStatistics
      SET     ProfitD = RentalsProfitD - ExpensesTotalD ,
              ProfitLL = RentalsProfitLL - ExpensesTotalLL ,
              ProfitEuro = RentalsProfitEuro - ExpensesTotalEuro;

    END;

    BEGIN --Fix t_ProfitDaily

      EXECUTE Invoices.s_ProfitDailyCarRentalMergePART @DateIs, @TotalD, @TotalLL, @TotalEuro; 
	  
    END;

    COMMIT TRANSACTION;

    SELECT  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    SELECT  @return;

  END CATCH;

END;




GO
