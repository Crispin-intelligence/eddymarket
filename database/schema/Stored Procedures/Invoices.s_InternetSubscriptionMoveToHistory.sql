SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_InternetSubscriptionMoveToHistory]
    @UserID UNIQUEIDENTIFIER ,
    @Event NVARCHAR(MAX) ,
    @ComputerIP NVARCHAR(MAX) ,
    @Computer NVARCHAR(MAX) ,
    @ComputerAccount NVARCHAR(MAX) ,
    @ID UNIQUEIDENTIFIER
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            BEGIN --Declare

                DECLARE @Return INT;

            END;

            BEGIN --Insert t_InternetSubscriptionHistory

                SET @Return = 0;

                INSERT  INTO Invoices.t_InternetSubscriptionHistory
                        ( ID ,
                          Ref ,
                          RefF ,
                          DateIs ,
                          DateOnly ,
                          DateMonthly ,
                          DateYearly ,
                          StartFrom ,
                          ActiveTo ,
                          CustomerID ,
                          Customer ,
                          AccountSaleID ,
                          AccountSale ,
                          AccountSaleNumberF ,
                          AccountBoxID ,
                          AccountBox ,
                          AccountBoxNumberF ,
                          InternetPackageID ,
                          InternetPackage ,
                          CurrencyID ,
                          Currency ,
                          ExchangeRate ,
                          Cost ,
                          CostF ,
                          CostD ,
                          CostLL ,
                          CostEuro ,
                          Price ,
                          PriceF ,
                          PriceD ,
                          PriceLL ,
                          PriceEuro ,
                          PriceAR ,
                          PriceEN ,
                          Profit ,
                          ProfitF ,
                          ProfitD ,
                          ProfitLL ,
                          ProfitEuro ,
                          Paid ,
                          PaidF ,
                          PaidD ,
                          PaidLL ,
                          PaidEuro ,
                          RestIs ,
                          RestIsF ,
                          RestIsD ,
                          RestIsLL ,
                          RestIsEuro ,
                          ProfitCollected ,
                          ProfitCollectedF ,
                          ProfitCollectedD ,
                          ProfitCollectedLL ,
                          ProfitCollectedEuro ,
                          PatmentStatus ,
                          DescriptionIs ,
                          DateCreate ,
                          WorkStationID
                        )
                        SELECT  t.ID ,
                                t.Ref ,
                                t.RefF ,
                                t.DateIs ,
                                t.DateOnly ,
                                t.DateMonthly ,
                                t.DateYearly ,
                                t.StartFrom ,
                                t.ActiveTo ,
                                t.CustomerID ,
                                t.Customer ,
                                t.AccountSaleID ,
                                t.AccountSale ,
                                t.AccountSaleNumberF ,
                                t.AccountBoxID ,
                                t.AccountBox ,
                                t.AccountBoxNumberF ,
                                t.InternetPackageID ,
                                t.InternetPackage ,
                                t.CurrencyID ,
                                t.Currency ,
                                t.ExchangeRate ,
                                t.Cost ,
                                t.CostF ,
                                t.CostD ,
                                t.CostLL ,
                                t.CostEuro ,
                                t.Price ,
                                t.PriceF ,
                                t.PriceD ,
                                t.PriceLL ,
                                t.PriceEuro ,
                                t.PriceAR ,
                                t.PriceEN ,
                                t.Profit ,
                                t.ProfitF ,
                                t.ProfitD ,
                                t.ProfitLL ,
                                t.ProfitEuro ,
                                t.Paid ,
                                t.PaidF ,
                                t.PaidD ,
                                t.PaidLL ,
                                t.PaidEuro ,
                                t.RestIs ,
                                t.RestIsF ,
                                t.RestIsD ,
                                t.RestIsLL ,
                                t.RestIsEuro ,
                                t.ProfitCollected ,
                                t.ProfitCollectedF ,
                                t.ProfitCollectedD ,
                                t.ProfitCollectedLL ,
                                t.ProfitCollectedEuro ,
                                t.PatmentStatus ,
                                t.DescriptionIs ,
                                t.DateCreate ,
                                t.WorkStationID
                        FROM    Invoices.t_InternetSubscription AS t
                        WHERE   t.ID = @ID;

            END;

            BEGIN --Delete

                SET @Return = 0;

                DELETE  FROM Invoices.t_InternetSubscription
                WHERE   ID = @ID;

            END;

            BEGIN --Insert event

                SET @Return = -1;

                INSERT  INTO Invoices.t_InternetSubscriptionMoving
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
                          2 ,
                          @ComputerIP ,
                          @Computer ,
                          @ComputerAccount
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
