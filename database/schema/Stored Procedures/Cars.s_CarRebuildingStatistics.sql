SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRebuildingStatistics]
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

    DISABLE TRIGGER Cars.tr_Car ON Cars.t_Car;
    DISABLE TRIGGER Cars.tr_CarOwners ON Cars.t_CarOwners;

    BEGIN --Rebuild statistics

      SET @Return = 0;

      UPDATE  Cars.t_Car
      SET     FullName = RegistrationNumber + IIF(Color = '', '', ', ' + Color) ,
              Make = Cars.f_CarMakeGetName(MakeID) ,
              Model = Cars.f_CarModelGetName(ModelID) ,
              ClassName = Cars.f_CarClassGetName(ClassID) ,
              AvailabilityIs = Cars.f_CarGetAvailabilityIsNow(ID) ,
              Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
              PurchasePriceF = Currencys.f_Format(CurrencyID, PurchasePrice) ,
              SalePriceF = Currencys.f_Format(CurrencyID, SalePrice) ,
              DayPriceF = Currencys.f_Format(CurrencyID, DayPrice) ,
              WeekPriceF = Currencys.f_Format(CurrencyID, WeekPrice) ,
              MonthPriceF = Currencys.f_Format(CurrencyID, MonthPrice) ,
              CarOwnersCount = ( SELECT COUNT(s.ID)
                                 FROM   Cars.t_CarOwners AS s
                                 WHERE  s.CarID = t_Car.ID
                               ) ,
              CarOwners = Alls.f_FixXML(( SELECT DISTINCT
                                                  ', ' + s1.Name AS [text()]
                                          FROM    Cars.t_CarOwners AS s
                                          INNER JOIN Cars.t_CarOwnersProfile AS s1 ON s1.ID = s.OwnerProfileID
                                          WHERE   s.CarID = t_Car.ID
                                        FOR
                                          XML PATH('')
                                        )) ,
              CarRentalCount = ( SELECT COUNT(*)
                                 FROM   Cars.t_CarRental AS s
                                 WHERE  s.CarID = t_Car.ID
                                        AND s.StatusIs <> 3
                               ) + ( SELECT COUNT(*)
                                     FROM   Cars.t_CarRentalHistory AS s
                                     WHERE  s.CarID = t_Car.ID
                                            AND s.StatusIs <> 3
                                   ) ,
              TotalCarRentsD = ( SELECT ISNULL(SUM(s.TotalD), 0)
                                 FROM   Cars.t_CarRental AS s
                                 WHERE  s.CarID = t_Car.ID
                                        AND s.StatusIs <> 3
                               ) + ( SELECT ISNULL(SUM(s.TotalD), 0)
                                     FROM   Cars.t_CarRentalHistory AS s
                                     WHERE  s.CarID = t_Car.ID
                                            AND s.StatusIs <> 3
                                   ) ,
              TotalCarRentsLL = ( SELECT  ISNULL(SUM(s.TotalLL), 0)
                                  FROM    Cars.t_CarRental AS s
                                  WHERE   s.CarID = t_Car.ID
                                          AND s.StatusIs <> 3
                                ) + ( SELECT  ISNULL(SUM(s.TotalLL), 0)
                                      FROM    Cars.t_CarRentalHistory AS s
                                      WHERE   s.CarID = t_Car.ID
                                              AND s.StatusIs <> 3
                                    ) ,
              TotalCarRentsEuro = ( SELECT  ISNULL(SUM(s.TotalEuro), 0)
                                    FROM    Cars.t_CarRental AS s
                                    WHERE   s.CarID = t_Car.ID
                                            AND s.StatusIs <> 3
                                  ) + ( SELECT  ISNULL(SUM(s.TotalEuro), 0)
                                        FROM    Cars.t_CarRentalHistory AS s
                                        WHERE   s.CarID = t_Car.ID
                                                AND s.StatusIs <> 3
                                      ) ,
              ProfitCarRentsD = ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                  FROM    Cars.t_CarRental AS s
                                  WHERE   s.CarID = t_Car.ID
                                          AND s.StatusIs <> 3
                                ) + ( SELECT  ISNULL(SUM(s.ProfitD), 0)
                                      FROM    Cars.t_CarRentalHistory AS s
                                      WHERE   s.CarID = t_Car.ID
                                              AND s.StatusIs <> 3
                                    ) ,
              ProfitCarRentsLL = ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                   FROM   Cars.t_CarRental AS s
                                   WHERE  s.CarID = t_Car.ID
                                          AND s.StatusIs <> 3
                                 ) + ( SELECT ISNULL(SUM(s.ProfitLL), 0)
                                       FROM   Cars.t_CarRentalHistory AS s
                                       WHERE  s.CarID = t_Car.ID
                                              AND s.StatusIs <> 3
                                     ) ,
              ProfitCarRentsEuro = ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                     FROM   Cars.t_CarRental AS s
                                     WHERE  s.CarID = t_Car.ID
                                            AND s.StatusIs <> 3
                                   ) + ( SELECT ISNULL(SUM(s.ProfitEuro), 0)
                                         FROM   Cars.t_CarRentalHistory AS s
                                         WHERE  s.CarID = t_Car.ID
                                                AND s.StatusIs <> 3
                                       ) ,
              ExpensesCount = ( SELECT  COUNT(s.ID)
                                FROM    Cars.t_CarExpense AS s
                                WHERE   s.CarID = t_Car.ID
                              ) ,
              TotalExpensesD = ( SELECT ISNULL(SUM(s.NetIsD), 0)
                                 FROM   Cars.t_CarExpense AS s
                                 WHERE  s.CarID = t_Car.ID
                               ) ,
              TotalExpensesLL = ( SELECT  ISNULL(SUM(s.NetIsLL), 0)
                                  FROM    Cars.t_CarExpense AS s
                                  WHERE   s.CarID = t_Car.ID
                                ) ,
              TotalExpensesEuro = ( SELECT  ISNULL(SUM(s.NetIsEuro), 0)
                                    FROM    Cars.t_CarExpense AS s
                                    WHERE   s.CarID = t_Car.ID
                                  );
   
      UPDATE  Cars.t_Car
      SET     ProfitD = ProfitCarRentsD - TotalExpensesD ,
              ProfitLL = ProfitCarRentsLL - TotalExpensesLL ,
              ProfitEuro = ProfitCarRentsEuro - TotalExpensesEuro ,
              SearchText = Cars.f_CarSearchTextGet(ID) ,
              IsSync = 0;

    END;

    BEGIN --t_CarOwners
    	   
      UPDATE  Cars.t_CarOwners
      SET     Car = Cars.f_CarGetName(CarID) ,
              OwnerProfile = Cars.f_CarOwnersProfileGetName(OwnerProfileID) ,
              IsSync = 0;

      UPDATE  Cars.t_CarOwners
      SET     SearchText = Cars.f_CarOwnersSearchTextGet(ID);

    END;

    ENABLE TRIGGER Cars.tr_Car ON Cars.t_Car;
    ENABLE TRIGGER Cars.tr_CarOwners ON Cars.t_CarOwners;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Cars.t_CarMoving
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
      SET     VersionLive = STUFF(VersionLive, Car, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
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
