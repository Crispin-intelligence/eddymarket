SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarOwnersProfileBase]
AS
SELECT t.ID,
       t.Name
FROM Cars.t_CarOwnersProfile AS t;




GO
