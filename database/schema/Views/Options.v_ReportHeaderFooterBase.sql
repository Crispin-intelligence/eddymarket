SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Options].[v_ReportHeaderFooterBase]
AS
SELECT t.ID,
       t.Name
FROM Options.t_ReportHeaderFooter AS t;


GO
