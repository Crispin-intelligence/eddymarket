SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_SoldNotWFPReportedAuto]
AS
SELECT t.ID,
       t.DateOnly
FROM Invoices.t_Sold AS t
WHERE t.WFPFrom = 1
      AND t.WFPReported = 0;



GO
