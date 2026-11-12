CREATE TABLE [Employees].[t_SalesPerson]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_Name] DEFAULT (N'المندوب العام'),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_Phones] DEFAULT (''),
[PhonesC] [bigint] NOT NULL CONSTRAINT [DF_t_SalesPerson_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_SocialMedia] DEFAULT (''),
[SocialMediaC] [bigint] NOT NULL CONSTRAINT [DF_t_SalesPerson_SocialMediaC] DEFAULT ((0)),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SalesPerson_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_AddressIs] DEFAULT (''),
[CommissionRate] [decimal] (4, 2) NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionRate] DEFAULT ((0.0)),
[CommissionRateF] [nvarchar] (50) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionRateF] DEFAULT ('0 %'),
[CommissionRateType] [tinyint] NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionRateType] DEFAULT ((0)),
[CommissionRateOn] [tinyint] NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionRateOn] DEFAULT ((0)),
[CommissionAvailableValueD] [float] NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionAvailableValueD] DEFAULT ((0)),
[CommissionAvailableValueDF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionAvailableValueDF] DEFAULT ('0'),
[CommissionAvailableValueLL] [float] NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionAvailableValueLL] DEFAULT ((0)),
[CommissionAvailableValueLLF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionAvailableValueLLF] DEFAULT ('0'),
[CommissionAvailableValueEuro] [float] NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionAvailableValueEuro] DEFAULT ((0)),
[CommissionAvailableValueEuroF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_CommissionAvailableValueEuroF] DEFAULT ('0'),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_DescriptionIs] DEFAULT (''),
[CustomerC] [bigint] NOT NULL CONSTRAINT [DF_t_SalesPerson_CustomerC] DEFAULT ((0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_SalesPerson_QuotationC] DEFAULT ((0)),
[InvoicesC] [bigint] NOT NULL CONSTRAINT [DF_t_SalesPerson_InvoicesC] DEFAULT ((0)),
[FileStorageC] [bigint] NOT NULL CONSTRAINT [DF_t_SalesPerson_FileStorageC] DEFAULT ((0)),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_SalesPerson_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_WhyThisStatus] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SalesPerson_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_SalesPerson_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_SalesPerson_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_SalesPerson_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Employees].[tr_SalesPerson] ON [Employees].[t_SalesPerson]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Employees.t_SalesPerson
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_SalesPerson.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'salesPerson'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'salesPerson'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, SalesPerson, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Employees].[t_SalesPerson] ADD CONSTRAINT [PK_t_SalesPerson] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_SalesPerson_Name] ON [Employees].[t_SalesPerson] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Employees].[t_SalesPerson] ADD CONSTRAINT [BuildingKeySalesPerson] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Employees].[t_SalesPerson] ADD CONSTRAINT [FloorkeySalesPerson] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Employees].[t_SalesPerson] ADD CONSTRAINT [PostalCodeKeySalesPerson] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Employees].[t_SalesPerson] ADD CONSTRAINT [RegionkeySalesPerson] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Employees].[t_SalesPerson] ADD CONSTRAINT [StreetKeySalesPerson] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Net = 0
Profit = 1', 'SCHEMA', N'Employees', 'TABLE', N't_SalesPerson', 'COLUMN', N'CommissionRateOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales = 0
Collection = 1', 'SCHEMA', N'Employees', 'TABLE', N't_SalesPerson', 'COLUMN', N'CommissionRateType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Employees', 'TABLE', N't_SalesPerson', 'COLUMN', N'StatusIs'
GO
