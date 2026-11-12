CREATE TABLE [Cars].[t_CarRentalDriver]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalDriver_ID] DEFAULT (newsequentialid()),
[CarRentalID] [uniqueidentifier] NOT NULL,
[CarDriverID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalDriver_CarDriverID] DEFAULT ([Cars].[f_CarDriverGetFirstID]()),
[CarDriver] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalDriver_CarDriver] DEFAULT ([Cars].[f_CarDriverGetFirstName]()),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRentalDriver_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRentalDriver_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalDriver_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarRentalDriver_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [Cars].[tr_CarRentalDriver] ON [Cars].[t_CarRentalDriver]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarRentalDriver
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarRentalDriverSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarRentalDriver.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carRentalDriver'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carRentalDriver'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarRentalDriver, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;


GO
ALTER TABLE [Cars].[t_CarRentalDriver] ADD CONSTRAINT [PK_t_CarRentalDriver] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarRentalDriver] ADD CONSTRAINT [CarDriverKeyCarRentalDriver] FOREIGN KEY ([CarDriverID]) REFERENCES [Cars].[t_CarDriver] ([ID])
GO
ALTER TABLE [Cars].[t_CarRentalDriver] ADD CONSTRAINT [CarRentalKeyCarRentalDriver] FOREIGN KEY ([CarRentalID]) REFERENCES [Cars].[t_CarRental] ([ID])
GO
