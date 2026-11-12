SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Options].[v_ReportHeaderFooterList]
AS
SELECT t.ID,
       t.Name,
       t.TitleReportEN,
       t.HeaderEN,
       t.FooterEN,
       t.TitleReportAR,
       t.HeaderAR,
       t.FooterAR,
	   t.DateCreate
FROM Options.t_ReportHeaderFooter AS t;

GO
