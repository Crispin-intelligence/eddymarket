CREATE TABLE [Items].[t_ProfitPartner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ProfitPartner_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ProfitPartner_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ProfitPartner_DescriptionIs] DEFAULT (''),
[ItemsCount] [bigint] NOT NULL CONSTRAINT [DF_t_ProfitPartner_ItemsCount] DEFAULT ((0)),
[SalesInvoicesCount] [bigint] NOT NULL CONSTRAINT [DF_t_ProfitPartner_SalesInvoicesCount] DEFAULT ((0)),
[TotalProfitD] [float] NOT NULL CONSTRAINT [DF_t_ProfitPartner_TotalProfitD] DEFAULT ((0)),
[TotalProfitLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitPartner_TotalProfitLL] DEFAULT ((0)),
[TotalProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitPartner_TotalProfitEuro] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ProfitPartner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ProfitPartner_DateCreate] DEFAULT (getdate()),
[IsMaster] [bit] NOT NULL CONSTRAINT [DF_t_ProfitPartner_IsMaster] DEFAULT ((0)),
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_t_ProfitPartner_IsEnabled] DEFAULT ((1)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ProfitPartner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ProfitPartner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ProfitPartner] ON [Items].[t_ProfitPartner]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ProfitPartner
    SET     IsSync = 0 ,
            SearchText = Items.f_ProfitPartnerSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ProfitPartner.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'profitPartner'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'profitPartner'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, ProfitPartner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Items].[t_ProfitPartner] ADD CONSTRAINT [PK_t_ProfitPartner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
