CREATE TABLE [Cars].[t_CarRentalHistoryDriver]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_ID] DEFAULT (newsequentialid()),
[CarRentalHistoryID] [uniqueidentifier] NOT NULL,
[CarDriverID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_CarDriverID] DEFAULT ([Cars].[f_CarDriverGetFirstID]()),
[CarDriver] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_CarDriver] DEFAULT ([Cars].[f_CarDriverGetFirstName]()),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarRentalHistoryDriver_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE TRIGGER [Cars].[tr_CarRentalHistoryDriver] ON [Cars].[t_CarRentalHistoryDriver]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarRentalHistoryDriver
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarRentalHistoryDriverSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarRentalHistoryDriver.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carRentalHistoryDriver'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carRentalHistoryDriver'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarRentalHistoryDriver, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;



GO
ALTER TABLE [Cars].[t_CarRentalHistoryDriver] ADD CONSTRAINT [PK_t_CarRentalHistoryDriver] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarRentalHistoryDriver] ADD CONSTRAINT [CarDriverKeyCarRentalHistoryDriver] FOREIGN KEY ([CarDriverID]) REFERENCES [Cars].[t_CarDriver] ([ID])
GO
ALTER TABLE [Cars].[t_CarRentalHistoryDriver] ADD CONSTRAINT [CarRentalHistoryKeyCarRentalHistoryDriver] FOREIGN KEY ([CarRentalHistoryID]) REFERENCES [Cars].[t_CarRentalHistory] ([ID])
GO
