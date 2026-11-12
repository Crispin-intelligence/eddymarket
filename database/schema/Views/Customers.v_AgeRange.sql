SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_AgeRange]
AS
SELECT  ID ,
        Name ,
        DescriptionIs ,
        CustomerC ,
        DateCreate ,
        IsSync
FROM    Customers.t_AgeRange AS t;

GO
