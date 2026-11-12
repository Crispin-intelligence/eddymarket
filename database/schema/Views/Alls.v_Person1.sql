SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Alls].[v_Person1]
AS
SELECT  15 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        t.Title ,
        t.Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        t.NumberCurrency
FROM    Customers.t_Customer AS t
UNION ALL
SELECT  33 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        '-' AS Title ,
        '-' AS Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Employees.t_Employee AS t
UNION ALL
SELECT  38 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        '-' AS Title ,
        '-' AS Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Company.t_Bank AS t
UNION ALL
SELECT  42 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        '-' AS Title ,
        '-' AS Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Company.t_WareHouse AS t
UNION ALL
SELECT  67 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        t.Title ,
        t.Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        t.NumberCurrency
FROM    Vendors.t_Vendor AS t
UNION ALL
SELECT  149 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        '-' AS Title ,
        '-' AS Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Employees.t_SalesPerson AS t
UNION ALL
SELECT  153 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        '-' AS Title ,
        '-' AS Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Company.t_Contact AS t
UNION ALL
SELECT  163 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        '-' AS Title ,
        '-' AS Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Company.t_Doctor AS t
UNION ALL
SELECT  184 AS SectionID ,
        t.ID ,
        t.Name ,
        t.Phones ,
        t.AddressIs ,
        t.Title ,
        t.Classification ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        '' AS NumberCurrency
FROM    Cars.t_CarDriver AS t;




GO
