SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Location].[v_AddressListOnlyVendor]
AS
SELECT t.ID,
       t.SectionID,
       t.OwnerID,
       t.OwnerName,
       t.Name,
       t.TypeIs,
       t.StatesIs,
       t.RegionIs,
       t.Street,
       t.Building,
       t.FloorIs,
       t.PostalCode,
       t.AddressNote,
       t.AddressIs,
       t.DateCreate ,
       t.IsSync
FROM Location.t_Address AS t
WHERE t.SectionID = 67;




GO
