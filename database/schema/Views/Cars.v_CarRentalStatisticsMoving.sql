SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalStatisticsMoving]
AS
SELECT  t.ID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        N'' AS Name
FROM    Cars.t_CarRentalStatisticsMoving AS t
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID;








GO
