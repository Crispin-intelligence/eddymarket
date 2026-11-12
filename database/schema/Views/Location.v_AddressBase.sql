SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Location].[v_AddressBase]
AS
SELECT t.ID,
       t.SectionID,
       t.OwnerID,
       t.Name,
	   t.DateCreate
FROM Location.t_Address AS t;




GO
