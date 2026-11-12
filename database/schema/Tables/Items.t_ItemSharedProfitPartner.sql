CREATE TABLE [Items].[t_ItemSharedProfitPartner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_ID] DEFAULT (newsequentialid()),
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ProfitPartnerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_ProfitPartnerID] DEFAULT ([Items].[f_ProfitPartnerGetFirstID]()),
[ProfitPartner] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_ProfitPartner] DEFAULT ([Items].[f_ProfitPartnerGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_ProfitRatio] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemSharedProfitPartner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [Items].[tr_ItemSharedProfitPartner] ON [Items].[t_ItemSharedProfitPartner]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Items.t_ItemSharedProfitPartner
    SET     IsSync = 0 ,
            SearchText = Items.f_ItemSharedProfitPartnerSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemSharedProfitPartner.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'ItemSharedProfitPartner'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'ItemSharedProfitPartner'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, ItemSharedProfitPartner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;


GO
ALTER TABLE [Items].[t_ItemSharedProfitPartner] ADD CONSTRAINT [PK_t_ItemSharedProfitPartner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemSharedProfitPartner] ADD CONSTRAINT [ItemSharedKeyItemSharedProfitPartner] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_ItemSharedProfitPartner] ADD CONSTRAINT [ProfitPartnerKeyItemSharedProfitPartner] FOREIGN KEY ([ProfitPartnerID]) REFERENCES [Items].[t_ProfitPartner] ([ID])
GO
