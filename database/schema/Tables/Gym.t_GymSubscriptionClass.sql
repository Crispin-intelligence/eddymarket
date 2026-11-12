CREATE TABLE [Gym].[t_GymSubscriptionClass]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_ID] DEFAULT (newsequentialid()),
[SubscriptionID] [uniqueidentifier] NOT NULL,
[ClassID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_ClassID] DEFAULT ([Gym].[f_GymClassGetFirstID]()),
[ClassName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_ClassName] DEFAULT ([Gym].[f_GymClassGetFirstName]()),
[AccountEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_AccountEmployeeID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[AccountEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_AccountEmployee] DEFAULT ([Company].[f_AccountGetFirstName]()),
[AccountEmployeeNumber] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_AccountEmployeeNumber] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_PriceEuro] DEFAULT ((0)),
[SalaryPercent] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_SalaryPercent] DEFAULT ((0)),
[Salary] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_Salary] DEFAULT ((0)),
[SalaryF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_SalaryF] DEFAULT ('0'),
[SalaryD] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_SalaryD] DEFAULT ((0)),
[SalaryLL] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_SalaryLL] DEFAULT ((0)),
[SalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_SalaryEuro] DEFAULT ((0)),
[IsSalaryPaid] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_IsSalaryPaid] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_GymSubscriptionClass_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_GymSubscriptionClass] ON [Gym].[t_GymSubscriptionClass]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_GymSubscriptionClass
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_GymSubscriptionClass.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'gymSubscriptionClass'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'gymSubscriptionClass'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, GymSubscription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_GymSubscriptionClass] ADD CONSTRAINT [PK_t_GymSubscriptionClass] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_GymSubscriptionClass] ADD CONSTRAINT [AccountKeyGymSubscriptionClass] FOREIGN KEY ([AccountEmployeeID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionClass] ADD CONSTRAINT [GymClassKeyGymSubscriptionClass] FOREIGN KEY ([ClassID]) REFERENCES [Gym].[t_GymClass] ([ID])
GO
ALTER TABLE [Gym].[t_GymSubscriptionClass] ADD CONSTRAINT [GymSubscriptionKeyGymSubscriptionClass] FOREIGN KEY ([SubscriptionID]) REFERENCES [Gym].[t_GymSubscription] ([ID])
GO
