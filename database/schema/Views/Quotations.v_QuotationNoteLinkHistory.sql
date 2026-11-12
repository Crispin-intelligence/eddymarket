SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationNoteLinkHistory]
AS
SELECT t.ID,
       t.QuotationHistoryID,
       t.NoteID,
       t.SortAt,
       t.DateCreate
FROM Quotations.t_QuotationNoteLinkHistory AS t;





GO
