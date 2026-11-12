CREATE TABLE [Quotations].[t_QuotationNoteLinkHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationNoteLinkHistory_ID] DEFAULT (newsequentialid()),
[QuotationHistoryID] [uniqueidentifier] NOT NULL,
[NoteID] [uniqueidentifier] NOT NULL,
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_QuotationNoteLinkHistory_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationNoteLinkHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationNoteLinkHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationNoteLinkHistory] ADD CONSTRAINT [PK_t_QuotationNoteLinkHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationNoteLinkHistory] ADD CONSTRAINT [QuotationHistoryKeyQuotationNoteLinkHistory] FOREIGN KEY ([QuotationHistoryID]) REFERENCES [Quotations].[t_QuotationHistory] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationNoteLinkHistory] ADD CONSTRAINT [QuotationNoteKeyQuotationNoteLinkHistory] FOREIGN KEY ([NoteID]) REFERENCES [Quotations].[t_QuotationNote] ([ID])
GO
