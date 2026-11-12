CREATE TABLE [Company].[t_AccountEmail]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_AccountEmail_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountEmail_Name] DEFAULT (''),
[Password] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountEmail_Password] DEFAULT (''),
[Note] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_AccountEmail_Note] DEFAULT (''),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_AccountEmail_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_AccountEmail] ON [Company].[t_AccountEmail]
    AFTER INSERT, UPDATE, DELETE
AS
    BEGIN

        UPDATE  Alls.t_LiveVersion
        SET     VersionLive = STUFF(VersionLive, AccountEmail, 3,
                                    FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                           '000')) ,
                SchemasIs = STUFF(SchemasIs, SchemaCompany, 3,
                                  FORMAT(DATEPART(MILLISECOND, GETDATE()),
                                         '000'));



    END;
GO
ALTER TABLE [Company].[t_AccountEmail] ADD CONSTRAINT [CK_t_AccountEmail_Name] CHECK (([Name]<>N''))
GO
ALTER TABLE [Company].[t_AccountEmail] ADD CONSTRAINT [PK_t_AccountEmail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_AccountEmail] ON [Company].[t_AccountEmail] ([Name]) ON [PRIMARY]
GO
