CREATE TABLE [Employees].[t_BonusHistory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BonusHistory_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_BonusHistory_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_RefF] DEFAULT ('0'),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_BonusHistory_DateIs] DEFAULT (getdate()),
[EmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BonusHistory_EmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[Employee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_Employee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[TypeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BonusHistory_TypeID] DEFAULT ([Employees].[f_BonusTypeGetFirstID]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_TypeIs] DEFAULT ([Employees].[f_BonusTypeGetFirstName]()),
[FromEmployeeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BonusHistory_FromEmployeeID] DEFAULT ([Employees].[f_EmployeeGetFirstID]()),
[FromEmployee] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_FromEmployee] DEFAULT ([Employees].[f_EmployeeGetFirstName]()),
[ImplementationIn] [date] NOT NULL CONSTRAINT [DF_t_BonusHistory_ImplementationIn] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_BonusHistory_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_BonusHistory_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ValueIs] [float] NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIs] DEFAULT ((0)),
[ValueIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIsF] DEFAULT (''),
[ValueIsD] [float] NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIsD] DEFAULT ((0)),
[ValueIsLL] [float] NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIsLL] DEFAULT ((0)),
[ValueIsEuro] [float] NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIsEuro] DEFAULT ((0)),
[ValueIsAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIsAR] DEFAULT (''),
[ValueIsEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_ValueIsEN] DEFAULT (''),
[Why] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_BonusHistory_Note] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_BonusHistory_StatusIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_BonusHistory_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_BonusHistory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [Employees].[tr_BonusHistory] ON [Employees].[t_BonusHistory]
    AFTER INSERT, UPDATE, DELETE
AS
    BEGIN
                
        BEGIN--Live

            UPDATE  Alls.t_LiveVersion
            SET     VersionLive = STUFF(VersionLive, EmployeeBonus, 3,
                                        FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                               '000')) ,
                    SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3,
                                      FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                             '000'));

        END;

    END;
GO
ALTER TABLE [Employees].[t_BonusHistory] ADD CONSTRAINT [PK_t_BonusHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_BonusHistory_Ref] ON [Employees].[t_BonusHistory] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_BonusHistory] ADD CONSTRAINT [BonusTypeKeyBonusHistory] FOREIGN KEY ([TypeID]) REFERENCES [Employees].[t_BonusType] ([ID])
GO
ALTER TABLE [Employees].[t_BonusHistory] ADD CONSTRAINT [CurrencyKeyBonusHistory] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Employees].[t_BonusHistory] ADD CONSTRAINT [EmployeeFromKeyBonusHistory] FOREIGN KEY ([FromEmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
ALTER TABLE [Employees].[t_BonusHistory] ADD CONSTRAINT [EmployeeKeyBonusHistory] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees].[t_Employee] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Normal
1 = Canceled
2 = IsPayment', 'SCHEMA', N'Employees', 'TABLE', N't_BonusHistory', 'COLUMN', N'StatusIs'
GO
