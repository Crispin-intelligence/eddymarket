SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [Cars].[s_CarRentalUpdate]
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
  @ResetTransactions BIT ,
  @UserID UNIQUEIDENTIFIER ,
  @EventInsert NVARCHAR(MAX) ,
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
		
      DECLARE @AccountID_Old UNIQUEIDENTIFIER ,
        @CarID_Old UNIQUEIDENTIFIER ,
        @AgreementDate_Old DATE ,
        @SubtotalD_Old FLOAT ,
        @SubtotalLL_Old FLOAT ,
        @SubtotalEuro_Old FLOAT ,
        @DiscountD_Old FLOAT ,
        @DiscountLL_Old FLOAT ,
        @DiscountEuro_Old FLOAT ,
        @TotalD_Old FLOAT ,
        @TotalLL_Old FLOAT ,
        @TotalEuro_Old FLOAT ,
        @TotalTax_Old FLOAT ,
        @TotalTaxD_Old FLOAT ,
        @TotalTaxLL_Old FLOAT ,
        @TotalTaxEuro_Old FLOAT ,
        @PaidTax_Old BIT ,
        @ProfitD_Old FLOAT ,
        @ProfitLL_Old FLOAT ,
        @ProfitEuro_Old FLOAT;
    
      DECLARE @CarRentalOwner_Old AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          OwnerProfileID UNIQUEIDENTIFIER NOT NULL ,
          ProfitD FLOAT NOT NULL ,
          ProfitLL FLOAT NOT NULL ,
          ProfitEuro FLOAT NOT NULL ,
          Paid BIT NOT NULL
        );
     
      DECLARE @CarRentalDriver_Old AS TABLE
        (
          CarDriverID UNIQUEIDENTIFIER
        );

      DECLARE @IDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL
        );

      DECLARE @TrnIDs TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          RefF NVARCHAR(MAX) NOT NULL
        );

      DECLARE @RefF NVARCHAR(MAX) ,
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
        @PaidTax BIT ,
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
  
      DECLARE @CarRentalOwner_New AS TABLE
        (
          ID UNIQUEIDENTIFIER NOT NULL ,
          OwnerProfileID UNIQUEIDENTIFIER NOT NULL ,
          ProfitD FLOAT NOT NULL ,
          ProfitLL FLOAT NOT NULL ,
          ProfitEuro FLOAT NOT NULL ,
          Paid BIT NOT NULL
        );

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @RefF = s.RefF ,
              @AccountID_Old = s.AccountID ,
              @CarID_Old = s.CarID ,
              @AgreementDate_Old = s.AgreementDate ,
              @SubtotalD_Old = s.SubtotalD ,
              @SubtotalLL_Old = s.SubtotalLL ,
              @SubtotalEuro_Old = s.SubtotalEuro ,
              @DiscountD_Old = s.DiscountD ,
              @DiscountLL_Old = s.DiscountLL ,
              @DiscountEuro_Old = s.DiscountEuro ,
              @TotalD_Old = s.TotalD ,
              @TotalLL_Old = s.TotalLL ,
              @TotalEuro_Old = s.TotalEuro ,
              @TotalTax_Old = s.TotalTax ,
              @TotalTaxD_Old = s.TotalTaxD ,
              @TotalTaxLL_Old = s.TotalTaxLL ,
              @TotalTaxEuro_Old = s.TotalTaxEuro ,
              @PaidTax_Old = s.PaidTax ,
              @ProfitD_Old = s.ProfitD ,
              @ProfitLL_Old = s.ProfitLL ,
              @ProfitEuro_Old = s.ProfitEuro
      FROM    Cars.t_CarRental AS s
      WHERE   s.ID = @ID;
   
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

      IF @AccountID = @AccountID_Old
        AND @ResetTransactions = 0
      BEGIN
                                       
        SET @PaidUp += ( SELECT ISNULL(SUM(s.Balance), 0)
                         FROM   Transactions.t_TransactionDetail AS s
                         INNER JOIN Transactions.t_Transaction AS s1 ON s1.ID = s.TransactionID
                         WHERE  s.Balance > 0
                                AND s1.LinkType = @TrnLinkType
                                AND s1.LinkTypeSub = 9
                                AND s1.LinkID = @ID
                       );

        SET @Rest = @Total - @PaidUp;

      END;
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
      SET @PaidTax = IIF(@ResetTransactions = 1, IIF(@TotalTax = 0, 1, 0), IIF(@TotalTax = @TotalTax_Old, @PaidTax_Old, IIF(@TotalTax = 0, 1, 0)));

      SET @OfficeValueAfterTaxF = Currencys.f_Format(@CID, @OfficeValueAfterTax);
      SET @OfficeValueAfterTaxD = @OfficeValueAfterTax / @E;
      SET @OfficeValueAfterTaxLL = @OfficeValueAfterTaxD * @ELL;
      SET @OfficeValueAfterTaxEuro = @OfficeValueAfterTaxD * @EEuro;
  
      SET @ProfitF = Currencys.f_Format(@CID, @Profit);
      SET @ProfitD = @Profit / @E;
      SET @ProfitLL = @ProfitD * @ELL;
      SET @ProfitEuro = @ProfitD * @EEuro;

      INSERT  @CarRentalOwner_Old
              ( ID ,
                OwnerProfileID ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                Paid
              )
      SELECT  s.ID ,
              s.OwnerProfileID ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro ,
              s.Paid
      FROM    Cars.t_CarRentalOwner AS s
      WHERE   s.CarRentalID = @ID;

      INSERT  @CarRentalDriver_Old
              ( CarDriverID 
              )
      SELECT  s.CarDriverID
      FROM    Cars.t_CarRentalDriver AS s
      WHERE   s.CarRentalID = @ID;

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

    BEGIN --Update

      UPDATE  Cars.t_CarRental
      SET     PaperRef = @PaperRef ,
              AccountID = @AccountID ,
              Account = @Account ,
              AccountNumberF = @AccountNumberF ,
              AccountBoxID = @AccountBoxID ,
              AccountBox = @AccountBox ,
              AccountBoxNumberF = @AccountBoxNumberF ,
              CarID = @CarID ,
              Car = @Car ,
              AgreementDate = @AgreementDate ,
              FromDate = @FromDate ,
              ToDate = @ToDate ,
              CurrencyID = @CurrencyID ,
              Currency = @Currency ,
              ExchangeRate = @ExchangeRate ,
              ExchangeRateLL = @ExchangeRateLL ,
              ExchangeRateEuro = @ExchangeRateEuro ,
              DayPrice = @DayPrice ,
              DayPriceF = @DayPriceF ,
              DayPriceD = @DayPriceD ,
              DayPriceLL = @DayPriceLL ,
              DayPriceEuro = @DayPriceEuro ,
              DayQty = @DayQty ,
              DayTotalPrice = @DayTotalPrice ,
              DayTotalPriceF = @DayTotalPriceF ,
              DayTotalPriceD = @DayTotalPriceD ,
              DayTotalPriceLL = @DayTotalPriceLL ,
              DayTotalPriceEuro = @DayTotalPriceEuro ,
              WeekPrice = @WeekPrice ,
              WeekPriceF = @WeekPriceF ,
              WeekPriceD = @WeekPriceD ,
              WeekPriceLL = @WeekPriceLL ,
              WeekPriceEuro = @WeekPriceEuro ,
              WeekQty = @WeekQty ,
              WeekTotalPrice = @WeekTotalPrice ,
              WeekTotalPriceF = @WeekTotalPriceF ,
              WeekTotalPriceD = @WeekTotalPriceD ,
              WeekTotalPriceLL = @WeekTotalPriceLL ,
              WeekTotalPriceEuro = @WeekTotalPriceEuro ,
              MonthPrice = @MonthPrice ,
              MonthPriceF = @MonthPriceF ,
              MonthPriceD = @MonthPriceD ,
              MonthPriceLL = @MonthPriceLL ,
              MonthPriceEuro = @MonthPriceEuro ,
              MonthQty = @MonthQty ,
              MonthTotalPrice = @MonthTotalPrice ,
              MonthTotalPriceF = @MonthTotalPriceF ,
              MonthTotalPriceD = @MonthTotalPriceD ,
              MonthTotalPriceLL = @MonthTotalPriceLL ,
              MonthTotalPriceEuro = @MonthTotalPriceEuro ,
              Subtotal = @Subtotal ,
              SubtotalF = @SubtotalF ,
              SubtotalD = @SubtotalD ,
              SubtotalLL = @SubtotalLL ,
              SubtotalEuro = @SubtotalEuro ,
              Discount = @Discount ,
              DiscountF = @DiscountF ,
              DiscountD = @DiscountD ,
              DiscountLL = @DiscountLL ,
              DiscountEuro = @DiscountEuro ,
              Total = @Total ,
              TotalF = @TotalF ,
              TotalD = @TotalD ,
              TotalLL = @TotalLL ,
              TotalEuro = @TotalEuro ,
              PaymentMethod = @PaymentMethod ,
              FirstPayment = @FirstPayment ,
              FirstPaymentF = @FirstPaymentF ,
              FirstPaymentD = @FirstPaymentD ,
              FirstPaymentLL = @FirstPaymentLL ,
              FirstPaymentEuro = @FirstPaymentEuro ,
              PaidUp = @PaidUp ,
              PaidUpF = @PaidUpF ,
              PaidUpD = @PaidUpD ,
              PaidUpLL = @PaidUpLL ,
              PaidUpEuro = @PaidUpEuro ,
              Rest = @Rest ,
              RestF = @RestF ,
              RestD = @RestD ,
              RestLL = @RestLL ,
              RestEuro = @RestEuro ,
              OfficeRatio = @OfficeRatio ,
              OfficeValue = @OfficeValue ,
              OfficeValueF = @OfficeValueF ,
              OfficeValueD = @OfficeValueD ,
              OfficeValueLL = @OfficeValueLL ,
              OfficeValueEuro = @OfficeValueEuro ,
              DailyTax = @DailyTax ,
              DailyTaxF = @DailyTaxF ,
              DailyTaxD = @DailyTaxD ,
              DailyTaxLL = @DailyTaxLL ,
              DailyTaxEuro = @DailyTaxEuro ,
              TotalTax = @TotalTax ,
              TotalTaxF = @TotalTaxF ,
              TotalTaxD = @TotalTaxD ,
              TotalTaxLL = @TotalTaxLL ,
              TotalTaxEuro = @TotalTaxEuro ,
              TaxRate = @TaxRate ,
              Paid = @Paid ,
              OfficeValueAfterTax = @OfficeValueAfterTax ,
              OfficeValueAfterTaxF = @OfficeValueAfterTaxF ,
              OfficeValueAfterTaxD = @OfficeValueAfterTaxD ,
              OfficeValueAfterTaxLL = @OfficeValueAfterTaxLL ,
              OfficeValueAfterTaxEuro = @OfficeValueAfterTaxEuro ,
              PaidTax = @PaidTax ,
              Profit = @Profit ,
              ProfitF = @ProfitF ,
              ProfitD = @ProfitD ,
              ProfitLL = @ProfitLL ,
              ProfitEuro = @ProfitEuro ,
              CheckOutDate = @CheckOutDate ,
              CheckOutFuel = @CheckOutFuel ,
              CheckOutOdometer = @CheckOutOdometer ,
              CheckInDate = @CheckInDate ,
              CheckInFuel = @CheckInFuel ,
              CheckInOdometer = @CheckInOdometer ,
              DurationInMinutes = @DurationInMinutes ,
              DurationF = @DurationF ,
              OdometerConsumed = @OdometerConsumed ,
              StatusIs = @StatusIs ,
              DescriptionIs = @DescriptionIs ,
              Notes = @Notes
      WHERE   ID = @ID;  

      UPDATE  Cars.t_CarRental
      SET     SearchText = ''
      WHERE   ID = @ID;

    END;

    BEGIN --Insert t_CarRentalOwner

      MERGE Cars.t_CarRentalOwner AS t
      USING @CarRentalOwner_ AS s
      ON s.ID = t.ID AND t.CarRentalID = @ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
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
        VALUES ( s.ID ,
                 s.CarRentalID ,
                 s.OwnerProfileID ,
                 s.OwnerProfile ,
                 s.ProfitRatio ,
                 s.Profit ,
                 s.ProfitF ,
                 s.ProfitD ,
                 s.ProfitLL ,
                 s.ProfitEuro
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.CarRentalID = s.CarRentalID ,
               t.OwnerProfileID = s.OwnerProfileID ,
               t.OwnerProfile = s.OwnerProfile ,
               t.ProfitRatio = s.ProfitRatio ,
               t.Profit = s.Profit ,
               t.ProfitF = s.ProfitF ,
               t.ProfitD = s.ProfitD ,
               t.ProfitLL = s.ProfitLL ,
               t.ProfitEuro = s.ProfitEuro
      WHEN NOT MATCHED BY SOURCE AND t.CarRentalID = @ID THEN
        DELETE;

      INSERT  INTO @CarRentalOwner_New
              ( ID ,
                OwnerProfileID ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                Paid
              )
      SELECT  s.ID ,
              s.OwnerProfileID ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro ,
              s.Paid
      FROM    Cars.t_CarRentalOwner AS s
      WHERE   s.CarRentalID = @ID;

      UPDATE  Cars.t_CarRentalOwner
      SET     SearchText = ''
      WHERE   CarRentalID = @ID;

    END;

    BEGIN --Insert t_CarRentalDriver

      MERGE Cars.t_CarRentalDriver AS t
      USING @CarRentalDriver AS s
      ON s.ID = t.ID
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( ID ,
                 CarRentalID ,
                 CarDriverID ,
                 CarDriver
               )
        VALUES ( s.ID ,
                 @ID ,
                 s.CarDriverID ,
                 Cars.f_CarDriverGetName(s.CarDriverID)
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.CarRentalID = @ID ,
               t.CarDriverID = s.CarDriverID ,
               t.CarDriver = Cars.f_CarDriverGetName(s.CarDriverID)
      WHEN NOT MATCHED BY SOURCE THEN
        DELETE;

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
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;
 
    BEGIN --Delete old transaction

      IF @ResetTransactions = 1
      BEGIN
	                              
        DELETE  FROM Transactions.t_Transaction
        WHERE   LinkType = @TrnLinkType
                AND LinkID = @ID;

      END;
      ELSE
      BEGIN
          
        DELETE  FROM Transactions.t_Transaction
        WHERE   LinkType = @TrnLinkType
                AND LinkTypeSub = 0
                AND LinkID = @ID;

        IF @AccountID <> @AccountID_Old
        BEGIN
    
          DELETE  FROM Transactions.t_Transaction
          WHERE   LinkType = @TrnLinkType
                  AND LinkTypeSub = 9
                  AND LinkID = @ID;

        END;

        IF @TotalTax <> @TotalTax_Old
        BEGIN
    
          DELETE  FROM Transactions.t_Transaction
          WHERE   LinkType = @TrnLinkType
                  AND LinkTypeSub = 10
                  AND LinkID = @ID;

        END;

        DELETE  FROM Transactions.t_Transaction
        WHERE   LinkType = @TrnLinkType
                AND EXISTS ( SELECT TOP ( 1 )
                                    o.ID
                             FROM   ( SELECT  s.ID
                                      FROM    @CarRentalOwner_Old AS s
                                      EXCEPT
                                      SELECT  s.ID
                                      FROM    @CarRentalOwner_New AS s
                                    ) AS o
                             WHERE  t_Transaction.SubLinkID = o.ID )
                AND LinkTypeSub = 11;

      END;

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
              @TrnID ,
              @EventInsert + s.RefF ,
              @EventType ,
              @ComputerIP ,
              @Computer ,
              @ComputerAccount
      FROM    @TrnIDs AS s;

    END;

    BEGIN --Update t_Car

      UPDATE  Cars.t_Car
      SET     AvailabilityIs = Cars.f_CarGetAvailabilityIsNow(ID) ,
              CarRentalCount -= 1 ,
              TotalCarRentsD -= @TotalD_Old ,
              TotalCarRentsLL -= @TotalLL_Old ,
              TotalCarRentsEuro -= @TotalEuro_Old ,
              ProfitCarRentsD -= @ProfitD_Old ,
              ProfitCarRentsLL -= @ProfitLL_Old ,
              ProfitCarRentsEuro -= @ProfitEuro_Old
      WHERE   ID = @CarID_Old;

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
      WHERE   ID IN ( @CarID_Old, @CarID );

    END;

    BEGIN --Update t_CarOwnersProfile

      UPDATE  Cars.t_CarOwnersProfile
      SET     CarRentalCount -= ( SELECT  COUNT(*)
                                  FROM    @CarRentalOwner_Old AS s
                                  WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                ) ,
              TotalProfitD -= ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                FROM    @CarRentalOwner_Old AS s
                                WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                              ) ,
              TotalProfitLL -= ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                 FROM   @CarRentalOwner_Old AS s
                                 WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                               ) ,
              TotalProfitEuro -= ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                   FROM   @CarRentalOwner_Old AS s
                                   WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                 ) ,
              CarRentalUnpaidCount -= ( SELECT  COUNT(*)
                                        FROM    @CarRentalOwner_Old AS s
                                        WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                      ) ,
              UnpaidTotalProfitD -= ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                      FROM    @CarRentalOwner_Old AS s
                                      WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s.Paid = 0
                                    ) ,
              UnpaidTotalProfitLL -= ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                       FROM   @CarRentalOwner_Old AS s
                                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s.Paid = 0
                                     ) ,
              UnpaidTotalProfitEuro -= ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                         FROM   @CarRentalOwner_Old AS s
                                         WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                                AND s.Paid = 0
                                       )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.OwnerProfileID
                       FROM   @CarRentalOwner_Old AS s
                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID );

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
                                      FROM    @CarRentalOwner_New AS s
                                      WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s.Paid = 0
                                    ) ,
              UnpaidTotalProfitLL += ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                       FROM   @CarRentalOwner_New AS s
                                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                              AND s.Paid = 0
                                     ) ,
              UnpaidTotalProfitEuro += ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                         FROM   @CarRentalOwner_New AS s
                                         WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID
                                                AND s.Paid = 0
                                       )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.OwnerProfileID
                       FROM   @CarRentalOwner_ AS s
                       WHERE  s.OwnerProfileID = t_CarOwnersProfile.ID );

    END;

    BEGIN --Update t_CarDriver

      UPDATE  Cars.t_CarDriver
      SET     CarRentalCount -= ( SELECT  COUNT(*)
                                  FROM    @CarRentalDriver_Old AS s
                                  WHERE   s.CarDriverID = t_CarDriver.ID
                                )
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.CarDriverID
                       FROM   @CarRentalDriver_Old AS s
                       WHERE  s.CarDriverID = t_CarDriver.ID );

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
      SET     Rentals -= 1 ,
              RentalsSubtotalD -= @SubtotalD_Old ,
              RentalsSubtotalLL -= @SubtotalLL_Old ,
              RentalsSubtotalEuro -= @SubtotalEuro_Old ,
              RentalsDiscountD -= @DiscountD_Old ,
              RentalsDiscountLL -= @DiscountLL_Old ,
              RentalsDiscountEuro -= @DiscountEuro_Old ,
              RentalsTotalD -= @TotalD_Old ,
              RentalsTotalLL -= @TotalLL_Old ,
              RentalsTotalEuro -= @TotalEuro_Old ,
              RentalsTotalTaxD -= @TotalTaxD_Old ,
              RentalsTotalTaxLL -= @TotalTaxLL_Old ,
              RentalsTotalTaxEuro -= @TotalTaxEuro_Old ,
              RentalsProfitD -= @ProfitD_Old ,
              RentalsProfitLL -= @ProfitLL_Old ,
              RentalsProfitEuro -= @ProfitEuro_Old;

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

      SET @TotalD_Old = 0 - @TotalD_Old;
      SET @TotalLL_Old = 0 - @TotalLL_Old;
      SET @TotalEuro_Old = 0 - @TotalEuro_Old;

      EXECUTE Invoices.s_ProfitDailyCarRentalMergePART @AgreementDate_Old, @TotalD_Old, @TotalLL_Old, @TotalEuro_Old; 
      EXECUTE Invoices.s_ProfitDailyCarRentalMergePART @AgreementDate, @TotalD, @TotalLL, @TotalEuro; 
	  
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
