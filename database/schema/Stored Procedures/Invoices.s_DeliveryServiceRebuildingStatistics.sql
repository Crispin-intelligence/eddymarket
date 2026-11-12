SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Invoices].[s_DeliveryServiceRebuildingStatistics]
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

            DISABLE TRIGGER Invoices.tr_DeliveryService ON Invoices.t_DeliveryService;

            BEGIN --Rebuild statistics

                SET @Return = 0;

                UPDATE  Invoices.t_DeliveryService
                SET     RefF = FORMAT(Ref, 'n0') ,
                        TypeIsAR = Invoices.f_DeliveryServiceGetTypeIsAR(TypeIs) ,
                        TypeIsEN = Invoices.f_DeliveryServiceGetTypeIsEN(TypeIs) ,
                        StatusIsAR = Invoices.f_DeliveryServiceGetStatusIsAR(StatusIs) ,
                        StatusIsEN = Invoices.f_DeliveryServiceGetStatusIsEN(StatusIs) ,
                        UserIs = Users.f_UserGetName(UserID) ,
                        AccountVendor = Company.f_AccountGetName(AccountVendorID) ,
                        CostCurrency = Currencys.f_CurrencyGetName(CostCurrencyID) ,
                        CostF = Currencys.f_Format(CostCurrencyID, Cost) ,
                        PaymentF = Currencys.f_Format(CostCurrencyID, Payment) ,
                        RestF = Currencys.f_Format(CostCurrencyID, Rest) ,
                        AccountCustomer = Company.f_AccountGetName(AccountCustomerID) ,
                        DeliveryChargeCurrency = Currencys.f_CurrencyGetName(DeliveryChargeCurrencyID) ,
                        DeliveryChargeF = Currencys.f_Format(DeliveryChargeCurrencyID, DeliveryCharge) ,
                        DeliveryChargeStatusAR = Invoices.f_DeliveryServiceGetDeliveryChargeStatusAR(DeliveryChargeStatus) ,
                        DeliveryChargeStatusEN = Invoices.f_DeliveryServiceGetDeliveryChargeStatusEN(DeliveryChargeStatus) ,
                        AccountEmployee = Company.f_AccountGetName(AccountEmployeeID) ,
                        ExpenseF = Currencys.f_Format(DeliveryChargeCurrencyID, Expense) ,
                        ExpenseStatusAR = Invoices.f_DeliveryServiceGetExpenseStatusAR(ExpenseStatus) ,
                        ExpenseStatusEN = Invoices.f_DeliveryServiceGetExpenseStatusEN(ExpenseStatus) ,
                        ProcessIn = CASE WHEN Rest > 0 THEN 0
                                         WHEN DeliveryCharge > 0
                                              AND DeliveryChargeStatus = 0 THEN 0
                                         WHEN Expense > 0
                                              AND ExpenseStatus = 0 THEN 0
                                         ELSE 1
                                    END;

            END;

            BEGIN --Insert event

                SET @Return = -1;

                INSERT  INTO Invoices.t_DeliveryServiceMoving
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
                SET     VersionLive = STUFF(VersionLive, DeliveryService, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
                        SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

            END;

            ENABLE TRIGGER Invoices.tr_DeliveryService ON Invoices.t_DeliveryService;

            COMMIT TRANSACTION;

            RETURN 1;

        END TRY
        BEGIN CATCH

            ROLLBACK;

            RETURN @Return;

        END CATCH;

    END;




GO
