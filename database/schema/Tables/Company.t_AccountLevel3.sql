CREATE TABLE [Company].[t_AccountLevel3]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountLevel3_ID] DEFAULT (newsequentialid()),
[Level2ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountLevel3_Level2ID] DEFAULT ([Company].[f_AccountLevel2GetFirstID]()),
[Level2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel3_Level2] DEFAULT ([Company].[f_AccountLevel2GetFirstName]()),
[NumberIs] [bigint] NOT NULL CONSTRAINT [DF_t_AccountLevel3_NumberIs] DEFAULT ((0)),
[NumberF] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel3_NumberF] DEFAULT ('0'),
[NumberNet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel3_NumberNet] DEFAULT ('0'),
[Name] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel3_Name] DEFAULT (''),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel3_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel3_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel3_BalanceEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel3_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel3_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountLevel3_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_AccountLevel3_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountLevel3_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountLevel3] ON [Company].[t_AccountLevel3]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_AccountLevel3
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_AccountLevel3.ID );

  END;

  BEGIN --Declare

    DECLARE @IDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

    DECLARE @AccountLevel2 TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        BalanceD FLOAT NOT NULL ,
        BalanceLL FLOAT NOT NULL ,
        BalanceEuro FLOAT NOT NULL
      );

  END;

  BEGIN --Set info

    INSERT  INTO @IDs
            ( ID )
    SELECT  t.ID
    FROM    Inserted AS t;

    INSERT  INTO @AccountLevel2
            ( ID ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro
            )
    SELECT  o.Level2ID ,
            ISNULL(SUM(o.BalanceD), 0) ,
            ISNULL(SUM(o.BalanceLL), 0) ,
            ISNULL(SUM(o.BalanceEuro), 0)
    FROM    ( SELECT  t.Level2ID ,
                      t.BalanceD ,
                      t.BalanceLL ,
                      t.BalanceEuro
              FROM    Inserted AS t
              UNION ALL
              SELECT  t.Level2ID ,
                      0 - t.BalanceD ,
                      0 - t.BalanceLL ,
                      0 - t.BalanceEuro
              FROM    Deleted AS t
            ) AS o
    GROUP BY o.Level2ID;

  END;

  BEGIN --Fix AccountLevel2

    MERGE Company.t_AccountLevel2 AS t
    USING @AccountLevel2 AS s
    ON s.ID = t.ID
    WHEN MATCHED THEN
      UPDATE SET
               t.BalanceD += s.BalanceD ,
               t.BalanceLL += s.BalanceLL ,
               t.BalanceEuro += s.BalanceEuro;

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'accountLevel3'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'accountLevel3'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_AccountLevel3] ADD CONSTRAINT [PK_t_AccountLevel3] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel3_NumberF] ON [Company].[t_AccountLevel3] ([NumberF]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel3_NumberIs] ON [Company].[t_AccountLevel3] ([NumberIs]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountLevel3] ADD CONSTRAINT [AccountLevel2KeyAccountLevel3] FOREIGN KEY ([Level2ID]) REFERENCES [Company].[t_AccountLevel2] ([ID])
GO
