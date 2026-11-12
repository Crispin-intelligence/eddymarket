SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationNoteLinkList]
AS
SELECT  t.ID ,
        t.QuotationID ,
        t.NoteID ,
        t1.Name ,
        t1.DescriptionIs ,
        t1.Name + CHAR(13) + CHAR(10) + t1.DescriptionIs AS NameAndDescription ,
        t.SortAt ,
        t.DateCreate
FROM    Quotations.t_QuotationNoteLink AS t
INNER JOIN Quotations.t_QuotationNote AS t1 ON t1.ID = t.NoteID;






GO
