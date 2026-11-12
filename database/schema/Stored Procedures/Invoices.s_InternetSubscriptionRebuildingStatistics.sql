SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_InternetSubscriptionRebuildingStatistics]
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

            BEGIN --Rebuild statistics

                SET @Return = 0;

                UPDATE  Invoices.t_InternetSubscription
                SET     Customer = Customers.f_CustomerGetName(CustomerID) ,
                        InternetPackage = Customers.f_InternetPackageGetName(InternetPackageID) ,
                        Currency = Currencys.f_CurrencyGetName(CurrencyID) ,
                        CostF = Currencys.f_Format(CurrencyID, Cost) ,
                        PriceF = Currencys.f_Format(CurrencyID, Price) ,
                        PriceAR = Currencys.f_ToWordAR(Price, CurrencyID, 1) ,
                        PriceEN = Currencys.f_ToWordEN(Price, CurrencyID, 1) ,
                        ProfitF = Currencys.f_Format(CurrencyID, Profit) ,
                        PaidF = Currencys.f_Format(CurrencyID, Paid) ,
                        RestIsF = Currencys.f_Format(CurrencyID, RestIs) ,
                        ProfitCollectedF = Currencys.f_Format(CurrencyID,
                                                              ProfitCollected) ,
                        PatmentStatus = IIF(Paid = 0, 0, IIF(Paid < Price, 1, 2));

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
                          '00000000-0000-0000-0000-000000000000' ,
                          @Event ,
                          6 ,
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
