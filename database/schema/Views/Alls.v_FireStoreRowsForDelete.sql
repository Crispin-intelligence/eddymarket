SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Alls].[v_FireStoreRowsForDelete]
AS
SELECT t.ID,
       t.DocumentID,
	   t.HasImage,
       t.TableName
FROM Alls.t_FireStoreRowsForDelete AS t;





GO
