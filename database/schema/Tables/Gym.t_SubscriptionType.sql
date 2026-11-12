CREATE TABLE [Gym].[t_SubscriptionType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SubscriptionType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_Name] DEFAULT ('-'),
[NameF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_NameF] DEFAULT ('- daily - 0 L.L. - '),
[TypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_SubscriptionType_TypeIs] DEFAULT ((0)),
[NumberIs] [int] NOT NULL CONSTRAINT [DF_t_SubscriptionType_NumberIs] DEFAULT ((0)),
[TimePeriodDays] [int] NOT NULL CONSTRAINT [DF_t_SubscriptionType_TimePeriodDays] DEFAULT ((0)),
[TimePeriodARF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_TimePeriodARF] DEFAULT ('0 أيام'),
[TimePeriodENF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_TimePeriodENF] DEFAULT ('0 Days'),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SubscriptionType_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstIDLL]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstNameLL]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_SubscriptionType_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_PriceF] DEFAULT ('0 L.L.'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_SubscriptionType_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_SubscriptionType_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_SubscriptionType_PriceEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubscriptionType_DescriptionIs] DEFAULT (''),
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_t_SubscriptionType_IsEnabled] DEFAULT ((1)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SubscriptionType_DateCreate] DEFAULT (getdate()),
[NumberOfSubscriptions] [bigint] NOT NULL CONSTRAINT [DF_t_SubscriptionType_NumberOfSubscriptions] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SubscriptionType_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SubscriptionType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Gym].[tr_SubscriptionType] ON [Gym].[t_SubscriptionType]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Gym.t_SubscriptionType
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SubscriptionType.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'subscriptionType'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'subscriptionType'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SubscriptionType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaGym, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Gym].[t_SubscriptionType] ADD CONSTRAINT [PK_t_SubscriptionType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gym].[t_SubscriptionType] ADD CONSTRAINT [CurrencyKeySubscriptionType] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Daily = 0
Weekly = 1
Monthly = 2
Yearly = 3', 'SCHEMA', N'Gym', 'TABLE', N't_SubscriptionType', 'COLUMN', N'TypeIs'
GO
