SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [Employees].[f_DiscountGetTotalByEmployee]
(
    @EmployeeID UNIQUEIDENTIFIER,
    @FromDate DATE,
    @ToDate DATE
)
RETURNS FLOAT
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @TotalIs FLOAT;

    END;

    BEGIN --Set

        SELECT @TotalIs = SUM(   CASE t2.TypeIs
                                     WHEN 0 THEN
                                         t.ValueIsD
                                     WHEN 1 THEN
                                         t.ValueIsLL
                                     ELSE
                                         t.ValueIsEuro
                                 END
                             )
        FROM Employees.t_Discount AS t
            LEFT JOIN Employees.t_Employee AS t1
                ON t1.ID = t.EmployeeID
            LEFT JOIN Currencys.t_Currency AS t2
                ON t2.ID = t1.CurrencyID
        WHERE t.EmployeeID = @EmployeeID
              AND t.ImplementationIn
              BETWEEN @FromDate AND @ToDate;

    END;

    RETURN COALESCE(@TotalIs, 0);

END;

GO
