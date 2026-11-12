CREATE TABLE [Items].[t_ItemSharedOption]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ID] DEFAULT (newsequentialid()),
[ARAdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty1] DEFAULT ('خاصية 1'),
[ARAdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty2] DEFAULT ('خاصية 2'),
[ARAdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty3] DEFAULT ('خاصية 3'),
[ARAdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty4] DEFAULT ('خاصية 4'),
[ARAdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty5] DEFAULT ('خاصية 5'),
[ARAdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty6] DEFAULT ('خاصية 6'),
[ARAdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty7] DEFAULT ('خاصية 7'),
[ARAdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty8] DEFAULT ('خاصية 8'),
[ARAdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty9] DEFAULT ('خاصية 9'),
[ARAdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ARAdditionalProperty10] DEFAULT ('خاصية 10'),
[ENAdditionalProperty1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty1] DEFAULT ('Property 1'),
[ENAdditionalProperty2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty2] DEFAULT ('Property 2'),
[ENAdditionalProperty3] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty3] DEFAULT ('Property 3'),
[ENAdditionalProperty4] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty4] DEFAULT ('Property 4'),
[ENAdditionalProperty5] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty5] DEFAULT ('Property 5'),
[ENAdditionalProperty6] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty6] DEFAULT ('Property 6'),
[ENAdditionalProperty7] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty7] DEFAULT ('Property 7'),
[ENAdditionalProperty8] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty8] DEFAULT ('Property 8'),
[ENAdditionalProperty9] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty9] DEFAULT ('Property 9'),
[ENAdditionalProperty10] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ItemSharedOption_ENAdditionalProperty10] DEFAULT ('Property 10'),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_ItemSharedOption_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ItemSharedOption_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ItemSharedOption] ON [Items].[t_ItemSharedOption]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN

    UPDATE  Items.t_ItemSharedOption
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_ItemSharedOption.ID );

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Item, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;

GO
ALTER TABLE [Items].[t_ItemSharedOption] ADD CONSTRAINT [PK_t_ItemSharedOption] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
