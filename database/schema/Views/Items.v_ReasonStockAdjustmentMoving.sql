SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ReasonStockAdjustmentMoving]
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
       t1.Name
FROM Items.t_ReasonStockAdjustmentMoving AS t
    LEFT OUTER JOIN Items.t_ReasonStockAdjustment AS t1
        ON t1.ID = t.SectionID
    LEFT OUTER JOIN Users.t_User AS t2
        ON t.UserID = t2.ID;



GO
