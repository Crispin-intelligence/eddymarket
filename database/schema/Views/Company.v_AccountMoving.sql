SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_AccountMoving]
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
    FROM    [Company].t_AccountMoving AS t
            LEFT JOIN Company.t_Account AS t1 ON t1.ID = t.SectionID
            LEFT OUTER JOIN Users.t_User AS t2 ON t2.ID = t.UserID;









GO
