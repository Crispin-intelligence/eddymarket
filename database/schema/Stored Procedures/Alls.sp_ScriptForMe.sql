SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[sp_ScriptForMe]
AS
BEGIN



--WITH d AS (
--  SELECT  MovingUserID, 
--     row_number() OVER(PARTITION BY MovingUserID ORDER BY MovingID) AS countrow
--  FROM [Company].[t_AccountMoving]
--)
--DELETE d WHERE countrow > 1

PRINT ''
end





GO
