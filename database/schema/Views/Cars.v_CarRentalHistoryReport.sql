SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalHistoryReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t2.IDNumber ,
        t2.ID AS CustomerID ,
        t.Account ,
        t2.AddressIs ,
        t2.SalesPerson ,
        t.StatusIs ,
        t.CheckInOdometer ,
        t.CheckOutOdometer ,
        t.OdometerConsumed ,
        t3.Model ,
        t3.VehicleIdentificationNumber ,
        t3.RegistrationNumber ,
        t.AgreementDate ,
        t.FromDate ,
        t.ToDate ,
        t.CheckInDate ,
        t.CurrencyID ,
        t.Total ,
        t.PaidUpF ,
        t.DateCreate
FROM    Cars.t_CarRentalHistory AS t
INNER JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
INNER JOIN Customers.t_Customer AS t2 ON t2.ID = t1.LinkWithID
                                         AND t1.IsMasterLink = 1
INNER JOIN Cars.t_Car AS t3 ON t3.ID = t.CarID;












GO
