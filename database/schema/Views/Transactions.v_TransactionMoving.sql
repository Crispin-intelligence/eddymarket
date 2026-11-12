SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Transactions].[v_TransactionMoving]
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
            t1.RefF AS Name
    FROM    Transactions.t_TransactionMoving AS t
            LEFT JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.SectionID
            LEFT OUTER JOIN Users.t_User AS t2 ON t2.ID = t.UserID;










GO
