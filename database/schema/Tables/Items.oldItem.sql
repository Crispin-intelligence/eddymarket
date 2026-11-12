CREATE TABLE [Items].[oldItem]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_oldItem_ID] DEFAULT (newsequentialid()),
[name] [nvarchar] (max) COLLATE Arabic_CI_AS NULL,
[Barcode] [nvarchar] (max) COLLATE Arabic_CI_AS NULL,
[Qty] [int] NULL,
[PriceSell] [float] NULL,
[PricePurchase] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Items].[oldItem] ADD CONSTRAINT [PK_oldItem] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
