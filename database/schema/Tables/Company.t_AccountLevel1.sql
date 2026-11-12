CREATE TABLE [Company].[t_AccountLevel1]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountLevel1_ID] DEFAULT (newsequentialid()),
[NumberIs] [bigint] NOT NULL CONSTRAINT [DF_t_AccountLevel1_NumberIs] DEFAULT ((0)),
[NumberF] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel1_NumberF] DEFAULT ('0'),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel1_Name] DEFAULT (''),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel1_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel1_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel1_BalanceEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel1_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel1_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountLevel1_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_AccountLevel1_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountLevel1_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountLevel1] ON [Company].[t_AccountLevel1]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_AccountLevel1
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_AccountLevel1.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'accountLevel1'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'accountLevel1'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_AccountLevel1] ADD CONSTRAINT [PK_t_AccountLevel1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel1_Name] ON [Company].[t_AccountLevel1] ([Name]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel1_NumberF] ON [Company].[t_AccountLevel1] ([NumberF]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel1_NumberIs] ON [Company].[t_AccountLevel1] ([NumberIs]) ON [PRIMARY]
GO
