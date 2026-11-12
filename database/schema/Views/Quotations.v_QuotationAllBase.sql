SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Quotations].[v_QuotationAllBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Quotations.t_Quotation AS t
UNION ALL
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Quotations.t_QuotationHistory AS t;


GO
