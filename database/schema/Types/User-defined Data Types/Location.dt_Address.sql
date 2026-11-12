CREATE TYPE [Location].[dt_Address] AS TABLE
(
[Name] [nvarchar] (150) COLLATE Arabic_CI_AS NOT NULL,
[TypeIs] [tinyint] NOT NULL,
[StatesID] [int] NOT NULL,
[RegionID] [int] NOT NULL,
[StreetID] [int] NOT NULL,
[BuildingID] [int] NOT NULL,
[FloorID] [int] NOT NULL,
[PostalCodeID] [int] NOT NULL,
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
