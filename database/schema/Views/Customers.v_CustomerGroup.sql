SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_CustomerGroup]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.CustomerCount ,
        t.CustomerNames ,
        t.DateCreate ,
        t.IsSync 
FROM    Customers.t_CustomerGroup AS t;

GO
