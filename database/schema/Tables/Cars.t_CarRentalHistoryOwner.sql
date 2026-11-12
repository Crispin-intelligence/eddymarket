CREATE TABLE [Cars].[t_CarRentalHistoryOwner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_ID] DEFAULT (newsequentialid()),
[CarRentalHistoryID] [uniqueidentifier] NOT NULL,
[OwnerProfileID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_OwnerProfileID] DEFAULT ([Cars].[f_CarOwnersProfileGetFirstID]()),
[OwnerProfile] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_OwnerProfile] DEFAULT ([Cars].[f_CarOwnersProfileGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_ProfitRatio] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_ProfitEuro] DEFAULT ((0)),
[Paid] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_Paid] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryOwner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarRentalHistoryOwner] ON [Cars].[t_CarRentalHistoryOwner]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarRentalHistoryOwner
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarRentalHistoryOwnerSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarRentalHistoryOwner.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carRentalHistoryOwner'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carRentalHistoryOwner'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarRentalHistoryOwner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarRentalHistoryOwner] ADD CONSTRAINT [PK_t_CarRentalHistoryOwner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarRentalHistoryOwner] ADD CONSTRAINT [CarOwnersProfileKeyCarRentalHistoryOwner] FOREIGN KEY ([OwnerProfileID]) REFERENCES [Cars].[t_CarOwnersProfile] ([ID])
GO
ALTER TABLE [Cars].[t_CarRentalHistoryOwner] ADD CONSTRAINT [CarRentalHistoryKeyCarRentalHistoryOwner] FOREIGN KEY ([CarRentalHistoryID]) REFERENCES [Cars].[t_CarRentalHistory] ([ID])
GO
