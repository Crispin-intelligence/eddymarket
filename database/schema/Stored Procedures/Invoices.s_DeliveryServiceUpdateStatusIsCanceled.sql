SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_DeliveryServiceUpdateStatusIsCanceled] @UserID UNIQUEIDENTIFIER ,
  @EventInsert NVARCHAR(MAX) ,
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
			
      DECLARE @CustomerID UNIQUEIDENTIFIER ,
        @return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 ) @CustomerID = s.AccountCustomerID
        FROM Invoices.t_DeliveryService AS s
        WHERE s.ID = @ID;

    END;

    BEGIN --Update

      SET @return = 0;

      UPDATE Invoices.t_DeliveryService
        SET StatusIs = 5 ,
            StatusIsAR = Invoices.f_DeliveryServiceGetStatusIsAR(5) ,
            StatusIsEN = Invoices.f_DeliveryServiceGetStatusIsEN(5)
        WHERE ID = @ID;

    END;

    BEGIN --Insert event

      SET @return = -1;

      INSERT INTO Invoices.t_DeliveryServiceMoving
          ( UserID ,
            SectionID ,
            EventIs ,
            EventType ,
            ComputerIP ,
            Computer ,
            ComputerAccount
          )
        VALUES
          ( @UserID ,
            @ID ,
            @Event ,
            1 ,
            @ComputerIP ,
            @Computer ,
            @ComputerAccount
          );

    END;

    BEGIN --Move to history

      INSERT INTO Invoices.t_DeliveryServiceHistory
          ( ID ,
            Ref ,
            RefF ,
            RefPaper ,
            DateIs ,
            DateOnly ,
            TimeOnly ,
            DateMonthly ,
            DateYearly ,
            TypeIs ,
            TypeIsAR ,
            TypeIsEN ,
            StatusIs ,
            StatusIsAR ,
            StatusIsEN ,
            DescriptionIs ,
            UserID ,
            UserIs ,
            AccountVendorID ,
            AccountVendor ,
            AccountVendorNumber ,
            FromAddress ,
            ItemsNames ,
            CostCurrencyID ,
            CostCurrency ,
            CostExchangeRate ,
            CostExchangeRateLL ,
            CostExchangeRateEuro ,
            Cost ,
            CostF ,
            CostD ,
            CostLL ,
            CostEuro ,
            Payment ,
            PaymentF ,
            PaymentD ,
            PaymentLL ,
            PaymentEuro ,
            Rest ,
            RestF ,
            RestD ,
            RestLL ,
            RestEuro ,
            AccountCustomerID ,
            AccountCustomer ,
            AccountCustomerNumber ,
            AccountCustomerIsVendor ,
            ToAddress ,
            DeliveryDate ,
            DeliveryChargeCurrencyID ,
            DeliveryChargeCurrency ,
            DeliveryChargeExchangeRate ,
            DeliveryChargeExchangeRateLL ,
            DeliveryChargeExchangeRateEuro ,
            DeliveryCharge ,
            DeliveryChargeF ,
            DeliveryChargeD ,
            DeliveryChargeLL ,
            DeliveryChargeEuro ,
            DeliveryChargeStatus ,
            DeliveryChargeStatusAR ,
            DeliveryChargeStatusEN ,
            AccountEmployeeID ,
            AccountEmployee ,
            AccountEmployeeNumber ,
            AssignDate ,
            Expense ,
            ExpenseF ,
            ExpenseD ,
            ExpenseLL ,
            ExpenseEuro ,
            ExpenseStatus ,
            ExpenseStatusAR ,
            ExpenseStatusEN ,
            ExpensePaymentDate ,
            DateCreate ,
            IsSync ,
            WorkStationID
			
          )
          SELECT t.ID ,
              t.Ref ,
              t.RefF ,
              t.RefPaper ,
              t.DateIs ,
              t.DateOnly ,
              t.TimeOnly ,
              t.DateMonthly ,
              t.DateYearly ,
              t.TypeIs ,
              t.TypeIsAR ,
              t.TypeIsEN ,
              t.StatusIs ,
              t.StatusIsAR ,
              t.StatusIsEN ,
              t.DescriptionIs ,
              t.UserID ,
              t.UserIs ,
              t.AccountVendorID ,
              t.AccountVendor ,
              t.AccountVendorNumber ,
              t.FromAddress ,
              t.ItemsNames ,
              t.CostCurrencyID ,
              t.CostCurrency ,
              t.CostExchangeRate ,
              t.CostExchangeRateLL ,
              t.CostExchangeRateEuro ,
              t.Cost ,
              t.CostF ,
              t.CostD ,
              t.CostLL ,
              t.CostEuro ,
              t.Payment ,
              t.PaymentF ,
              t.PaymentD ,
              t.PaymentLL ,
              t.PaymentEuro ,
              t.Rest ,
              t.RestF ,
              t.RestD ,
              t.RestLL ,
              t.RestEuro ,
              t.AccountCustomerID ,
              t.AccountCustomer ,
              t.AccountCustomerNumber ,
              t.AccountCustomerIsVendor ,
              t.ToAddress ,
              t.DeliveryDate ,
              t.DeliveryChargeCurrencyID ,
              t.DeliveryChargeCurrency ,
              t.DeliveryChargeExchangeRate ,
              t.DeliveryChargeExchangeRateLL ,
              t.DeliveryChargeExchangeRateEuro ,
              t.DeliveryCharge ,
              t.DeliveryChargeF ,
              t.DeliveryChargeD ,
              t.DeliveryChargeLL ,
              t.DeliveryChargeEuro ,
              t.DeliveryChargeStatus ,
              t.DeliveryChargeStatusAR ,
              t.DeliveryChargeStatusEN ,
              t.AccountEmployeeID ,
              t.AccountEmployee ,
              t.AccountEmployeeNumber ,
              t.AssignDate ,
              t.Expense ,
              t.ExpenseF ,
              t.ExpenseD ,
              t.ExpenseLL ,
              t.ExpenseEuro ,
              t.ExpenseStatus ,
              t.ExpenseStatusAR ,
              t.ExpenseStatusEN ,
              t.ExpensePaymentDate ,
              t.DateCreate ,
              t.IsSync ,
              t.WorkStationID
            FROM Invoices.t_DeliveryService AS t
            WHERE t.ID = @ID;

    END;

    BEGIN --Delete

      DELETE FROM Invoices.t_DeliveryService
        WHERE ID = @ID;

    END;

    BEGIN --Delete t_Transaction

      DELETE FROM Transactions.t_Transaction
        WHERE LinkType = 162 AND LinkID = @ID;

    END;

    BEGIN --Fix t_Account DeliveryServices

      UPDATE Company.t_Account
        SET DeliveryServicesC = [Invoices].f_DeliveryServiceGetCountByAccountCustomerID(ID) ,
            DeliveryServicesLastDate = [Invoices].f_DeliveryServiceGetLastDateByAccountCustomerID(ID) ,
            DeliveryServicesTotal = [Invoices].[f_DeliveryServiceGetTotalByAccountCustomerID](ID) ,
            DeliveryServicesProfit = [Invoices].[f_DeliveryServiceGetProfitByAccountCustomerID](ID)
        WHERE ID = @CustomerID;

      UPDATE Company.t_Account
        SET DeliveryServicesTotalF = Currencys.f_Format(CurrencyID, DeliveryServicesTotal) ,
            DeliveryServicesProfitF = Currencys.f_Format(CurrencyID, DeliveryServicesProfit)
        WHERE ID = @CustomerID;
		  
    END;

    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @return;

  END CATCH;

END;


GO
