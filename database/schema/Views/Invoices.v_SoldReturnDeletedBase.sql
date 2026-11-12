SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Invoices].[v_SoldReturnDeletedBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Invoices.t_SoldReturnDeleted AS t;



GO
