CREATE TABLE [Company].[t_AccountLevel2]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountLevel2_ID] DEFAULT (newsequentialid()),
[Level1ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountLevel2_Level1ID] DEFAULT ([Company].[f_AccountLevel1GetFirstID]()),
[Level1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel2_Level1] DEFAULT ([Company].[f_AccountLevel1GetFirstName]()),
[NumberIs] [bigint] NOT NULL CONSTRAINT [DF_t_AccountLevel2_NumberIs] DEFAULT ((0)),
[NumberF] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel2_NumberF] DEFAULT ('0'),
[NumberNet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel2_NumberNet] DEFAULT ('0'),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel2_Name] DEFAULT (''),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel2_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel2_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_AccountLevel2_BalanceEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel2_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountLevel2_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountLevel2_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_AccountLevel2_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountLevel2_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountLevel2] ON [Company].[t_AccountLevel2]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_AccountLevel2
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_AccountLevel2.ID );

  END;

  BEGIN --Declare

    DECLARE @IDs TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

    DECLARE @AccountLevel1 TABLE
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

    INSERT  INTO @AccountLevel1
            ( ID ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro
            )
    SELECT  o.Level1ID ,
            ISNULL(SUM(o.BalanceD), 0) ,
            ISNULL(SUM(o.BalanceLL), 0) ,
            ISNULL(SUM(o.BalanceEuro), 0)
    FROM    ( SELECT  t.Level1ID ,
                      t.BalanceD ,
                      t.BalanceLL ,
                      t.BalanceEuro
              FROM    Inserted AS t
              UNION ALL
              SELECT  t.Level1ID ,
                      0 - t.BalanceD ,
                      0 - t.BalanceLL ,
                      0 - t.BalanceEuro
              FROM    Deleted AS t
            ) AS o
    GROUP BY o.Level1ID;

  END;

  BEGIN --Fix AccountLevel1

    MERGE Company.t_AccountLevel1 AS t
    USING @AccountLevel1 AS s
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
            'accountLevel2'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'accountLevel2'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_AccountLevel2] ADD CONSTRAINT [PK_t_AccountLevel2] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel2_NumberF] ON [Company].[t_AccountLevel2] ([NumberF]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_AccountLevel2_NumberIs] ON [Company].[t_AccountLevel2] ([NumberIs]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountLevel2] ADD CONSTRAINT [AccountLevel1KeyAccountLevel2] FOREIGN KEY ([Level1ID]) REFERENCES [Company].[t_AccountLevel1] ([ID])
GO
