SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_BankAccountChooseNotBlocked]
AS
SELECT t.ID,
       t.Name,
	   t1.ID AS AccountID,
       t1.NumberF,
       t.Phones,
       t.AddressIs
FROM Company.t_Bank AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.SectionID = 38
           AND t1.LinkWithID = t.ID
WHERE t.StatusIs <> 2;




GO
