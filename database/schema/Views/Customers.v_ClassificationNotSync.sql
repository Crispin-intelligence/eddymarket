SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Customers].[v_ClassificationNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.CustomerC ,
        t.VendorC ,
        t.SearchText ,
        t.DateCreate
FROM    Customers.t_Classification AS t
WHERE   t.IsSync = 0;




GO
