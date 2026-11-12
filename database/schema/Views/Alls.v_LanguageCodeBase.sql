SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Alls].[v_LanguageCodeBase]
AS
SELECT t.ID,
       t.Name
FROM Alls.t_LanguageCode AS t;


GO
