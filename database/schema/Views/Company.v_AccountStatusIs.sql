SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_AccountStatusIs]
AS
SELECT t.ID,
       t.Name,
       t.StatusIs,
       t.WhyThisStatus
FROM Company.t_Account AS t;




GO
