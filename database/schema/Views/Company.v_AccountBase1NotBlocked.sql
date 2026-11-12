SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_AccountBase1NotBlocked]
AS
SELECT t.ID,
       t.NumberIs,
       t.NumberF,
       t.Name,
       t.DateCreate
FROM Company.t_Account AS t
WHERE t.StatusIs <> 2;



GO
