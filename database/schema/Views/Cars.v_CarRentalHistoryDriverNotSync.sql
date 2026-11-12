SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalHistoryDriverNotSync]
AS
SELECT  t.ID ,
        t.CarRentalHistoryID ,
        t.CarDriverID ,
        t.CarDriver ,
        t.SearchText ,
        t.DateCreate
FROM    Cars.t_CarRentalHistoryDriver AS t
WHERE   t.IsSync = 0;






GO
