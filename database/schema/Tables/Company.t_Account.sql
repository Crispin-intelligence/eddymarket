CREATE TABLE [Company].[t_Account]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Account_ID] DEFAULT (newsequentialid()),
[Level3ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Account_Level3ID] DEFAULT ([Company].[f_AccountLevel3GetFirstID]()),
[Level3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_Level3] DEFAULT ([Company].[f_AccountLevel3GetFirstName]()),
[SectionID] [int] NOT NULL CONSTRAINT [DF_t_Account_SectionID] DEFAULT ((69)),
[LinkWithID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Account_LinkWithID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[LinkWith] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_LinkWith] DEFAULT (''),
[IsMasterLink] [bit] NOT NULL CONSTRAINT [DF_t_Account_IsMasterLink] DEFAULT ((0)),
[NumberIs] [bigint] NOT NULL CONSTRAINT [DF_t_Account_NumberIs] DEFAULT ((0)),
[NumberF] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_NumberF] DEFAULT ('0'),
[NumberNet] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_NumberNet] DEFAULT ('0'),
[Name] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL,
[Balance] [float] NOT NULL CONSTRAINT [DF_t_Account_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_Account_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_Account_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_Account_BalanceEuro] DEFAULT ((0)),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Account_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[CurrencyTypeIs] [int] NOT NULL CONSTRAINT [DF_t_Account_CurrencyTypeIs] DEFAULT ([Currencys].[f_CurrencyGetFirstTypeIs]()),
[Limit] [float] NOT NULL CONSTRAINT [DF_t_Account_Limit] DEFAULT ((0)),
[LimitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_LimitF] DEFAULT ('0 $'),
[LimitD] [float] NOT NULL CONSTRAINT [DF_t_Account_LimitD] DEFAULT ((0)),
[IsStatic] [bit] NOT NULL CONSTRAINT [DF_t_Account_IsStatic] DEFAULT ((0)),
[ShowInGymClass] [bit] NOT NULL CONSTRAINT [DF_t_Account_ShowInGymClass] DEFAULT ((1)),
[ShowInPersonalTrainer] [bit] NOT NULL CONSTRAINT [DF_t_Account_ShowInPersonalTrainer] DEFAULT ((1)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_NoteIs] DEFAULT (''),
[UserBlockedC] [int] NOT NULL CONSTRAINT [DF_t_Account_UserBlockedC] DEFAULT ((0)),
[UsersNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_UsersNames] DEFAULT (''),
[AccountMergeC] [int] NOT NULL CONSTRAINT [DF_t_Account_AccountMergeC] DEFAULT ((0)),
[AccountMergeNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_AccountMergeNames] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Account_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_WhyThisStatus] DEFAULT (''),
[LastAction] [date] NOT NULL CONSTRAINT [DF_t_Account_LastAction] DEFAULT (getdate()),
[MakeInactiveAfter] [int] NOT NULL CONSTRAINT [DF_t_Account_MakeInactiveAfter] DEFAULT ((0)),
[MakeInactiveAfterType] [tinyint] NOT NULL CONSTRAINT [DF_t_Account_MakeInactiveAfterType] DEFAULT ((2)),
[DeliveryServicesC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_DeliveryServicesC] DEFAULT ((0)),
[DeliveryServicesTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_DeliveryServicesTotal] DEFAULT ((0)),
[DeliveryServicesTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_DeliveryServicesTotalF] DEFAULT ('0'),
[DeliveryServicesProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_DeliveryServicesProfit] DEFAULT ((0)),
[DeliveryServicesProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_DeliveryServicesProfitF] DEFAULT ('0'),
[DeliveryServicesLastDate] [date] NOT NULL CONSTRAINT [DF_t_Account_DeliveryServicesLastDate] DEFAULT (datefromparts((2000),(1),(1))),
[PurchasingC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_PurchasingC] DEFAULT ((0)),
[PurchasingTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_PurchasingTotal] DEFAULT ((0)),
[PurchasingTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_PurchasingTotalF] DEFAULT ('0'),
[PurchasingProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_PurchasingProfit] DEFAULT ((0)),
[PurchasingProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_PurchasingProfitF] DEFAULT ('0'),
[PurchasingLast] [date] NOT NULL CONSTRAINT [DF_t_Account_PurchasingLast] DEFAULT (datefromparts((2000),(1),(1))),
[PurchasingReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_PurchasingReturnC] DEFAULT ((0)),
[PurchasingReturnTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_PurchasingReturnTotal] DEFAULT ((0)),
[PurchasingReturnTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_PurchasingReturnTotalF] DEFAULT ('0'),
[PurchasingReturnProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_PurchasingReturnProfit] DEFAULT ((0)),
[PurchasingReturnProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_PurchasingReturnProfitF] DEFAULT ('0'),
[PurchasingReturnLast] [date] NOT NULL CONSTRAINT [DF_t_Account_PurchasingReturnLast] DEFAULT (datefromparts((2000),(1),(1))),
[SoldC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_SoldC] DEFAULT ((0)),
[SoldTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_SoldTotal] DEFAULT ((0)),
[SoldTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_SoldTotalF] DEFAULT ('0'),
[SoldProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_SoldProfit] DEFAULT ((0)),
[SoldProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_SoldProfitF] DEFAULT ('0'),
[SoldLast] [date] NOT NULL CONSTRAINT [DF_t_Account_SoldLast] DEFAULT (datefromparts((2000),(1),(1))),
[SoldReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_SoldReturnC] DEFAULT ((0)),
[SoldReturnTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_SoldReturnTotal] DEFAULT ((0)),
[SoldReturnTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_SoldReturnTotalF] DEFAULT ('0'),
[SoldReturnProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_SoldReturnProfit] DEFAULT ((0)),
[SoldReturnProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_SoldReturnProfitF] DEFAULT ('0'),
[SoldReturnLast] [date] NOT NULL CONSTRAINT [DF_t_Account_SoldReturnLast] DEFAULT (datefromparts((2000),(1),(1))),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_QuotationC] DEFAULT ((0)),
[QuotationTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_QuotationTotal] DEFAULT ((0)),
[QuotationTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_QuotationTotalF] DEFAULT ('0'),
[QuotationProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_QuotationProfit] DEFAULT ((0)),
[QuotationProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_QuotationProfitF] DEFAULT ('0'),
[QuotationLast] [date] NOT NULL CONSTRAINT [DF_t_Account_QuotationLast] DEFAULT (datefromparts((2000),(1),(1))),
[GymSubscriptionIsActive] [bit] NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionIsActive] DEFAULT ((0)),
[GymSubscriptionActiveTo] [date] NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionActiveTo] DEFAULT (datefromparts((2000),(1),(1))),
[GymSubscriptionC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionC] DEFAULT ((0)),
[GymSubscriptionTotal] [float] NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionTotal] DEFAULT ((0)),
[GymSubscriptionTotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionTotalF] DEFAULT ('0'),
[GymSubscriptionProfit] [float] NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionProfit] DEFAULT ((0)),
[GymSubscriptionProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionProfitF] DEFAULT ('0'),
[GymSubscriptionLast] [date] NOT NULL CONSTRAINT [DF_t_Account_GymSubscriptionLast] DEFAULT (datefromparts((2000),(1),(1))),
[GymMemberAttendanceC] [bigint] NOT NULL CONSTRAINT [DF_t_Account_GymMemberAttendanceC] DEFAULT ((0)),
[GymMemberAttendanceLast] [date] NOT NULL CONSTRAINT [DF_t_Account_GymMemberAttendanceLast] DEFAULT (datefromparts((2000),(1),(1))),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Account_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Account_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Account_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Accounts_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Account] ON [Company].[t_Account]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_Account
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Account.ID );

  END;

  BEGIN --Declare

    DECLARE @IDs AS TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

    DECLARE @AccountLevel3 TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL ,
        BalanceD FLOAT NOT NULL ,
        BalanceLL FLOAT NOT NULL ,
        BalanceEuro FLOAT NOT NULL
      );

  END;

  BEGIN --Set info

    INSERT  @IDs
            ( ID )
    SELECT  s.ID
    FROM    Inserted AS s;

    INSERT  INTO @AccountLevel3
            ( ID ,
              BalanceD ,
              BalanceLL ,
              BalanceEuro
            )
    SELECT  o.Level3ID ,
            ISNULL(SUM(o.BalanceD), 0) ,
            ISNULL(SUM(o.BalanceLL), 0) ,
            ISNULL(SUM(o.BalanceEuro), 0)
    FROM    ( SELECT  t.Level3ID ,
                      t.BalanceD ,
                      t.BalanceLL ,
                      t.BalanceEuro
              FROM    Inserted AS t
              UNION ALL
              SELECT  t.Level3ID ,
                      0 - t.BalanceD ,
                      0 - t.BalanceLL ,
                      0 - t.BalanceEuro
              FROM    Deleted AS t
            ) AS o
    GROUP BY o.Level3ID;

  END;

  BEGIN --Format

    UPDATE  Company.t_Account
    SET     BalanceF = Currencys.f_Format(CurrencyID, Balance)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   @IDs AS s
                     WHERE  s.ID = t_Account.ID );

  END;

  BEGIN --Fix AccountLevel3

    MERGE Company.t_AccountLevel3 AS t
    USING @AccountLevel3 AS s
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
            'account'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'account'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Account, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_Account] ADD CONSTRAINT [CK_t_Account_Name] CHECK (([Name]<>''))
GO
ALTER TABLE [Company].[t_Account] ADD CONSTRAINT [PK_t_Account] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Account_NumberF] ON [Company].[t_Account] ([NumberF]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Account_NumberIs] ON [Company].[t_Account] ([NumberIs]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Account] ADD CONSTRAINT [AccountLevel3KeyAccount] FOREIGN KEY ([Level3ID]) REFERENCES [Company].[t_AccountLevel3] ([ID])
GO
ALTER TABLE [Company].[t_Account] ADD CONSTRAINT [CurrencyKeyAccount] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year = 0
Month = 1
Day = 2', 'SCHEMA', N'Company', 'TABLE', N't_Account', 'COLUMN', N'MakeInactiveAfterType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer = 15
Employee = 33
Bank = 38
Vendor = 67
None = 69
Sales Person = 149
CarOwnersProfile = 179', 'SCHEMA', N'Company', 'TABLE', N't_Account', 'COLUMN', N'SectionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Company', 'TABLE', N't_Account', 'COLUMN', N'StatusIs'
GO
