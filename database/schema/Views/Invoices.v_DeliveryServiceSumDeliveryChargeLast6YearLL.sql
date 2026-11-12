SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_DeliveryServiceSumDeliveryChargeLast6YearLL]
AS
    SELECT  t.DateYearly AS DateOnly ,
            SUM(t1.DeliveryChargeLL) AS DeliveryCharge ,
            COUNT(*) AS CountIs
    FROM    ( SELECT DISTINCT TOP ( 6 )
                        s.DateYearly
              FROM      Invoices.v_DeliveryServiceAll AS s
              ORDER BY  s.DateYearly DESC
            ) AS t
            LEFT JOIN Invoices.v_DeliveryServiceAll AS t1 ON t1.DateYearly = t.DateYearly
    WHERE   t1.StatusIs <> 5
    GROUP BY t.DateYearly;





GO
