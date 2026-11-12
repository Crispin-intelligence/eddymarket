SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Quotations].[v_QuotationWarrantyBase]
AS
SELECT t.ID,
       t.Name,
	   t.DateCreate
FROM Quotations.t_QuotationWarranty AS t;


GO
