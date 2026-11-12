SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_ExecuteJob]
AS
BEGIN

  EXECUTE [Cars].[s_CarDriverExecuteJob];
  EXECUTE [Cars].[s_CarExecuteJob];

  EXECUTE [Company].[s_ContactExecuteJobAgeIs];
  EXECUTE [Company].[s_DoctorExecuteJobAgeIs];
  
  EXECUTE [Customers].[s_CustomerExecuteJob];
  
  EXECUTE [Employees].[s_EmployeeExecuteJobAgeIs];

  EXECUTE [Gym].[s_GymSubscriptionExecuteJob];
  
  EXECUTE [Company].[s_AccountExecuteJobStatusIs];

  EXECUTE [Items].[s_ItemSharedExecuteJobStatusIs]; 

  RETURN 1;
  
END;


GO
