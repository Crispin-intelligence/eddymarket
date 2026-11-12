SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Cars].[v_CarMakeMoving]
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
        t1.Name
FROM    Cars.t_CarMakeMoving AS t
LEFT OUTER JOIN Cars.t_CarMake AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID;








GO
