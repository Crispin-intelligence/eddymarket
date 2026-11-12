CREATE TABLE [Cars].[t_CarMake]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarMake_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarMake_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarMake_DescriptionIs] DEFAULT (''),
[ModelsCount] [int] NOT NULL CONSTRAINT [DF_t_CarMake_ModelsCount] DEFAULT ((0)),
[CarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarMake_CarsCount] DEFAULT ((0)),
[AvailableCarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarMake_AvailableCarsCount] DEFAULT ((0)),
[UnavailableCarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarMake_UnavailableCarsCount] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarMake_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarMake_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarMake_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarMake_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Cars].[tr_CarMake] ON [Cars].[t_CarMake]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarMake
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarMakeSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarMake.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carMake'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carMake'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarMake, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Cars].[t_CarMake] ADD CONSTRAINT [PK_t_CarMake] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CarMake_Name] ON [Cars].[t_CarMake] ([Name]) ON [PRIMARY]
GO
