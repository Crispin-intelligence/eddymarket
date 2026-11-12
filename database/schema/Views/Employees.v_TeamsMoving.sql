SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_TeamsMoving]
AS
SELECT MovingID,
       MovingUserID,
       MovingSectionID,
       MovingDate,
       MovingEvent,
       WorkStationID
FROM [Employees].[t_TeamsMoving];







GO
