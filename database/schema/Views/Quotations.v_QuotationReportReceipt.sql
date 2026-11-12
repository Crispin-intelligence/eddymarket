SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationReportReceipt]
AS
SELECT t.ID,
       t.RefF,
       t.DateIs,
       t1.Name AS Account,
	   t.SubjectIs,
       t2.Title,
	   t2.AddressIs,
       t.CurrencyID,
       t.ExchangeRate,
       t.TotalF,
       t.DiscountIs,
       t.DiscountIsF,
       t.TaxRate,
       t.TaxRateF,
       t.TaxValueF,
       t.NetIsF,
       t.NetIsD,
       t.NetIsLL,
       t.NetIsEuro
FROM Quotations.t_Quotation AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountID
    LEFT JOIN Alls.v_Person AS t2
        ON t1.SectionID = t2.SectionID
           AND t2.ID = t1.LinkWithID;






GO
