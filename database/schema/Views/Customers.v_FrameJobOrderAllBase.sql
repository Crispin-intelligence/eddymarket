SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_FrameJobOrderAllBase]
AS
    SELECT  0 AS FromHistory ,
            t.ID ,
            t.Ref ,
            t.RefF ,
            t.DateCreate
    FROM    Customers.t_FrameJobOrder AS t
    UNION ALL
    SELECT  1 AS FromHistory ,
            t.ID ,
            t.Ref ,
            t.RefF ,
            t.DateCreate
    FROM    Customers.t_FrameJobOrderHistory AS t;



GO
