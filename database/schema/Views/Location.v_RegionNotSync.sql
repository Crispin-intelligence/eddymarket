SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Location].[v_RegionNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.StatesID ,
        t.StatesIs ,
        t.AddressC ,
        t.BankC ,
        t.ContactC ,
        t.CustomerC ,
        t.EmployeeC ,
        t.SalesPersonC ,
        t.VendorC ,
        t.WarehouseC ,
        t.StreetC ,
        t.SearchText ,
        t.DateCreate
FROM    Location.t_Region AS t
WHERE   t.IsSync = 0;



GO
