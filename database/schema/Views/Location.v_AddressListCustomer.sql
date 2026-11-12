SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Location].[v_AddressListCustomer]
AS
SELECT t.ID,
       t.OwnerID,
       t.OwnerName,
       t.Name,
       t.TypeIs,
       t.AddressIs,
	   t.DateCreate ,
       t.IsSync
FROM Location.t_Address AS t
WHERE t.SectionID = 15;


GO
