SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Items].[v_ProfitPartnerBase]
AS
SELECT t.ID,
       t.Name
FROM Items.t_ProfitPartner AS t;





GO
