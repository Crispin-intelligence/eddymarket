SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Gym].[v_GymClassBase]
AS
SELECT t.ID,
       t.Name,
       t.DateCreate
FROM Gym.t_GymClass AS t;





GO
