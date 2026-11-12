SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Customers].[v_CustomerChooseNotBlocked]
AS
SELECT t.ID,
       t.Name,
       t.Phones,
       t.SocialMedia,
       t.AddressIs,
       t.DescriptionIs
FROM Customers.t_Customer AS t
WHERE t.StatusIs <> 2;



GO
