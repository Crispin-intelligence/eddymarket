SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Options].[v_WorldFoodProgramme]
AS
SELECT t.ID,
       t.ShopID,
       t.BranchID,
       t.DestinationPath,
       t.FileNamePrefix,
       t.FileNameDateTimeFormat,
       t.FileNameSuffix,
       t.AutoGenerateReport
FROM Options.t_WorldFoodProgramme AS t;




GO
