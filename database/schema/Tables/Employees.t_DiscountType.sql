CREATE TABLE [Employees].[t_DiscountType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_DiscountType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountType_Name] DEFAULT (''),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_DiscountType_DescriptionIs] DEFAULT (''),
[DiscountTotalD] [float] NOT NULL CONSTRAINT [DF_t_DiscountType_DiscountTotalD] DEFAULT ((0)),
[DiscountTotalLL] [float] NOT NULL CONSTRAINT [DF_t_DiscountType_DiscountTotalLL] DEFAULT ((0)),
[DiscountTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_DiscountType_DiscountTotalEuro] DEFAULT ((0)),
[DiscountC] [bigint] NOT NULL CONSTRAINT [DF_t_DiscountType_DiscountC] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_DiscountType_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_DiscountType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_DiscountType]
ON [Employees].[t_DiscountType]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    UPDATE Alls.t_LiveVersion
    SET VersionLive = STUFF(VersionLive, DiscountType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
        SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

END;
GO
ALTER TABLE [Employees].[t_DiscountType] ADD CONSTRAINT [PK_t_DiscountType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_DiscountType_Name] ON [Employees].[t_DiscountType] ([Name]) ON [PRIMARY]
GO
