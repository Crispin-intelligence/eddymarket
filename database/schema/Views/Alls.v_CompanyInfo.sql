SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Alls].[v_CompanyInfo]
AS
SELECT t.ID,
       t.AppQRCode
FROM Alls.t_CompanyInfo AS t;




GO
