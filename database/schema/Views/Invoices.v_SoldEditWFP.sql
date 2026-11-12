SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_SoldEditWFP]
AS
SELECT t.ID,
       t.RefF,
       t.WFPFrom,
       t.WFPReported
FROM Invoices.t_Sold AS t;



GO
