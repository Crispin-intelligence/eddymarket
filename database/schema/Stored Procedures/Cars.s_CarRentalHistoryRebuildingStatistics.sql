SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarRentalHistoryRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    DISABLE TRIGGER Cars.tr_CarRentalHistory ON Cars.t_CarRentalHistory;
    DISABLE TRIGGER Cars.tr_CarRentalHistoryDriver ON Cars.t_CarRentalHistoryDriver;
    DISABLE TRIGGER Cars.tr_CarRentalHistoryOwner ON Cars.t_CarRentalHistoryOwner;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Cars.t_CarRentalHistory
      SET     Account = Company.f_AccountGetName(AccountID) ,
              AccountNumberF = Company.f_AccountGetNumberF(AccountID) ,
              AccountBox = Company.f_AccountGetName(AccountBoxID) ,
              AccountBoxNumberF = Company.f_AccountGetNumberF(AccountBoxID) ,
              Car = Cars.f_CarGetName(CarID) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              DayPriceF = Currencys.f_Format(CurrencyID, DayPrice) ,
              DayTotalPriceF = Currencys.f_Format(CurrencyID, DayTotalPrice) ,
              WeekPriceF = Currencys.f_Format(CurrencyID, WeekPrice) ,
              WeekTotalPriceF = Currencys.f_Format(CurrencyID, WeekTotalPrice) ,
              MonthPriceF = Currencys.f_Format(CurrencyID, MonthPrice) ,
              MonthTotalPriceF = Currencys.f_Format(CurrencyID, MonthTotalPrice) ,
              SubtotalF = Currencys.f_Format(CurrencyID, Subtotal) ,
              DiscountF = Currencys.f_Format(CurrencyID, Discount) ,
              TotalF = Currencys.f_Format(CurrencyID, Total) ,
              FirstPaymentF = Currencys.f_Format(CurrencyID, FirstPayment) ,
              PaidUpF = Currencys.f_Format(CurrencyID, PaidUp) ,
              RestF = Currencys.f_Format(CurrencyID, Rest) ,
              OfficeValueF = Currencys.f_Format(CurrencyID, OfficeValue) ,
              DailyTaxF = Currencys.f_Format(CurrencyID, DailyTax) ,
              TotalTaxF = Currencys.f_Format(CurrencyID, TotalTax) ,
              OfficeValueAfterTaxF = Currencys.f_Format(CurrencyID, OfficeValueAfterTax) ,
              ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
              OdometerConsumed = CheckInOdometer - CheckOutOdometer ,
              DurationInMinutes = DATEDIFF(MINUTE, CheckOutDate, CheckInDate) ,
              DurationF = DateTimes.f_DateTimeDiff(CheckOutDate, CheckInDate, 'd', 1, '', 'NA') ,
              IsSync = 0;
   
      UPDATE  Cars.t_CarRentalHistory
      SET     SearchText = Cars.f_CarRentalHistorySearchTextGet(ID);

    END;

    BEGIN --t_CarRentalHistoryDriver
    	   
      UPDATE  Cars.t_CarRentalHistoryDriver
      SET     CarDriver = Cars.f_CarDriverGetName(CarDriverID) ,
              IsSync = 0;

      UPDATE  Cars.t_CarRentalHistoryDriver
      SET     SearchText = Cars.f_CarRentalHistoryDriverSearchTextGet(ID);

    END;

    BEGIN --t_CarRentalHistoryOwner
    	 
      WITH  o AS ( SELECT s.OwnerProfileID ,
                          s.OwnerProfile ,
                          s1.CurrencyID ,
                          s.Profit ,
                          s.ProfitF
                   FROM   Cars.t_CarRentalHistoryOwner AS s
                   INNER JOIN Cars.t_CarRentalHistory AS s1 ON s1.ID = s.CarRentalHistoryID
                 )
        UPDATE  o
        SET     o.OwnerProfile = Cars.f_CarOwnersProfileGetName(o.OwnerProfileID) ,
                o.ProfitF = Currencys.f_Format(o.CurrencyID, o.Profit);

      UPDATE  Cars.t_CarRentalHistoryOwner
      SET     SearchText = Cars.f_CarRentalHistoryOwnerSearchTextGet(ID) ,
              IsSync = 0;

    END;

    ENABLE TRIGGER Cars.tr_CarRentalHistory ON Cars.t_CarRentalHistory;
    ENABLE TRIGGER Cars.tr_CarRentalHistoryDriver ON Cars.t_CarRentalHistoryDriver;
    ENABLE TRIGGER Cars.tr_CarRentalHistoryOwner ON Cars.t_CarRentalHistoryOwner;

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
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    BEGIN --Live

      UPDATE  Alls.t_LiveVersion
      SET     VersionLive = STUFF(VersionLive, CarRentalHistory, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
              SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

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
