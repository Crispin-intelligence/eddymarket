SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [Company].[v_SocialMediaTypeBase]
AS
SELECT t.ID,
       t.Name
FROM Company.t_SocialMediaType AS t;


GO
