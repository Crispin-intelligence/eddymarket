SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Users].[v_UserBase]
AS
SELECT t.ID,
       t.Name
FROM Users.t_User AS t;

GO
