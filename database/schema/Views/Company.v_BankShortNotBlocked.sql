SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_BankShortNotBlocked]
AS
SELECT t.ID,
       t.Name,
       t1.NumberF,
       t1.BalanceF
FROM Company.t_Bank AS t
    LEFT OUTER JOIN Company.t_Account AS t1
        ON t.ID = t1.LinkWithID
           AND t1.SectionID = 38
WHERE t.StatusIs <> 2;



GO
