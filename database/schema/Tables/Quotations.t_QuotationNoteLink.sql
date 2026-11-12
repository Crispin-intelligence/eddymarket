CREATE TABLE [Quotations].[t_QuotationNoteLink]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationNoteLink_ID] DEFAULT (newsequentialid()),
[QuotationID] [uniqueidentifier] NOT NULL,
[NoteID] [uniqueidentifier] NOT NULL,
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_QuotationNoteLink_SortAt] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationNoteLink_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationNoteLink_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationNoteLink] ADD CONSTRAINT [PK_t_QuotationNoteLink] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Quotations].[t_QuotationNoteLink] ADD CONSTRAINT [QuotationKeyQuotationNoteLink] FOREIGN KEY ([QuotationID]) REFERENCES [Quotations].[t_Quotation] ([ID])
GO
ALTER TABLE [Quotations].[t_QuotationNoteLink] ADD CONSTRAINT [QuotationNoteKeyQuotationNoteLink] FOREIGN KEY ([NoteID]) REFERENCES [Quotations].[t_QuotationNote] ([ID])
GO
