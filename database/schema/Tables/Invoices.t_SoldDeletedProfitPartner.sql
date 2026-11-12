CREATE TABLE [Invoices].[t_SoldDeletedProfitPartner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ID] DEFAULT (newsequentialid()),
[SoldDeletedID] [uniqueidentifier] NOT NULL,
[ProfitPartnerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitPartnerID] DEFAULT ([Items].[f_ProfitPartnerGetFirstID]()),
[ProfitPartner] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitPartner] DEFAULT ([Items].[f_ProfitPartnerGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitRatio] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_ProfitEuro] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldDeletedProfitPartner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDeletedProfitPartner] ADD CONSTRAINT [PK_t_SoldDeletedProfitPartner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDeletedProfitPartner] ADD CONSTRAINT [ProfitPartnerKeySoldDeletedProfitPartner] FOREIGN KEY ([ProfitPartnerID]) REFERENCES [Items].[t_ProfitPartner] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDeletedProfitPartner] ADD CONSTRAINT [SoldDeletedKeySoldDeletedProfitPartner] FOREIGN KEY ([SoldDeletedID]) REFERENCES [Invoices].[t_SoldDeleted] ([ID])
GO
