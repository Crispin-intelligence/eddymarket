SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Cars].[v_CarExpenseDashboardD]
AS
SELECT  t.DateOnly ,
        t.Car ,
        t.ToAccount ,
        t.NetIsD AS Balance
FROM    Cars.t_CarExpense AS t;





GO
