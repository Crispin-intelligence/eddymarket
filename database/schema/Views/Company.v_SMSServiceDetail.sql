SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_SMSServiceDetail]
AS
SELECT  t.ID ,
        t.BatchID ,
        t.Mobile ,
        t.DateSend ,
        t.DateDone ,
        t.StatusIs ,
        t.DateCreate
FROM    Company.t_SMSServiceDetail AS t;



GO
