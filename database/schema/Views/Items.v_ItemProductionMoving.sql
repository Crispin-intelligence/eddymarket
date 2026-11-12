SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemProductionMoving]
AS
SELECT t.ID,
       t.UserID,
       t2.Name AS UserIs,
       t.SectionID,
       t.DateIs,
       t.EventIs,
       t.EventType,
       t.ComputerIP,
       t.Computer,
       t.ComputerAccount,
       t1.RefF AS Name
FROM Items.t_ItemProductionMoving AS t
    LEFT JOIN Items.t_ItemProduction AS t1
        ON t1.ID = t.SectionID
    LEFT OUTER JOIN Users.t_User AS t2
        ON t2.ID = t.UserID;






GO
