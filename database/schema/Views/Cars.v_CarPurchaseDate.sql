SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarPurchaseDate]
AS
SELECT  t.ID ,
        t.FullName ,
        t.VehicleIdentificationNumber ,
        t.RegistrationNumber ,
        t.Make ,
        t.Model ,
        t.YearIs ,
        t.PurchaseDate ,
        t.CurrencyID ,
        t1.TypeIs AS CurrencyTypeIs ,
        t.PurchasePriceF ,
        t.PurchasePriceD ,
        t.PurchasePriceLL ,
        t.PurchasePriceEuro
FROM    Cars.t_Car AS t
INNER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.CurrencyID;









GO
