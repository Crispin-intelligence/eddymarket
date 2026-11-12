CREATE TABLE [Company].[t_AccountItemPrice]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_ID] DEFAULT (newsequentialid()),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_AccountID] DEFAULT ([Company].[f_AccountGetFirstID]()),
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Unity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountItemPrice_Unity] DEFAULT ([Items].[f_UnityGetFirstName]()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountItemPrice_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Price] [float] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountItemPrice_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_PriceD] DEFAULT ((0)),
[DiscountIs] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_AccountItemPrice_DiscountIs] DEFAULT ((0)),
[DiscountIsF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountItemPrice_DiscountIsF] DEFAULT ('0 %'),
[SectionIs] [tinyint] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_TypeIs] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountItemPrice_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountItemPrice] ON [Company].[t_AccountItemPrice]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_AccountItemPrice
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_AccountItemPrice.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'accountItemPrice'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'accountItemPrice'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_AccountItemPrice] ADD CONSTRAINT [PK_t_AccountItemPrice] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_AccountItemPrice] ADD CONSTRAINT [AccountKeyAccountItemPrice] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Company].[t_AccountItemPrice] ADD CONSTRAINT [CurrencyKeyAccountItemPrice] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
ALTER TABLE [Company].[t_AccountItemPrice] ADD CONSTRAINT [ItemSharedKeyAccountItemPrice] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Company].[t_AccountItemPrice] ADD CONSTRAINT [UnityItemKeyAccountItemPrice] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase = 0
Sell = 2', 'SCHEMA', N'Company', 'TABLE', N't_AccountItemPrice', 'COLUMN', N'SectionIs'
GO
