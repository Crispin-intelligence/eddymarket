CREATE TABLE [Employees].[t_TeamsMoving]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TeamsMoving_ID] DEFAULT (newsequentialid()),
[MovingID] [int] NOT NULL IDENTITY(1, 1),
[MovingUserID] [int] NOT NULL,
[MovingSectionID] [int] NOT NULL,
[MovingDate] [datetime] NOT NULL CONSTRAINT [DF_t_TeamsMoving_MovingDate] DEFAULT (getdate()),
[MovingEvent] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL,
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TeamsMoving_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_TeamsMoving] ADD CONSTRAINT [PK_t_TeamsMoving] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
