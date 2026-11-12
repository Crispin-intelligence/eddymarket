SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_BeginningInventoryQuantityDetailSerial]
AS
SELECT t.ID,
       t.BeginningInventoryQuantityDetailID,
       t.SerialID,
       t.DateCreate
FROM Items.t_BeginningInventoryQuantityDetailSerial AS t;

GO
