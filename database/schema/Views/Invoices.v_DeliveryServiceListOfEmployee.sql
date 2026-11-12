SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_DeliveryServiceListOfEmployee]
AS
    SELECT  t.ID ,
            t.Ref ,
            t.RefF ,
            t.RefPaper ,
            t.DateIs ,
            t.TypeIs ,
            t.StatusIs ,
            t.AccountEmployeeID ,
            t.Expense ,
            t.ExpenseF ,
            t.DateCreate
    FROM    Invoices.t_DeliveryService AS t
    WHERE   t.Expense > 0
            AND t.ExpenseStatus = 0;

GO
