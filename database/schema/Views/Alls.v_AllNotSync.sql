SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Alls].[v_AllNotSync]
AS
SELECT  't_FireStoreRowsForDelete' AS TableName ,
        COUNT(*) AS CountIs
FROM    Alls.t_FireStoreRowsForDelete AS s
UNION ALL
SELECT  'v_CurrencyNotSync'  ,
        COUNT(*) 
FROM    Currencys.v_CurrencyNotSync AS s
UNION ALL
SELECT  'v_AgeRangeNotSync' ,
        COUNT(*)
FROM    Customers.v_AgeRangeNotSync AS s
UNION ALL
SELECT  'v_ClassificationNotSync' ,
        COUNT(*)
FROM    Customers.v_ClassificationNotSync AS s
UNION ALL
SELECT  'v_TitleNotSync' ,
        COUNT(*)
FROM    Customers.v_TitleNotSync AS s
UNION ALL
SELECT  'v_EmployeeTypeNotSync' ,
        COUNT(*)
FROM    Employees.v_EmployeeTypeNotSync AS s
UNION ALL
SELECT  'v_NationalityNotSync' ,
        COUNT(*)
FROM    Employees.v_NationalityNotSync AS s
UNION ALL
SELECT  'v_BrandNotSync' ,
        COUNT(*)
FROM    Items.v_BrandNotSync AS s
UNION ALL
SELECT  'v_ItemSharedNotSync' ,
        COUNT(*)
FROM    Items.v_ItemSharedNotSync AS s
UNION ALL
SELECT  'v_ItemSharedOptionNotSync' ,
        COUNT(*)
FROM    Items.v_ItemSharedOptionNotSync AS s
UNION ALL
SELECT  'v_MainCategoryNotSync' ,
        COUNT(*)
FROM    Items.v_MainCategoryNotSync AS s
UNION ALL
SELECT  'v_MainCategoryNotSyncImage' ,
        COUNT(*)
FROM    Items.v_MainCategoryNotSyncImage AS s
UNION ALL
SELECT  'v_SubCategoryNotSync' ,
        COUNT(*)
FROM    Items.v_SubCategoryNotSync AS s
UNION ALL
SELECT  'v_UnityNotSync' ,
        COUNT(*)
FROM    Items.v_UnityNotSync AS s
UNION ALL
SELECT  'v_ItemSharedVendorNotSync' ,
        COUNT(*)
FROM    Items.v_ItemSharedVendorNotSync AS s
UNION ALL
SELECT  'v_BuildingNotSync' ,
        COUNT(*)
FROM    Location.v_BuildingNotSync AS s
UNION ALL
SELECT  'v_FloorNotSync' ,
        COUNT(*)
FROM    Location.v_FloorNotSync AS s
UNION ALL
SELECT  'v_PostalCodeNotSync' ,
        COUNT(*)
FROM    Location.v_PostalCodeNotSync AS s
UNION ALL
SELECT  'v_RegionNotSync' ,
        COUNT(*)
FROM    Location.v_RegionNotSync AS s
UNION ALL
SELECT  'v_StatesNotSync' ,
        COUNT(*)
FROM    Location.v_StatesNotSync AS s
UNION ALL
SELECT  'v_StreetNotSync' ,
        COUNT(*)
FROM    Location.v_StreetNotSync AS s
UNION ALL
SELECT  'v_PermissionNotSync' ,
        COUNT(*)
FROM    Users.v_PermissionNotSync AS s
UNION ALL
SELECT  'v_UserImageNotSync' ,
        COUNT(*)
FROM    Users.v_UserImageNotSync AS s
UNION ALL
SELECT  'v_UserNotSync' ,
        COUNT(*)
FROM    Users.v_UserNotSync AS s;







GO
