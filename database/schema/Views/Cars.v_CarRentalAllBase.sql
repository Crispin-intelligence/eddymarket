SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarRentalAllBase]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        0 AS InHistory
FROM    Cars.t_CarRental AS t
UNION ALL
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        1 AS InHistory
FROM    Cars.t_CarRentalHistory AS t;






GO
