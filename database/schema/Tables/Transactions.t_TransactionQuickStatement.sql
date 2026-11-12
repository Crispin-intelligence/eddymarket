CREATE TABLE [Transactions].[t_TransactionQuickStatement]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_Name] DEFAULT (''),
[ShortcutText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_ShortcutText] DEFAULT (''),
[SectionID] [int] NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_SectionID] DEFAULT ((69)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_DateCreate] DEFAULT (getdate()),
[CreateByID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_CreateByID] DEFAULT ([Users].[f_UserGetFirstID]()),
[CreateBy] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_CreateBy] DEFAULT ([Users].[f_UserGetFirstName]()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_TransactionQuickStatement_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Transactions].[tr_TransactionQuickStatement] ON [Transactions].[t_TransactionQuickStatement]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Transactions.t_TransactionQuickStatement
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_TransactionQuickStatement.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'transactionQuickStatement'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'transactionQuickStatement'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, TransactionQuickStatement, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaTransaction, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Transactions].[t_TransactionQuickStatement] ADD CONSTRAINT [PK_t_TransactionQuickStatement] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Transactions].[t_TransactionQuickStatement] ADD CONSTRAINT [UserKeyTransactionQuickStatement] FOREIGN KEY ([CreateByID]) REFERENCES [Users].[t_User] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchasing = 0
purchasingReturn = 1
Sold = 2
soldReturn = 3
None = 69', 'SCHEMA', N'Transactions', 'TABLE', N't_TransactionQuickStatement', 'COLUMN', N'SectionID'
GO
