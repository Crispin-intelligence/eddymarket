SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalDriverNotSync]
AS
SELECT  t.ID ,
        t.CarRentalID ,
        t.CarDriverID ,
        t.CarDriver ,
        t.SearchText ,
        t.DateCreate
FROM    Cars.t_CarRentalDriver AS t
WHERE   t.IsSync = 0;





GO
