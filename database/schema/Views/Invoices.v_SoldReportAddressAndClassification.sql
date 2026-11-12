SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_SoldReportAddressAndClassification]
AS
SELECT t.ID,
       t2.Classification,
	   t2.StatesID,
	   t2.StatesIs,
	   t2.RegionID,
       t2.RegionIs,
	   t2.StreetID,
       t2.Street,
       t.DateOnly,
       t.Qtys,
       t.NetIsD,
       t.NetIsLL,
       t.NetIsEuro,
       t.ProfitD,
       t.ProfitLL,
       t.ProfitEuro
FROM Invoices.t_Sold AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountCustomerID
    LEFT JOIN Alls.v_Person1 AS t2
        ON t2.ID = t1.LinkWithID;



GO
