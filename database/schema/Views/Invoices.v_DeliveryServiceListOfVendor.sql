SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Invoices].[v_DeliveryServiceListOfVendor]
AS
    SELECT  t.ID ,
            t.Ref ,
            t.RefF ,
            t.RefPaper ,
            t.DateIs ,
            t.TypeIs ,
            t.StatusIs ,
            t.AccountVendorID ,
            t.Cost ,
            t.CostF ,
            t.Rest ,
            t.RestF ,
            t.DateCreate
    FROM    Invoices.t_DeliveryService AS t
    WHERE   t.Rest > 0;
	


GO
