SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarRentalHistoryBase]
AS
SELECT t.ID,
       t.Ref
FROM Cars.t_CarRentalHistory AS t;





GO
