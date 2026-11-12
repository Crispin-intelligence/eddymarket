SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Quotations].[v_QuotationReport]
AS
SELECT  t.ID ,
        t.RefF ,
        t.RefPaper ,
        t.DateIs ,
        t.AccountID ,
        t2.Name AS Account ,
        t.AccountNumberF ,
        t1.BalanceF ,
        t2.Phones ,
        t2.SocialMedia ,
        t2.AddressIs ,
        t2.Title ,
        t2.NumberCurrency ,
        t.Salesperson + ' ' + t3.Phones AS Salesperson ,
        t.AttentionTo ,
        t.SubjectIs ,
        t.CurrencyID ,
        t.ExchangeRateLL ,
        t.TotalF ,
        t.DiscountIs ,
        t.DiscountIsF ,
        t.TaxRateF ,
        t.TaxValue ,
        t.TaxValueF ,
        t.TaxValueD ,
        t.NetIsF ,
        t.NetIsAR ,
        t.NetIsEN ,
        t.DescriptionIs ,
        t.ItemHaveDiscount
FROM    Quotations.t_Quotation AS t
LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.AccountID
LEFT JOIN Alls.v_Person AS t2 ON t1.SectionID = t2.SectionID
                                 AND t2.ID = t1.LinkWithID
LEFT JOIN Employees.t_SalesPerson AS t3 ON t3.ID = t.SalespersonID;













GO
