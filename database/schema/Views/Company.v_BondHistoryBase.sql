SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_BondHistoryBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
	   t.NumberIs,
	   t.DateCreate
FROM Company.t_BondHistory AS t;





GO
