CREATE TABLE [Items].[t_ItemSharedMaterial]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_ID] DEFAULT (newsequentialid()),
[ItemSharedFatherID] [uniqueidentifier] NOT NULL,
[ItemSharedID] [uniqueidentifier] NOT NULL,
[ItemUnityID] [uniqueidentifier] NOT NULL,
[Qty] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_Qty] DEFAULT ((0)),
[QtyWithUnity] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_QtyWithUnity] DEFAULT (''),
[Qtys] [decimal] (18, 4) NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_Qtys] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_DateCreate] DEFAULT (getdate()),
[CreateByID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_CreateByID] DEFAULT ([users].[f_UserGetFirstID]()),
[CreateBy] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_CreateBy] DEFAULT ([Users].[f_UserGetFirstName]()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemSharedMaterial_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemSharedMaterial]
ON [Items].[t_ItemSharedMaterial]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live Item

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;

GO
ALTER TABLE [Items].[t_ItemSharedMaterial] ADD CONSTRAINT [PK_t_ItemSharedMaterial] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Items].[t_ItemSharedMaterial] ADD CONSTRAINT [ItemSharedFatherKeyItemSharedMaterial] FOREIGN KEY ([ItemSharedFatherID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_ItemSharedMaterial] ADD CONSTRAINT [ItemSharedKeyItemSharedMaterial] FOREIGN KEY ([ItemSharedID]) REFERENCES [Items].[t_ItemShared] ([ID])
GO
ALTER TABLE [Items].[t_ItemSharedMaterial] ADD CONSTRAINT [UnityItemKeyItemSharedMaterial] FOREIGN KEY ([ItemUnityID]) REFERENCES [Items].[t_UnityItem] ([ID])
GO
ALTER TABLE [Items].[t_ItemSharedMaterial] ADD CONSTRAINT [UserKeyItemSharedMaterial] FOREIGN KEY ([CreateByID]) REFERENCES [Users].[t_User] ([ID])
GO
