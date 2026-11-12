SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Company].[v_AccountGroupBase]
AS
SELECT t.ID,
       t.Name
FROM Company.t_AccountGroup AS t;


GO
