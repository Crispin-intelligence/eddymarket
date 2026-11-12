SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationNoteBase]
AS
SELECT t.ID,
       t.Name,
	   t.DateCreate
FROM Quotations.t_QuotationNote AS t;



GO
