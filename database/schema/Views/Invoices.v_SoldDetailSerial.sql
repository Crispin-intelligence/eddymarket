SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Invoices].[v_SoldDetailSerial]
AS
SELECT t.ID,
       t.SoldID,
       t.SoldDetailID,
       t.SerialID,
       t.DateCreate
FROM Invoices.t_SoldDetailSerial AS t;



GO
