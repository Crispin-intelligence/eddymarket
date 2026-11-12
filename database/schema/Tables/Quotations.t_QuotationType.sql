CREATE TABLE [Quotations].[t_QuotationType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_QuotationType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationType_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationType_DescriptionIs] DEFAULT (''),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationC] DEFAULT ((0)),
[QuotationTotalD] [float] NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationTotalD] DEFAULT ((0)),
[QuotationTotalDF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationTotalDF] DEFAULT ('0'),
[QuotationTotalLL] [float] NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationTotalLL] DEFAULT ((0)),
[QuotationTotalLLF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationTotalLLF] DEFAULT ('0'),
[QuotationTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationTotalEuro] DEFAULT ((0)),
[QuotationTotalEuroF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_QuotationType_QuotationTotalEuroF] DEFAULT ('0'),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_QuotationType_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_QuotationType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Quotations].[tr_QuotationType]
ON [Quotations].[t_QuotationType]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, QuotationType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaQuotation, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Quotations].[t_QuotationType] ADD CONSTRAINT [PK_t_QuotationType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_QuotationType_Name] ON [Quotations].[t_QuotationType] ([Name]) ON [PRIMARY]
GO
