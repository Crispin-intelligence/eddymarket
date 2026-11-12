SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Employees].[v_EmployeeNotSyncImageID]
AS
SELECT t.ID,
       t.Name,
       t.ImageID,
       t.ImagePathID
FROM Employees.t_Employee AS t
WHERE t.IsSyncImageID = 0;


GO
