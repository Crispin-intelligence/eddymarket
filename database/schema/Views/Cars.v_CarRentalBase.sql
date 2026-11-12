SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Cars].[v_CarRentalBase]
AS
SELECT t.ID,
       t.Ref
FROM Cars.t_CarRental AS t;




GO
