SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Company].[v_DoctorBase]
AS
SELECT t.ID,
       t.Name,
       t.DateCreate
FROM Company.t_Doctor AS t;


GO
