CREATE TABLE [Options].[t_WorldFoodProgramme]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_ID] DEFAULT (newsequentialid()),
[ShopID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_ShopID] DEFAULT (''),
[BranchID] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_BranchID] DEFAULT (''),
[DestinationPath] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_DestinationPath] DEFAULT ('C:\'),
[FileNamePrefix] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_FileNamePrefix] DEFAULT ('LB-'),
[FileNameDateTimeFormat] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_FileNameDateTimeFormat] DEFAULT ('yyyymmdd_HHmm'),
[FileNameSuffix] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_FileNameSuffix] DEFAULT (''),
[AutoGenerateReport] [tinyint] NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_AutoGenerateReport] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_WorldFoodProgramme_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Options].[t_WorldFoodProgramme] ADD CONSTRAINT [PK_t_WorldFoodProgramme] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'None = 0
Daily = 1
Weekly = 2
Monthly = 3
Yearly = 4', 'SCHEMA', N'Options', 'TABLE', N't_WorldFoodProgramme', 'COLUMN', N'AutoGenerateReport'
GO
