SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_ProfitDailyGymSubscriptionMergePART] @DateIs DATE ,
  @TotalD FLOAT ,
  @TotalLL FLOAT ,
  @TotalEuro FLOAT
AS
BEGIN
  
  BEGIN --Declare
	
    DECLARE @Profit AS TABLE
      (
        DateIs DATE NOT NULL ,
        GymSubscriptionD FLOAT NULL ,
        GymSubscriptionLL FLOAT NULL ,
        GymSubscriptionEuro FLOAT NULL ,
        ProfitD FLOAT NULL ,
        ProfitLL FLOAT NULL ,
        ProfitEuro FLOAT NULL
      );
	  	
  END;

  BEGIN --Set info
	
    INSERT INTO @Profit
        ( DateIs ,
          GymSubscriptionD ,
          GymSubscriptionLL ,
          GymSubscriptionEuro
        )
      VALUES
        ( @DateIs ,
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
               s.GymSubscriptionD ,
               s.GymSubscriptionLL ,
               s.GymSubscriptionEuro ,
               s.GymSubscriptionD ,
               s.GymSubscriptionLL ,
               s.GymSubscriptionEuro
             )
    WHEN MATCHED THEN
      UPDATE SET t.GymSubscriptionD += s.GymSubscriptionD ,
                  t.GymSubscriptionLL += s.GymSubscriptionLL ,
                  t.GymSubscriptionEuro += s.GymSubscriptionEuro ,
                  t.ProfitGrossD += s.GymSubscriptionD ,
                  t.ProfitGrossLL += s.GymSubscriptionLL ,
                  t.ProfitGrossEuro += s.GymSubscriptionEuro;

  END;
  
  RETURN 1;

END;


GO
