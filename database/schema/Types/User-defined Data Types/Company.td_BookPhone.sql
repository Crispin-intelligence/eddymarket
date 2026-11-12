CREATE TYPE [Company].[td_BookPhone] AS TABLE
(
[NumberIs] [nvarchar] (max) COLLATE Arabic_CI_AS NULL,
[TypeIs] [tinyint] NULL,
[LanguageCodeID] [uniqueidentifier] NULL,
[ExtensionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NULL
)
GO
