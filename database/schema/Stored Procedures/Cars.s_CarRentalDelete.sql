SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRentalDelete]
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

      DECLARE @CarID_Old UNIQUEIDENTIFIER ,
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
        @TotalTaxD_Old FLOAT ,
        @TotalTaxLL_Old FLOAT ,
        @TotalTaxEuro_Old FLOAT ,
        @ProfitD_Old FLOAT ,
        @ProfitLL_Old FLOAT ,
        @ProfitEuro_Old FLOAT ,
        @Return INT;

      DECLARE @CarRentalOwner_Old AS TABLE
        (
          OwnerProfileID UNIQUEIDENTIFIER ,
          ProfitD FLOAT ,
          ProfitLL FLOAT ,
          ProfitEuro FLOAT ,
          Paid BIT
        );
    
      DECLARE @CarRentalDriver_Old AS TABLE
        (
          CarDriverID UNIQUEIDENTIFIER
        );

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
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
              @TotalTaxD_Old = s.TotalTaxD ,
              @TotalTaxLL_Old = s.TotalTaxLL ,
              @TotalTaxEuro_Old = s.TotalTaxEuro ,
              @ProfitD_Old = s.ProfitD ,
              @ProfitLL_Old = s.ProfitLL ,
              @ProfitEuro_Old = s.ProfitEuro
      FROM    Cars.t_CarRental AS s
      WHERE   s.ID = @ID;

      INSERT  @CarRentalOwner_Old
              ( OwnerProfileID ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                Paid
              )
      SELECT  s.OwnerProfileID ,
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

    END;

    BEGIN --Insert
    
      INSERT  INTO Cars.t_CarRentalHistory
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
                Notes ,
                SearchText ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  ID ,
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
              3 ,
              DescriptionIs ,
              Notes ,
              SearchText ,
              DateCreate ,
              IsSync ,
              WorkStationID
      FROM    Cars.t_CarRental
      WHERE   ID = @ID;

      INSERT  INTO Cars.t_CarRentalHistoryDriver
              ( ID ,
                CarRentalHistoryID ,
                CarDriverID ,
                CarDriver ,
                SearchText ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  ID ,
              CarRentalID ,
              CarDriverID ,
              CarDriver ,
              SearchText ,
              DateCreate ,
              IsSync ,
              WorkStationID
      FROM    Cars.t_CarRentalDriver
      WHERE   CarRentalID = @ID;
   
      INSERT  INTO Cars.t_CarRentalHistoryOwner
              ( ID ,
                CarRentalHistoryID ,
                OwnerProfileID ,
                OwnerProfile ,
                ProfitRatio ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                SearchText ,
                DateCreate ,
                IsSync ,
                WorkStationID
              )
      SELECT  ID ,
              CarRentalID ,
              OwnerProfileID ,
              OwnerProfile ,
              ProfitRatio ,
              Profit ,
              ProfitF ,
              ProfitD ,
              ProfitLL ,
              ProfitEuro ,
              SearchText ,
              DateCreate ,
              IsSync ,
              WorkStationID
      FROM    Cars.t_CarRentalOwner
      WHERE   CarRentalID = @ID;

    END;
	
    BEGIN --Delete

      SET @Return = 0;

      DELETE  FROM Cars.t_CarRentalDriver
      WHERE   CarRentalID = @ID;
    
      DELETE  FROM Cars.t_CarRentalOwner
      WHERE   CarRentalID = @ID;

      DELETE  FROM Cars.t_CarRental
      WHERE   ID = @ID;

    END;

    BEGIN --Delete t_Transaction

      DELETE  FROM Transactions.t_Transaction
      WHERE   LinkType = 185
              AND LinkID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

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
      SET     ProfitD = ProfitCarRentsD - TotalExpensesD ,
              ProfitLL = ProfitCarRentsLL - TotalExpensesLL ,
              ProfitEuro = ProfitCarRentsEuro - TotalExpensesEuro
      WHERE   ID = @CarID_Old;

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
              Rentals -= 1 ,
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
      SET     ProfitD = RentalsProfitD - ExpensesTotalD ,
              ProfitLL = RentalsProfitLL - ExpensesTotalLL ,
              ProfitEuro = RentalsProfitEuro - ExpensesTotalEuro;

    END;

    BEGIN --Fix t_ProfitDaily

      SET @TotalD_Old = 0 - @TotalD_Old;
      SET @TotalLL_Old = 0 - @TotalLL_Old;
      SET @TotalEuro_Old = 0 - @TotalEuro_Old;

      EXECUTE Invoices.s_ProfitDailyCarRentalMergePART @AgreementDate_Old, @TotalD_Old, @TotalLL_Old, @TotalEuro_Old; 
	  
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
