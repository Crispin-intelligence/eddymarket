SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarExpenseDashboardEuro]
AS
SELECT  t.DateOnly ,
        t.Car ,
        t.ToAccount ,
        t.NetIsEuro AS Balance
FROM    Cars.t_CarExpense AS t;






GO
