SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Invoices].[v_PurchasingReturnDeletedBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
       t.DateCreate
FROM Invoices.t_PurchasingReturnDeleted AS t;





GO
