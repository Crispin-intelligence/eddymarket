SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create VIEW [Company].[v_AccountBase]
AS
SELECT t.ID,
       t.Level3ID,
       t.NumberIs,
       t.NumberF,
       t.Name
FROM Company.t_Account AS t;




GO
