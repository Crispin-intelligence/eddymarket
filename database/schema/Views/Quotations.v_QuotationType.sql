SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Quotations].[v_QuotationType]
AS
SELECT t.ID,
       t.Name,
       t.DescriptionIs,
       t.QuotationC,
       t.QuotationTotalD,
       t.QuotationTotalDF,
       t.QuotationTotalLL,
       t.QuotationTotalLLF,
       t.QuotationTotalEuro,
       t.QuotationTotalEuroF,
       t.DateCreate
FROM Quotations.t_QuotationType AS t;



GO
DECLARE @xp int
SELECT @xp=1

GO
