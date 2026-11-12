SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationTypeBase]
AS
SELECT t.ID,
       t.Name,
	   t.DateCreate
FROM Quotations.t_QuotationType AS t;



GO
