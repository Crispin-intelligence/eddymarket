CREATE TABLE [Alls].[t_CompanyInfo]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CompanyInfo_ID] DEFAULT (newsequentialid()),
[AppQRCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CompanyInfo_AppQRCode] DEFAULT ('')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Alls].[t_CompanyInfo] ADD CONSTRAINT [PK_t_CompanyInfo] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
