CREATE TABLE [Company].[t_CloseBox]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBox_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_CloseBox_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_RefF] DEFAULT ('0'),
[DateIs] [datetime] NOT NULL CONSTRAINT [DF_t_CloseBox_DateIs] DEFAULT (getdate()),
[DateOnly] [date] NOT NULL CONSTRAINT [DF_t_CloseBox_DateOnly] DEFAULT (getdate()),
[FromUserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBox_FromUserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[FromUser] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_FromUser] DEFAULT ([Users].[f_UserGetFirstName]()),
[ToUserID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBox_ToUserID] DEFAULT ([Users].[f_UserGetFirstID]()),
[ToUser] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_ToUser] DEFAULT ([Users].[f_UserGetFirstName]()),
[FromAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBox_FromAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[FromAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_FromAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[FromAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_FromAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[ToAccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBox_ToAccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ToAccount] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_ToAccount] DEFAULT ([Company].[f_AccountGetFirstName]()),
[ToAccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_ToAccountNumberF] DEFAULT ([Company].[f_AccountGetFirstNumberF]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBox_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CloseBox_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[Balance] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_Balance] DEFAULT ((0)),
[BalanceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceF] DEFAULT ('0'),
[BalanceD] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceD] DEFAULT ((0)),
[BalanceLL] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceLL] DEFAULT ((0)),
[BalanceEuro] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceEuro] DEFAULT ((0)),
[BalanceAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceAR] DEFAULT (''),
[BalanceEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceEN] DEFAULT (''),
[BalanceDifference] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceDifference] DEFAULT ((0)),
[BalanceDifferenceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceDifferenceF] DEFAULT ('0'),
[BalanceDifferenceD] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_BalanceDifferenceD] DEFAULT ((0)),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_TotalD] DEFAULT ((0)),
[TotalDF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_TotalDF] DEFAULT ('0'),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_TotalLL] DEFAULT ((0)),
[TotalLLF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_TotalLLF] DEFAULT ('0'),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CloseBox_TotalEuro] DEFAULT ((0)),
[TotalEuroF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_TotalEuroF] DEFAULT ('0'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBox_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CloseBox_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CloseBox_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CloseBox_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_CloseBox] ON [Company].[t_CloseBox]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_CloseBox
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CloseBox.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'closeBox'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'closeBox'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CloseBox, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_CloseBox] ADD CONSTRAINT [PK_t_CloseBox] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_CloseBox] ADD CONSTRAINT [AccountFromKeyCloseBox] FOREIGN KEY ([FromAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_CloseBox] ADD CONSTRAINT [AccountToKeyCloseBox] FOREIGN KEY ([ToAccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_CloseBox] ADD CONSTRAINT [CurrencyKeyCloseBox] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Company].[t_CloseBox] ADD CONSTRAINT [UserFromKeyCloseBox] FOREIGN KEY ([FromUserID]) REFERENCES [Users].[t_User] ([ID])
GO
ALTER TABLE [Company].[t_CloseBox] ADD CONSTRAINT [UserToKeyCloseBox] FOREIGN KEY ([ToUserID]) REFERENCES [Users].[t_User] ([ID])
GO
