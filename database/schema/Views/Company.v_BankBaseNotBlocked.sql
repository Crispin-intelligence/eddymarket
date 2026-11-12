SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_BankBaseNotBlocked]
AS
SELECT t.ID,
       t.Name
FROM Company.t_Bank AS t
WHERE t.StatusIs <> 2;


GO
