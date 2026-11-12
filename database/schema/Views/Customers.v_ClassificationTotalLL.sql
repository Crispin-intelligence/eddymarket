SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Customers].[v_ClassificationTotalLL]
AS
SELECT t.ID,
       t.DateOnly AS DateIs,
       t.NetIsLL AS Total,
       COALESCE(t2.Classification, '') AS Classification
FROM Invoices.t_Sold AS t
    LEFT JOIN Company.t_Account AS t1
        ON t1.ID = t.AccountCustomerID
    LEFT JOIN Customers.t_Customer AS t2
        ON t2.ID = t1.LinkWithID;



GO
