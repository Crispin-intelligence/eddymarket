SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountBase1]
AS
SELECT t.ID,
       t.NumberF,
       t.Name,
	   t.DateCreate
FROM Company.t_Account AS t;






GO
