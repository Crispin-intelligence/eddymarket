CREATE TABLE [Employees].[t_VacationType]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_VacationType_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VacationType_Name] DEFAULT ('-'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_VacationType_DescriptionIs] DEFAULT (''),
[VacationAddC] [bigint] NOT NULL CONSTRAINT [DF_t_VacationType_VacationAddC] DEFAULT ((0)),
[VacationUseC] [bigint] NOT NULL CONSTRAINT [DF_t_VacationType_VacationUseC] DEFAULT ((0)),
[VacationNet] [bigint] NOT NULL CONSTRAINT [DF_t_VacationType_VacationNet] DEFAULT ((0)),
[VacationDiscountedC] [bigint] NOT NULL CONSTRAINT [DF_t_VacationType_VacationDiscountedC] DEFAULT ((0)),
[VacationC] [bigint] NOT NULL CONSTRAINT [DF_t_VacationType_VacationC] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_VacationType_DateCreate] DEFAULT (getdate()),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_VacationType_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_VacationType]
ON [Employees].[t_VacationType]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    BEGIN --Live

        UPDATE Alls.t_LiveVersion
        SET VersionLive = STUFF(VersionLive, VacationType, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

    END;

END;
GO
ALTER TABLE [Employees].[t_VacationType] ADD CONSTRAINT [PK_t_VacationType_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_VacationsTypeName] ON [Employees].[t_VacationType] ([Name]) ON [PRIMARY]
GO
