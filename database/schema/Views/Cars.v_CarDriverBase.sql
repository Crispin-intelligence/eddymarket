SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Cars].[v_CarDriverBase]
AS
SELECT  t.ID ,
        t.Name
FROM    Cars.t_CarDriver AS t;





GO
