CREATE TABLE [Customers].[t_Prescription]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Prescription_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_Prescription_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_RefF] DEFAULT ('0'),
[RefPaper] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_RefPaper] DEFAULT (''),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_Prescription_DateIs] DEFAULT (getdate()),
[CustomerID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Prescription_CustomerID] DEFAULT ([Customers].[f_CustomerGetFirstID]()),
[Customer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_Customer] DEFAULT ([Customers].[f_CustomerGetFirstName]()),
[DoctorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Prescription_DoctorID] DEFAULT ([Company].[f_DoctorGetFirstID]()),
[Doctor] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_Doctor] DEFAULT ([Company].[f_DoctorGetFirstName]()),
[BrandID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Prescription_BrandID] DEFAULT ([Items].[f_BrandGetFirstID]()),
[Brand] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_Brand] DEFAULT ([Items].[f_BrandGetFirstName]()),
[TypeIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_TypeIs] DEFAULT ('Spectacle Lenses'),
[Focal] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_Focal] DEFAULT ('Plano'),
[WithRight] [bit] NOT NULL CONSTRAINT [DF_t_Prescription_WithRight] DEFAULT ((1)),
[WithLeft] [bit] NOT NULL CONSTRAINT [DF_t_Prescription_WithLeft] DEFAULT ((1)),
[SphereRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_SphereRight] DEFAULT ((0)),
[SphereLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_SphereLeft] DEFAULT ((0)),
[CylinderRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_CylinderRight] DEFAULT ((0)),
[CylinderLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_CylinderLeft] DEFAULT ((0)),
[AxisRight] [int] NOT NULL CONSTRAINT [DF_t_Prescription_AxisRight] DEFAULT ((0)),
[AxisLeft] [int] NOT NULL CONSTRAINT [DF_t_Prescription_AxisLeft] DEFAULT ((0)),
[PrismRight] [int] NOT NULL CONSTRAINT [DF_t_Prescription_PrismRight] DEFAULT ((0)),
[PrismLeft] [int] NOT NULL CONSTRAINT [DF_t_Prescription_PrismLeft] DEFAULT ((0)),
[BaseRight] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_BaseRight] DEFAULT ('Up'),
[BaseLeft] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_BaseLeft] DEFAULT ('Up'),
[Addition] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_Addition] DEFAULT ((0)),
[HeightRight] [int] NOT NULL CONSTRAINT [DF_t_Prescription_HeightRight] DEFAULT ((0)),
[HeightLeft] [int] NOT NULL CONSTRAINT [DF_t_Prescription_HeightLeft] DEFAULT ((0)),
[PDRight] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_PDRight] DEFAULT ((0)),
[PDLeft] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_PDLeft] DEFAULT ((0)),
[PD] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Prescription_PD] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_DescriptionIs] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Prescription_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Prescription_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Prescription_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Prescription_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Customers].[tr_Prescription] ON [Customers].[t_Prescription]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Customers.t_Prescription
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Prescription.ID );

  END;
  
  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'prescription'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'prescription'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Prescription, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCustomer, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Customers].[t_Prescription] ADD CONSTRAINT [PK_t_Prescription] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_Prescription_Ref] ON [Customers].[t_Prescription] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Customers].[t_Prescription] ADD CONSTRAINT [BrandKeyPrescription] FOREIGN KEY ([BrandID]) REFERENCES [Items].[t_Brand] ([ID])
GO
ALTER TABLE [Customers].[t_Prescription] ADD CONSTRAINT [CustomerKeyPrescription] FOREIGN KEY ([CustomerID]) REFERENCES [Customers].[t_Customer] ([ID])
GO
ALTER TABLE [Customers].[t_Prescription] ADD CONSTRAINT [DoctorKeyPrescription] FOREIGN KEY ([DoctorID]) REFERENCES [Company].[t_Doctor] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Up
Down
In
Out', 'SCHEMA', N'Customers', 'TABLE', N't_Prescription', 'COLUMN', N'BaseLeft'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Up
Down
In
Out', 'SCHEMA', N'Customers', 'TABLE', N't_Prescription', 'COLUMN', N'BaseRight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Plano
Single Distance
Single Intermediate
Single Near
Bifocal
Progressive', 'SCHEMA', N'Customers', 'TABLE', N't_Prescription', 'COLUMN', N'Focal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Lenses
Spectacle Lenses', 'SCHEMA', N'Customers', 'TABLE', N't_Prescription', 'COLUMN', N'TypeIs'
GO
