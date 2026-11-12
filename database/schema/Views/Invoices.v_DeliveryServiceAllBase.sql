SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_DeliveryServiceAllBase]
AS
    SELECT  0 AS RowIn ,
            t.ID ,
            t.Ref ,
            t.RefF ,
            t.DateCreate
    FROM    Invoices.t_DeliveryService AS t
    UNION ALL
    SELECT  1 AS RowIn ,
            t.ID ,
            t.Ref ,
            t.RefF ,
            t.DateCreate
    FROM    Invoices.t_DeliveryServiceHistory AS t;
	

GO
