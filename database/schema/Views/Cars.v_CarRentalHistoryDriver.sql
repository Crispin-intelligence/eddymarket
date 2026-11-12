SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarRentalHistoryDriver]
AS
SELECT  t.ID ,
        t.CarRentalHistoryID ,
        t.CarDriverID ,
        t.CarDriver ,
        t.SearchText ,
        t.DateCreate ,
        t.IsSync
FROM    Cars.t_CarRentalHistoryDriver AS t;




GO
