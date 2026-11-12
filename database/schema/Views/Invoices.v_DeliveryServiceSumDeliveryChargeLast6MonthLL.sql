SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_DeliveryServiceSumDeliveryChargeLast6MonthLL]
AS
    SELECT  t.DateMonthly AS DateOnly ,
            SUM(t1.DeliveryChargeLL) AS DeliveryCharge ,
            COUNT(*) AS CountIs
    FROM    ( SELECT DISTINCT TOP ( 6 )
                        s.DateMonthly
              FROM      Invoices.v_DeliveryServiceAll AS s
              ORDER BY  s.DateMonthly DESC
            ) AS t
            LEFT JOIN Invoices.v_DeliveryServiceAll AS t1 ON t1.DateMonthly = t.DateMonthly
    WHERE   t1.StatusIs <> 5
    GROUP BY t.DateMonthly;






GO
