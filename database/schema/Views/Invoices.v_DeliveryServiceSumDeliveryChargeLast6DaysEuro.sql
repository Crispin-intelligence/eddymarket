SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_DeliveryServiceSumDeliveryChargeLast6DaysEuro]
AS
    SELECT  t.DateOnly ,
            SUM(t1.DeliveryChargeEuro) AS DeliveryCharge ,
            COUNT(*) AS CountIs
    FROM    ( SELECT DISTINCT TOP ( 6 )
                        s.DateOnly
              FROM      Invoices.v_DeliveryServiceAll AS s
              ORDER BY  s.DateOnly DESC
            ) AS t
            LEFT JOIN Invoices.v_DeliveryServiceAll AS t1 ON t1.DateOnly = t.DateOnly
    WHERE   t1.StatusIs <> 5
    GROUP BY t.DateOnly;





GO
