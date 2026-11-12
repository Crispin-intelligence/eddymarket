SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_CustomerChoose]
AS
SELECT t.ID,
       t.Name,
       t.Phones,
       t.SocialMedia,
       t.AddressIs,
       t.DescriptionIs
FROM Customers.t_Customer AS t;



GO
