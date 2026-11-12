CREATE TABLE [Cars].[t_CarOwners]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarOwners_ID] DEFAULT (newsequentialid()),
[CarID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarOwners_CarID] DEFAULT ([Cars].[f_CarGetFirstID]()),
[Car] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarOwners_Car] DEFAULT ([Cars].[f_CarGetFirstName]()),
[OwnerProfileID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarOwners_OwnerProfileID] DEFAULT ([Cars].[f_CarOwnersProfileGetFirstID]()),
[OwnerProfile] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarOwners_OwnerProfile] DEFAULT ([Cars].[f_CarOwnersProfileGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_CarOwners_ProfitRatio] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarOwners_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarOwners_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarOwners_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarOwners_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarOwners] ON [Cars].[t_CarOwners]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarOwners
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarOwnersSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarOwners.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carOwners'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carOwners'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Car, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarOwners] ADD CONSTRAINT [PK_t_CarOwners] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarOwners] ADD CONSTRAINT [CarKeyCarOwners] FOREIGN KEY ([CarID]) REFERENCES [Cars].[t_Car] ([ID])
GO
ALTER TABLE [Cars].[t_CarOwners] ADD CONSTRAINT [CarOwnersProfileKeyCarOwners] FOREIGN KEY ([OwnerProfileID]) REFERENCES [Cars].[t_CarOwnersProfile] ([ID])
GO
