SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_ProfitDailyCarRentalMergePART]
  @DateIs DATE ,
  @TotalD FLOAT ,
  @TotalLL FLOAT ,
  @TotalEuro FLOAT
AS
BEGIN
  
  BEGIN --Declare
	
    DECLARE @Profit AS TABLE
      (
        DateIs DATE NOT NULL ,
        TotalD FLOAT NULL ,
        TotalLL FLOAT NULL ,
        TotalEuro FLOAT NULL ,
        ProfitD FLOAT NULL ,
        ProfitLL FLOAT NULL ,
        ProfitEuro FLOAT NULL
      );
	  	
  END;

  BEGIN --Set info
	
    INSERT  INTO @Profit
            ( DateIs ,
              TotalD ,
              TotalLL ,
              TotalEuro
            )
    VALUES  ( @DateIs ,
              @TotalD ,
              @TotalLL ,
              @TotalEuro
            );
   
  END;
	
  BEGIN --Insert
	
    MERGE Invoices.t_ProfitDaily AS t
    USING @Profit AS s
    ON s.DateIs = t.DateIs
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( DateIs ,
               GymSubscriptionD ,
               GymSubscriptionLL ,
               GymSubscriptionEuro ,
               ProfitGrossD ,
               ProfitGrossLL ,
               ProfitGrossEuro
             )
      VALUES ( s.DateIs ,
               s.TotalD ,
               s.TotalLL ,
               s.TotalEuro ,
               s.TotalD ,
               s.TotalLL ,
               s.TotalEuro
             )
    WHEN MATCHED THEN
      UPDATE SET
               t.CarRentalD += s.TotalD ,
               t.CarRentalLL += s.TotalLL ,
               t.CarRentalEuro += s.TotalEuro ,
               t.ProfitGrossD += s.TotalD ,
               t.ProfitGrossLL += s.TotalLL ,
               t.ProfitGrossEuro += s.TotalEuro;

  END;
  
  RETURN 1;

END;



GO
