CREATE TABLE [Transactions].[t_Transaction]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Transaction_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL,
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_RefF] DEFAULT (''),
[TypeIs] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_TypeIs] DEFAULT ('JV'),
[BalanceType] [tinyint] NOT NULL CONSTRAINT [DF_t_Transaction_BalanceType] DEFAULT ((0)),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_Transaction_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_Transaction_DateOnly] DEFAULT (getdate()),
[DateFirstDayInMonth] [date] NOT NULL CONSTRAINT [DF_t_Transaction_DateFirstDayInMonth] DEFAULT (getdate()),
[DateFirstDayInYear] [date] NOT NULL CONSTRAINT [DF_t_Transaction_DateFirstDayInYear] DEFAULT (getdate()),
[UserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Transaction_UserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[UserIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_UserIs] DEFAULT ([Users].[f_UserGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_DescriptionIs] DEFAULT (''),
[LinkType] [tinyint] NOT NULL CONSTRAINT [DF_t_Transaction_LinkType] DEFAULT ((69)),
[LinkTypeSub] [tinyint] NOT NULL CONSTRAINT [DF_t_Transaction_LinkTypeSub] DEFAULT ((0)),
[LinkID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Transaction_LinkID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[SubLinkID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Transaction_SubLinkID] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_Transaction_BalanceD] DEFAULT ((0)),
[BalanceDF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_BalanceDF] DEFAULT ('0'),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_Transaction_BalanceLL] DEFAULT ((0)),
[BalanceLLF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_BalanceLLF] DEFAULT ('0'),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_Transaction_BalanceEuro] DEFAULT ((0)),
[BalanceEuroF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_BalanceEuroF] DEFAULT ('0'),
[AccountsNames] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Transaction_AccountsNames] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Transaction_DateCreate] DEFAULT (getdate()),
[DetailsCount] [int] NOT NULL CONSTRAINT [DF_t_Transaction_DetailsCount] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Transaction_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Transaction_WorkStationID] DEFAULT ((1))
) ON [Transactions] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Transactions].[tr_Transaction] ON [Transactions].[t_Transaction]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Transactions.t_Transaction
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Transaction.ID );

  END;

  IF UPDATE(BalanceD)
    OR UPDATE(BalanceLL)
    OR UPDATE(BalanceEuro)
  BEGIN

    BEGIN --Fix

      UPDATE  Transactions.t_Transaction
      SET     BalanceDF = Currencys.f_FormatD(BalanceD) ,
              BalanceLLF = Currencys.f_FormatLL(BalanceLL) ,
              BalanceEuroF = Currencys.f_FormatEuro(BalanceEuro)
      WHERE   EXISTS ( SELECT TOP ( 1 )
                              s.ID
                       FROM   Inserted AS s
                       WHERE  s.ID = t_Transaction.ID );

    END;

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'transaction'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'transaction'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, TransactionIs, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaTransaction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SystemNotification, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaAll, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Transactions].[t_Transaction] ADD CONSTRAINT [PK_t_Transaction] PRIMARY KEY CLUSTERED  ([ID]) ON [Transactions]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Transaction_Ref_TypeIs] ON [Transactions].[t_Transaction] ([Ref], [TypeIs]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_t_Transaction_Type] ON [Transactions].[t_Transaction] ([TypeIs]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Normal = 0
Opening Balance = 1
Ending Balance = 2', 'SCHEMA', N'Transactions', 'TABLE', N't_Transaction', 'COLUMN', N'BalanceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase = 0
ReturnPurchased = 1
Sell = 2
ReturnSold = 3
Expense = 8
OpenBox = 9
paySalary = 11
InternetSubscription = 18
None = 69
Cheque = 81
Bond = 112
CloseBox = 160
DeliveryService = 162
FrameJobOrder = 169
GymSubscription = 174
CarExpenses = 182
CarRental = 185', 'SCHEMA', N'Transactions', 'TABLE', N't_Transaction', 'COLUMN', N'LinkType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'None = 0
DeliveryServiceVendorJV = 1
DeliveryServiceVendorPV = 2
DeliveryServiceCustomerJV = 3
DeliveryServiceCustomerRV = 4
DeliveryServiceEmployeeSalaryJV = 5
DeliveryServiceEmployeeJV = 6
SoldSalespersonSellJV = 7
SoldSalespersonJV = 8
CarRentalPayment = 9
CarRentalTaxPayment = 10
CarRentalOwnerPayment = 11', 'SCHEMA', N'Transactions', 'TABLE', N't_Transaction', 'COLUMN', N'LinkTypeSub'
GO
EXEC sp_addextendedproperty N'MS_Description', N'JV
RV
PV', 'SCHEMA', N'Transactions', 'TABLE', N't_Transaction', 'COLUMN', N'TypeIs'
GO
