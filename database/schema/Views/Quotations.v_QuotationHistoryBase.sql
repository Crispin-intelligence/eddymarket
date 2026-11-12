SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Quotations].[v_QuotationHistoryBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Quotations.t_QuotationHistory AS t;




GO
