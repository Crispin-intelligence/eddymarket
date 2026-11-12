CREATE TABLE [Quotations].[t_QuotationNote]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationNote_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationNote_Name] DEFAULT ('-'),
[AutoInsert] [bit] NOT NULL CONSTRAINT [DF_t_QuotationNote_AutoInsert] DEFAULT ((1)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationNote_DescriptionIs] DEFAULT (''),
[SortAt] [float] NOT NULL CONSTRAINT [DF_t_QuotationNote_SortAt] DEFAULT ((0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationC] DEFAULT ((0)),
[QuotationTotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationTotalD] DEFAULT ((0)),
[QuotationTotalDF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationTotalDF] DEFAULT ('0'),
[QuotationTotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationTotalLL] DEFAULT ((0)),
[QuotationTotalLLF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationTotalLLF] DEFAULT ('0'),
[QuotationTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationTotalEuro] DEFAULT ((0)),
[QuotationTotalEuroF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationNote_QuotationTotalEuroF] DEFAULT ('0'),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationNote_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationNote_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Quotations].[tr_QuotationNote]
ON [Quotations].[t_QuotationNote]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, QuotationNote, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaQuotation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Quotations].[t_QuotationNote] ADD CONSTRAINT [PK_t_QuotationNote] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
