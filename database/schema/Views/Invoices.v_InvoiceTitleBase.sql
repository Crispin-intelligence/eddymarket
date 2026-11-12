SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_InvoiceTitleBase]
AS
SELECT t.ID,
       t.Name
FROM Invoices.t_InvoiceTitle AS t;



GO
