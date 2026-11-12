SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_SMSService]
AS
SELECT  t.ID ,
        t.BatchID ,
        t.DateSend ,
        t.StatusIs ,
        t.SenderID ,
        t.TotalMobiles ,
        t.MessageIs ,
        t.DateCreate 
FROM    Company.t_SMSService AS t;



GO
