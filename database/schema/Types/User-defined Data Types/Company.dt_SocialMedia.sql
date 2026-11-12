CREATE TYPE [Company].[dt_SocialMedia] AS TABLE
(
[TypeID] [uniqueidentifier] NOT NULL,
[AccountIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL
)
GO
