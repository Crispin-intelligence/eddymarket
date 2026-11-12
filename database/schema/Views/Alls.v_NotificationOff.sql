SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Alls].[v_NotificationOff]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.TextIs,
       t.DateIs,
       t.IsStop,
       t.DateCreate
FROM Alls.t_Notification AS t
WHERE (t.IsStop = 1);


GO
