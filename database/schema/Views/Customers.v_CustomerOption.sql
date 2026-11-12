SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_CustomerOption]
AS
SELECT t.ID,
       t.ARAdditionalProperty1,
       t.ARAdditionalProperty2,
       t.ARAdditionalProperty3,
       t.ARAdditionalProperty4,
       t.ARAdditionalProperty5,
       t.ARAdditionalProperty6,
       t.ARAdditionalProperty7,
       t.ARAdditionalProperty8,
       t.ARAdditionalProperty9,
       t.ARAdditionalProperty10,
       t.ENAdditionalProperty1,
       t.ENAdditionalProperty2,
       t.ENAdditionalProperty3,
       t.ENAdditionalProperty4,
       t.ENAdditionalProperty5,
       t.ENAdditionalProperty6,
       t.ENAdditionalProperty7,
       t.ENAdditionalProperty8,
       t.ENAdditionalProperty9,
       t.ENAdditionalProperty10
FROM Customers.t_CustomerOption AS t;



GO
