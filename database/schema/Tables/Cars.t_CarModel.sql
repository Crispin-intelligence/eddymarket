CREATE TABLE [Cars].[t_CarModel]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarModel_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarModel_Name] DEFAULT ('-'),
[CarMakeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarModel_CarMakeID] DEFAULT ([Cars].[f_CarModelGetFirstID]()),
[CarMake] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarModel_CarMake] DEFAULT ([Cars].[f_CarModelGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarModel_DescriptionIs] DEFAULT (''),
[CarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarModel_CarsCount] DEFAULT ((0)),
[AvailableCarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarModel_AvailableCarsCount] DEFAULT ((0)),
[UnavailableCarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarModel_UnavailableCarsCount] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarModel_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarModel_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarModel_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarModel_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarModel] ON [Cars].[t_CarModel]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarModel
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarModelSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarModel.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carModel'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carModel'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarModel, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarModel] ADD CONSTRAINT [PK_t_CarModel] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CarModel_MakeID_Name] ON [Cars].[t_CarModel] ([CarMakeID], [Name]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarModel] ADD CONSTRAINT [CarMakeKeyCarModel] FOREIGN KEY ([CarMakeID]) REFERENCES [Cars].[t_CarMake] ([ID])
GO
