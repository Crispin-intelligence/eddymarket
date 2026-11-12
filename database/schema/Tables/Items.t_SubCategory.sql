CREATE TABLE [Items].[t_SubCategory]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SubCategory_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (225) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubCategory_Name] DEFAULT ('-'),
[MainCategoryID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SubCategory_MainCategoryID] DEFAULT ([items].[f_MainCategoryGetFirstID]()),
[MainCategory] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubCategory_MainCategory] DEFAULT ([items].[f_MainCategoryGetFirstName]()),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubCategory_DescriptionIs] DEFAULT (''),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_SubCategory_ItemC] DEFAULT ((0)),
[PurchaseC] [bigint] NOT NULL CONSTRAINT [DF_t_SubCategory_PurchaseC] DEFAULT ((0)),
[PurchaseQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SubCategory_PurchaseQty] DEFAULT ((0)),
[PurchaseReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_SubCategory_PurchaseReturnC] DEFAULT ((0)),
[PurchaseReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SubCategory_PurchaseReturnQty] DEFAULT ((0)),
[SellC] [bigint] NOT NULL CONSTRAINT [DF_t_SubCategory_SellC] DEFAULT ((0)),
[SellQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SubCategory_SellQty] DEFAULT ((0)),
[SellReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_SubCategory_SellReturnC] DEFAULT ((0)),
[SellReturnQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SubCategory_SellReturnQty] DEFAULT ((0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_SubCategory_QuotationC] DEFAULT ((0)),
[QuotationQty] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_SubCategory_QuotationQty] DEFAULT ((0)),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SubCategory_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SubCategory_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SubCategory_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SubCategory_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Triggers

CREATE TRIGGER [Items].[tr_SubCategory]
ON [Items].[t_SubCategory]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    IF NOT UPDATE(IsSync)
    BEGIN

        BEGIN --Declare

            DECLARE @IDs AS TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL
            );

        END;

        BEGIN --Set info

            INSERT @IDs
            (
                ID
            )
            SELECT s.ID
            FROM Inserted AS s;

        END;

        BEGIN --Fix

            UPDATE Items.t_SubCategory
            SET IsSync = 0
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDs AS s WHERE s.ID = t_SubCategory.ID
            );

        END;

    END;

    BEGIN --For delete

        INSERT INTO Alls.t_FireStoreRowsForDelete
        (
            DocumentID,
            HasImage,
            TableName
        )
        SELECT s.ID,
               0,
               'subCategory'
        FROM Deleted AS s
        EXCEPT
        SELECT s.ID,
               0,
               'subCategory'
        FROM Inserted AS s;

    END;

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, SubCategory, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Items].[t_SubCategory] ADD CONSTRAINT [c_t_SubCategory_Name] CHECK ((ltrim([Name])<>''))
GO
ALTER TABLE [Items].[t_SubCategory] ADD CONSTRAINT [PK_t_SubCategory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_SubCategory_Name_MainCategoryID] ON [Items].[t_SubCategory] ([Name], [MainCategoryID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_SubCategory] ADD CONSTRAINT [MainCategoryKeySubCategory] FOREIGN KEY ([MainCategoryID]) REFERENCES [Items].[t_MainCategory] ([ID])
GO
