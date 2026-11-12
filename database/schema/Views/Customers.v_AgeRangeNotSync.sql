SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_AgeRangeNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.CustomerC ,
        t.SearchText ,
        t.DateCreate
FROM    Customers.t_AgeRange AS t
WHERE   t.IsSync = 0;





GO
