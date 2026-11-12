SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_BondReport]
AS
SELECT t.ID,
       t.NumberOfGroup,
       t1.Name AS FromAccount,
       t1.LinkWith AS FromLinkWith,
       t.AddressIs,
       t2.Name AS ToAccount,
       t2.LinkWith AS ToLinkWith,
       t.AmountF,
       t.AmountAR,
       t.AmountEN,
       t.Building,
       t.DateIs,
       t.DateDue,
       t.DescriptionIs
FROM Company.t_Bond AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.FromAccountID
    LEFT JOIN Company.t_Account AS t2
        ON t2.ID = t.ToAccountID;





GO
