CREATE TABLE [Invoices].[t_SoldDetailProfitPartner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ID] DEFAULT (newsequentialid()),
[SoldID] [uniqueidentifier] NOT NULL,
[SoldDetailID] [uniqueidentifier] NOT NULL,
[ProfitPartnerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitPartnerID] DEFAULT ([Items].[f_ProfitPartnerGetFirstID]()),
[ProfitPartner] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitPartner] DEFAULT ([Items].[f_ProfitPartnerGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitRatio] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_ProfitEuro] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SoldDetailProfitPartner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Invoices].[tr_SoldDetailProfitPartner] ON [Invoices].[t_SoldDetailProfitPartner]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Invoices.t_SoldDetailProfitPartner
    SET     IsSync = 0 ,
            SearchText = Invoices.f_SoldDetailProfitPartnerSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SoldDetailProfitPartner.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'soldDetailProfitPartner'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'soldDetailProfitPartner'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SoldDetailProfitPartner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaInvoice, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;



GO
ALTER TABLE [Invoices].[t_SoldDetailProfitPartner] ADD CONSTRAINT [PK_t_SoldDetailProfitPartner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Invoices].[t_SoldDetailProfitPartner] ADD CONSTRAINT [ProfitPartnerKeySoldDetailProfitPartner] FOREIGN KEY ([ProfitPartnerID]) REFERENCES [Items].[t_ProfitPartner] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDetailProfitPartner] ADD CONSTRAINT [SoldDetailKeySoldDetailProfitPartner] FOREIGN KEY ([SoldDetailID]) REFERENCES [Invoices].[t_SoldDetail] ([ID])
GO
ALTER TABLE [Invoices].[t_SoldDetailProfitPartner] ADD CONSTRAINT [SoldKeySoldDetailProfitPartner] FOREIGN KEY ([SoldID]) REFERENCES [Invoices].[t_Sold] ([ID])
GO
