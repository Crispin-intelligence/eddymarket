SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Quotations].[v_QuotationNoteLink]
AS
SELECT t.ID,
       t.QuotationID,
       t.NoteID,
       t.SortAt,
       t.DateCreate
FROM Quotations.t_QuotationNoteLink AS t;




GO
