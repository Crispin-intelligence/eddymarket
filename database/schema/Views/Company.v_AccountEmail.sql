SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_AccountEmail]
AS
SELECT ID,
       Name,
       Password,
       Note
FROM Company.t_AccountEmail;




GO
