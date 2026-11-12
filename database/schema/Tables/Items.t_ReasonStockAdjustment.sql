CREATE TABLE [Items].[t_ReasonStockAdjustment]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ReasonStockAdjustment_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ReasonStockAdjustment_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_ReasonStockAdjustment_DescriptionIs] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_ReasonStockAdjustment_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_ReasonStockAdjustment_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Items].[tr_ReasonStockAdjustment]
ON [Items].[t_ReasonStockAdjustment]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, ReasonStockAdjustment, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaItem, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;

GO
ALTER TABLE [Items].[t_ReasonStockAdjustment] ADD CONSTRAINT [PK_t_ReasonStockAdjustment] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'for items', 'SCHEMA', N'Items', 'TABLE', N't_ReasonStockAdjustment', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of ReasonStockAdjustment', 'SCHEMA', N'Items', 'TABLE', N't_ReasonStockAdjustment', 'COLUMN', N'ID'
GO
