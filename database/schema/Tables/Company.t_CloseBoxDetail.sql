CREATE TABLE [Company].[t_CloseBoxDetail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_ID] DEFAULT (newsequentialid()),
[CloseBoxID] [uniqueidentifier] NOT NULL,
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[CurrencyTypeIs] [tinyint] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_CurrencyTypeIs] DEFAULT ([Currencys].[f_CurrencyGetFirstTypeIs]()),
[Price] [float] NOT NULL,
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_PriceD] DEFAULT ((0)),
[Qty] [int] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_Qty] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_TotalF] DEFAULT ('0'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CloseBoxDetail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_CloseBoxDetail] ON [Company].[t_CloseBoxDetail]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_CloseBoxDetail
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CloseBoxDetail.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'closeBoxDetail'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'closeBoxDetail'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CloseBox, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Company].[t_CloseBoxDetail] ADD CONSTRAINT [PK_t_CloseBoxDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_CloseBoxDetail] ADD CONSTRAINT [CloseBoxKeyCloseBoxDetail] FOREIGN KEY ([CloseBoxID]) REFERENCES [Company].[t_CloseBox] ([ID])
GO
ALTER TABLE [Company].[t_CloseBoxDetail] ADD CONSTRAINT [CurrencyKeyCloseBoxDetail] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
