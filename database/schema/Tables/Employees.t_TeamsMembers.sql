CREATE TABLE [Employees].[t_TeamsMembers]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TeamsMembers_ID] DEFAULT (newsequentialid()),
[TeamID] [int] NOT NULL CONSTRAINT [DF_t_TeamsMembers_TeamsID] DEFAULT ((1)),
[EmployeeID] [int] NOT NULL CONSTRAINT [DF_t_TeamsMembers_EmployeeID] DEFAULT ((1)),
[Description] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TeamsMembers_Description] DEFAULT ('')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_TeamsMembers] ADD CONSTRAINT [PK_t_TeamsMembers] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_TeamsMembers] ON [Employees].[t_TeamsMembers] ([TeamID], [EmployeeID]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_TeamsMembers] ADD CONSTRAINT [TeamsKeyTeamsMembers] FOREIGN KEY ([TeamID]) REFERENCES [Employees].[t_Teams] ([ID]) ON DELETE CASCADE
GO
