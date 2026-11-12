SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_AccountReport]
AS
SELECT t.ID,
       t.NumberF,
       t.Name,
       t.CurrencyID,
       t.CurrencyTypeIs,
       t.Balance,
       t.BalanceF,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro,
       ISNULL(t1.Name, N'') AS LinkName,
       ISNULL(t1.Phones, N'') AS Phones,
       ISNULL(t1.AddressIs, N'') AS AddressIs
FROM Company.t_Account AS t
    LEFT JOIN Alls.v_Person AS t1
        ON t1.SectionID = t.SectionID
           AND t1.ID = t.LinkWithID;


GO
