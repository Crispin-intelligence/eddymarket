CREATE TABLE [Alls].[t_FireStoreRowsForDelete]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_FireStoreRowsForDelete_ID] DEFAULT (newsequentialid()),
[DocumentID] [uniqueidentifier] NOT NULL,
[HasImage] [bit] NOT NULL CONSTRAINT [DF_t_FireStoreRowsForDelete_HasImage] DEFAULT ((0)),
[TableName] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Alls].[t_FireStoreRowsForDelete] ADD CONSTRAINT [PK_t_FireStoreRowsForDelete] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
