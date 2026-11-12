SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationNote]
AS
SELECT t.ID ,
    t.Name ,
    t.AutoInsert ,
    t.DescriptionIs ,
    t.Name + CHAR(13) + CHAR(10) + t.DescriptionIs AS NameAndDescription ,
    t.SortAt ,
    t.QuotationC ,
    t.QuotationTotalD ,
    t.QuotationTotalDF ,
    t.QuotationTotalLL ,
    t.QuotationTotalLLF ,
    t.QuotationTotalEuro ,
    t.QuotationTotalEuroF ,
    t.DateCreate
  FROM Quotations.t_QuotationNote AS t;





GO
DECLARE @xp int
SELECT @xp=1

GO
