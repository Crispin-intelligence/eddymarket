CREATE TABLE [Alls].[t_Section]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Section_ID] DEFAULT (newsequentialid()),
[SectionID] [int] NOT NULL,
[NameEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Section_Name] DEFAULT (''),
[NameAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Section_NameAR] DEFAULT (''),
[DescriptionEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Section_DescriptionEN] DEFAULT (''),
[DescriptionAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Section_DescriptionAR] DEFAULT (''),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Section_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Alls].[t_Section] ADD CONSTRAINT [PK_t_Section] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
