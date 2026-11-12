CREATE TABLE [Employees].[t_Teams]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Teams_Name] DEFAULT (''),
[TypeID] [uniqueidentifier] NOT NULL,
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Teams_TypeIs] DEFAULT ([Employees].[f_EmployeeTypeGetFirstName]()),
[EmployeeID] [int] NOT NULL CONSTRAINT [DF_t_Teams_AdminEmployeeID] DEFAULT ((1)),
[Description] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Teams_Description] DEFAULT ('')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_Teams] ON [Employees].[t_Teams]
    AFTER INSERT, UPDATE, DELETE
AS
    BEGIN

        UPDATE  Alls.t_LiveVersion
        SET     VersionLive = STUFF(VersionLive, Teams, 3,
                                    FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                           '000')) ,
                SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3,
                                  FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                         '000'));



    END;
GO
ALTER TABLE [Employees].[t_Teams] ADD CONSTRAINT [PK_t_Teams] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_Teams] ON [Employees].[t_Teams] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_Teams] ADD CONSTRAINT [EmployeeTypeKeyTeams] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_EmployeeType] ([ID])
GO
