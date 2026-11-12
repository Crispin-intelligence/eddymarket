SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_DeliveryServiceListOfCustomer]
AS
    SELECT  t.ID ,
            t.Ref ,
            t.RefF ,
            t.RefPaper ,
            t.DateIs ,
            t.TypeIs ,
            t.StatusIs ,
            t.AccountCustomerID ,
            t.DeliveryCharge ,
            t.DeliveryChargeF ,
            t.DateCreate
    FROM    Invoices.t_DeliveryService AS t
    WHERE   t.DeliveryCharge > 0
            AND t.DeliveryChargeStatus = 0;

GO
