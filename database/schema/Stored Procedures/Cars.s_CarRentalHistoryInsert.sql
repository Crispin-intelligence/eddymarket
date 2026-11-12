SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRentalHistoryInsert]
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
        @Return INT = 0;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @CarID_Old = s.CarID
      FROM    Cars.t_CarRental AS s
      WHERE   s.ID = @ID;

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
              2 ,
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

      DELETE  FROM Cars.t_CarRentalDriver
      WHERE   CarRentalID = @ID;
    
      DELETE  FROM Cars.t_CarRentalOwner
      WHERE   CarRentalID = @ID;

      DELETE  FROM Cars.t_CarRental
      WHERE   ID = @ID;

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
      SET     AvailabilityIs = Cars.f_CarGetAvailabilityIsNow(ID)
      WHERE   ID = @CarID_Old;

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
