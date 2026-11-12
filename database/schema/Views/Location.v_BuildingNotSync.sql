SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Location].[v_BuildingNotSync]
AS
SELECT  t.ID ,
        t.Name ,
        t.DescriptionIs ,
        t.AddressC ,
        t.BankC ,
        t.ContactC ,
        t.CustomerC ,
        t.EmployeeC ,
        t.SalesPersonC ,
        t.VendorC ,
        t.WarehouseC ,
        t.SearchText ,
        t.DateCreate
FROM    Location.t_Building AS t
WHERE   t.IsSync = 0;

GO
