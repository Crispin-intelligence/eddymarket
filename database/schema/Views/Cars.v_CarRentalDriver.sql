SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalDriver]
AS
SELECT  t.ID ,
        t.CarRentalID ,
        t.CarDriverID ,
        t.CarDriver ,
        t.SearchText ,
        t.DateCreate ,
        t.IsSync
FROM    Cars.t_CarRentalDriver AS t;



GO
