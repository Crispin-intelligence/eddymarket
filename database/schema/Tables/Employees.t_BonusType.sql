CREATE TABLE [Employees].[t_BonusType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BonusType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusType_Name] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusType_DescriptionIs] DEFAULT (''),
[BonusTotalD] [float] NOT NULL CONSTRAINT [DF_t_BonusType_BonusTotalD] DEFAULT ((0)),
[BonusTotalLL] [float] NOT NULL CONSTRAINT [DF_t_BonusType_BonusTotalLL] DEFAULT ((0)),
[BonusTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_BonusType_BonusTotalEuro] DEFAULT ((0)),
[BonusC] [bigint] NOT NULL CONSTRAINT [DF_t_BonusType_BonusC] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_BonusType_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BonusType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_BonusType]
ON [Employees].[t_BonusType]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, EmployeeBonusType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Employees].[t_BonusType] ADD CONSTRAINT [PK_t_BonusType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_BonusType_Name] ON [Employees].[t_BonusType] ([Name]) ON [PRIMARY]
GO
