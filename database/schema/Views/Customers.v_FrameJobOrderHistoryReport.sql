SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [Customers].[v_FrameJobOrderHistoryReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.DateIs ,
        t.DateDelivery ,
        t.PriorityLevel ,
        t.Customer ,
		t1.Phones,
        t.Doctor ,
        t.Salesperson ,
        t.AddressIs ,
        t.Focal ,
        t.SphereRight ,
        t.SphereLeft ,
        t.CylinderRight ,
        t.CylinderLeft ,
        t.AxisRight ,
        t.AxisLeft ,
        t.PrismRight ,
        t.PrismLeft ,
        t.BaseRight ,
        t.BaseLeft ,
        t.Addition ,
        t.HeightRight ,
        t.HeightLeft ,
        t.PDRight ,
        t.PDLeft ,
		t.TotalF,
        t.PaymentF ,
        t.RestF ,
        t.CostF ,
        t2.DecimalNumber ,
        t.DescriptionIs
FROM    Customers.t_FrameJobOrderHistory AS t
        LEFT JOIN Customers.t_Customer AS t1 ON t1.ID = t.CustomerID
        LEFT JOIN Currencys.t_Currency AS t2 ON t2.ID = t.CurrencyID;












GO
