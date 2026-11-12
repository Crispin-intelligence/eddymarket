CREATE TABLE [Gym].[t_PersonalTrainer]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_Name] DEFAULT ('-'),
[NameF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_NameF] DEFAULT ('- 0 $'),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstIDLL]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstNameLL]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_PriceF] DEFAULT ('0 L.L.'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_PriceEuro] DEFAULT ((0)),
[SessionIs] [int] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_SessionIs] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_TotalF] DEFAULT ('0 L.L.'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_TotalEuro] DEFAULT ((0)),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_AccountEmployeeID] DEFAULT ([Company].[f_AccountEmployeeGetFirstID]()),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_AccountEmployee] DEFAULT ([Company].[f_AccountEmployeeGetFirstName]()),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_AccountEmployeeNumber] DEFAULT ([Company].[f_AccountEmployeeGetFirstNumberF]()),
[SalaryPercent] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_PersonalTrainer_SalaryPercent] DEFAULT ((0)),
[Salary] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_Salary] DEFAULT ((0)),
[SalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_SalaryF] DEFAULT ('0 L.L.'),
[SalaryD] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_SalaryD] DEFAULT ((0)),
[SalaryLL] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_SalaryLL] DEFAULT ((0)),
[SalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_SalaryEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_PersonalTrainer_DescriptionIs] DEFAULT (''),
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_IsEnabled] DEFAULT ((1)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_DateCreate] DEFAULT (getdate()),
[NumberOfSubscriptions] [bigint] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_NumberOfSubscriptions] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_PersonalTrainer_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_PersonalTrainer] ON [Gym].[t_PersonalTrainer]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_PersonalTrainer
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_PersonalTrainer.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'personalTrainer'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'personalTrainer'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, PersonalTrainer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_PersonalTrainer] ADD CONSTRAINT [PK_t_PersonalTrainer] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_PersonalTrainer_Name] ON [Gym].[t_PersonalTrainer] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_PersonalTrainer] ADD CONSTRAINT [AccountKeyPersonalTrainer] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID])
GO
