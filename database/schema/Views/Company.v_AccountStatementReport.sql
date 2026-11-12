SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_AccountStatementReport]
AS
SELECT t.ID,
       t.LinkWith,
       t.NumberF,
       t.Name,
       ISNULL(t1.Phones, '') AS Phones,
       ISNULL(t1.AddressIs, '') AS AddressIs,
       t.BalanceD,
       t.BalanceLL,
       t.BalanceEuro
FROM Company.t_Account AS t
    LEFT JOIN Alls.v_Person AS t1
        ON t1.SectionID = t.SectionID
           AND t1.ID = t.LinkWithID;



GO
