CREATE TABLE [Invoices].[t_SoldProfitPartner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ID] DEFAULT (newsequentialid()),
[SoldID] [uniqueidentifier] NOT NULL,
[ProfitPartnerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitPartnerID] DEFAULT ([Items].[f_ProfitPartnerGetFirstID]()),
[ProfitPartner] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitPartner] DEFAULT ([Items].[f_ProfitPartnerGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitRatio] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_ProfitEuro] DEFAULT ((0)),
[Paid] [bit] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_Paid] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldProfitPartner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_SoldProfitPartner] ON [Invoices].[t_SoldProfitPartner]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_SoldProfitPartner
    SET     IsSync = 0 ,
            SearchText = Invoices.f_SoldProfitPartnerSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SoldProfitPartner.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'soldProfitPartner'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'soldProfitPartner'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SoldProfitPartner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Invoices].[t_SoldProfitPartner] ADD CONSTRAINT [PK_t_SoldProfitPartner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldProfitPartner] ADD CONSTRAINT [ProfitPartnerKeySoldProfitPartner] FOREIGN KEY ([ProfitPartnerID]) REFERENCES [Items].[t_ProfitPartner] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldProfitPartner] ADD CONSTRAINT [SoldKeySoldProfitPartner] FOREIGN KEY ([SoldID]) REFERENCES [Invoices].[t_Sold] ([ID])
GO
