CREATE TABLE [Cars].[t_CarClass]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarClass_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarClass_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarClass_DescriptionIs] DEFAULT (''),
[CarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarClass_CarsCount] DEFAULT ((0)),
[AvailableCarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarClass_AvailableCarsCount] DEFAULT ((0)),
[UnavailableCarsCount] [int] NOT NULL CONSTRAINT [DF_t_CarClass_UnavailableCarsCount] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarClass_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarClass_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarClass_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarClass_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarClass] ON [Cars].[t_CarClass]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarClass
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarClassSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarClass.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carClass'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carClass'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarClass, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarClass] ADD CONSTRAINT [PK_t_CarClass] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CarClass_Name] ON [Cars].[t_CarClass] ([Name]) ON [PRIMARY]
GO
