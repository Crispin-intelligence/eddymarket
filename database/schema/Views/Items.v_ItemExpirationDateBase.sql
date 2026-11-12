SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Items].[v_ItemExpirationDateBase]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.DateCreate
FROM    Items.t_ItemExpirationDate AS t;




GO
