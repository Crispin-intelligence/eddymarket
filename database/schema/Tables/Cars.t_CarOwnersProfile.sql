CREATE TABLE [Cars].[t_CarOwnersProfile]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_DescriptionIs] DEFAULT (''),
[CarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_CarsCount] DEFAULT ((0)),
[CarRentalCount] [bigint] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_CarRentalCount] DEFAULT ((0)),
[TotalProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_TotalProfitD] DEFAULT ((0)),
[TotalProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_TotalProfitLL] DEFAULT ((0)),
[TotalProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_TotalProfitEuro] DEFAULT ((0)),
[CarRentalUnpaidCount] [bigint] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_CarRentalUnpaidCount] DEFAULT ((0)),
[UnpaidTotalProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_UnpaidTotalProfitD] DEFAULT ((0)),
[UnpaidTotalProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_UnpaidTotalProfitLL] DEFAULT ((0)),
[UnpaidTotalProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_UnpaidTotalProfitEuro] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarOwnersProfile_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarOwnersProfile] ON [Cars].[t_CarOwnersProfile]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarOwnersProfile
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarOwnersProfileSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarOwnersProfile.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carOwnersProfile'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carOwnersProfile'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarOwnersProfile, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarOwnersProfile] ADD CONSTRAINT [PK_t_CarOwnersProfile] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CarOwnersProfile_Name] ON [Cars].[t_CarOwnersProfile] ([Name]) ON [PRIMARY]
GO
