CREATE TABLE [Customers].[t_InternetPackage]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetPackage_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_Name] DEFAULT ('-'),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_InternetPackage_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[Cost] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_Cost] DEFAULT ((0)),
[CostF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_CostF] DEFAULT ('0'),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_CostEuro] DEFAULT ((0)),
[Price] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_Price] DEFAULT ((0)),
[PriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_PriceF] DEFAULT ('0'),
[PriceD] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_PriceD] DEFAULT ((0)),
[PriceLL] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_PriceLL] DEFAULT ((0)),
[PriceEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_PriceEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_InternetPackage_ProfitEuro] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_InternetPackage_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_InternetPackage_DateCreate] DEFAULT (getdate()),
[TotalCustomers] [bigint] NOT NULL CONSTRAINT [DF_t_InternetPackage_TotalCustomers] DEFAULT ((0)),
[TotalSubscriptions] [bigint] NOT NULL CONSTRAINT [DF_t_InternetPackage_TotalSubscriptions] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_InternetPackage_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_InternetPackage_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Customers].[tr_InternetPackage] ON [Customers].[t_InternetPackage]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_InternetPackage
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_InternetPackage.ID );

  END;
	
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'internetPackage'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'internetPackage'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, InternetPackage, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Customers].[t_InternetPackage] ADD CONSTRAINT [PK_t_InternetPackage] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_InternetPackage_Name] ON [Customers].[t_InternetPackage] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_InternetPackage] ADD CONSTRAINT [CurrencyKeyInternetPackage] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
