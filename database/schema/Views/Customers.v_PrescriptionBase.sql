SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_PrescriptionBase]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.DateCreate
FROM    Customers.t_Prescription AS t;



GO
