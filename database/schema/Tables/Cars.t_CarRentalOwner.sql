CREATE TABLE [Cars].[t_CarRentalOwner]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_ID] DEFAULT (newsequentialid()),
[CarRentalID] [uniqueidentifier] NOT NULL,
[OwnerProfileID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_OwnerProfileID] DEFAULT ([Cars].[f_CarOwnersProfileGetFirstID]()),
[OwnerProfile] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalOwner_OwnerProfile] DEFAULT ([Cars].[f_CarOwnersProfileGetFirstName]()),
[ProfitRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_CarRentalOwner_ProfitRatio] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalOwner_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_ProfitEuro] DEFAULT ((0)),
[Paid] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_Paid] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalOwner_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarRentalOwner_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarRentalOwner] ON [Cars].[t_CarRentalOwner]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarRentalOwner
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarRentalOwnerSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarRentalOwner.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carRentalOwner'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carRentalOwner'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarRentalOwner, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarRentalOwner] ADD CONSTRAINT [PK_t_CarRentalOwner] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarRentalOwner] ADD CONSTRAINT [CarOwnersProfileKeyCarRentalOwner] FOREIGN KEY ([OwnerProfileID]) REFERENCES [Cars].[t_CarOwnersProfile] ([ID])
GO
ALTER TABLE [Cars].[t_CarRentalOwner] ADD CONSTRAINT [CarRentalKeyCarRentalOwner] FOREIGN KEY ([CarRentalID]) REFERENCES [Cars].[t_CarRental] ([ID])
GO
