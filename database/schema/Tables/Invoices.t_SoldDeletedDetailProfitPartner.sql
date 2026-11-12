CREATE TABLE [Invoices].[t_SoldDeletedDetailProfitPartner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ID] DEFAULT (newsequentialid()),
[SoldDeletedID] [uniqueidentifier] NOT NULL,
[SoldDeletedDetailID] [uniqueidentifier] NOT NULL,
[ProfitPartnerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitPartnerID] DEFAULT ([Items].[f_ProfitPartnerGetFirstID]()),
[ProfitPartner] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitPartner] DEFAULT ([Items].[f_ProfitPartnerGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitRatio] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_ProfitEuro] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldDeletedDetailProfitPartner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetailProfitPartner] ADD CONSTRAINT [PK_t_SoldDeletedDetailProfitPartner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetailProfitPartner] ADD CONSTRAINT [ProfitPartnerKeySoldDeletedDetailProfitPartner] FOREIGN KEY ([ProfitPartnerID]) REFERENCES [Items].[t_ProfitPartner] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetailProfitPartner] ADD CONSTRAINT [SoldDeletedDetailKeySoldDeletedDetailProfitPartner] FOREIGN KEY ([SoldDeletedDetailID]) REFERENCES [Invoices].[t_SoldDeletedDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeletedDetailProfitPartner] ADD CONSTRAINT [SoldDeletedKeySoldDeletedDetailProfitPartner] FOREIGN KEY ([SoldDeletedID]) REFERENCES [Invoices].[t_SoldDeleted] ([ID])
GO
