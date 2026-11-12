CREATE TABLE [Company].[t_Bank]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_tbl_Bank_BankName] DEFAULT (''),
[Phones] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_Phones] DEFAULT (''),
[PhonesC] [bigint] NOT NULL CONSTRAINT [DF_t_Bank_PhonesC] DEFAULT ((0)),
[SocialMedia] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_SocialMedia] DEFAULT (''),
[SocialMediaC] [bigint] NOT NULL CONSTRAINT [DF_t_Bank_SocialMediaC] DEFAULT ((0)),
[StatesID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_StatesID] DEFAULT ([Location].[f_StatesGetFirstID]()),
[StatesIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_StatesIs] DEFAULT ([Location].[f_StatesGetFirstName]()),
[RegionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_RegionID] DEFAULT ([Location].[f_RegionGetFirstID]()),
[RegionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_RegionIs] DEFAULT ([Location].[f_RegionGetFirstName]()),
[StreetID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_StreetID] DEFAULT ([Location].[f_StreetGetFirstID]()),
[Street] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_Street] DEFAULT ([Location].[f_StreetGetFirstName]()),
[BuildingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_BuildingID] DEFAULT ([Location].[f_BuildingGetFirstID]()),
[Building] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_Building] DEFAULT ([Location].[f_BuildingGetFirstName]()),
[FloorID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_FloorID] DEFAULT ([Location].[f_FloorGetFirstID]()),
[FloorIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_FloorIs] DEFAULT ([Location].[f_FloorGetFirstName]()),
[PostalCodeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Bank_PostalCodeID] DEFAULT ([Location].[f_PostalCodeGetFirstID]()),
[PostalCode] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_PostalCode] DEFAULT ([Location].[f_PostalCodeGetFirstName]()),
[AddressNote] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_AddressNote] DEFAULT (''),
[AddressIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_AddressIs] DEFAULT (''),
[CurrencyX] [float] NOT NULL CONSTRAINT [DF_t_Bank_CurrencyX] DEFAULT ((1320)),
[CurrencyY] [float] NOT NULL CONSTRAINT [DF_t_Bank_CurrencyY] DEFAULT ((75)),
[PriceX] [float] NOT NULL CONSTRAINT [DF_t_Bank_PriceX] DEFAULT ((1480)),
[PriceY] [float] NOT NULL CONSTRAINT [DF_t_Bank_PriceY] DEFAULT ((75)),
[NoteX] [float] NOT NULL CONSTRAINT [DF_t_Bank_NoteX] DEFAULT ((420)),
[NoteY] [float] NOT NULL CONSTRAINT [DF_t_Bank_NoteY] DEFAULT ((140)),
[BeneficiaryX] [float] NOT NULL CONSTRAINT [DF_t_Bank_BeneficiaryX] DEFAULT ((460)),
[BeneficiaryY] [float] NOT NULL CONSTRAINT [DF_t_Bank_BeneficiaryY] DEFAULT ((240)),
[PriceWordX] [float] NOT NULL CONSTRAINT [DF_t_Bank_PriceWordX] DEFAULT ((460)),
[PriceWordY] [float] NOT NULL CONSTRAINT [DF_t_Bank_PriceWordY] DEFAULT ((310)),
[AddressX] [float] NOT NULL CONSTRAINT [DF_t_Bank_AddressX] DEFAULT ((590)),
[AddressY] [float] NOT NULL CONSTRAINT [DF_t_Bank_AddressY] DEFAULT ((425)),
[DateX] [float] NOT NULL CONSTRAINT [DF_t_Bank_DateX] DEFAULT ((1040)),
[DateY] [float] NOT NULL CONSTRAINT [DF_t_Bank_DateY] DEFAULT ((425)),
[UnderlinedX] [float] NOT NULL CONSTRAINT [DF_t_Bank_UnderlinedX] DEFAULT ((0)),
[UnderlinedY] [float] NOT NULL CONSTRAINT [DF_t_Bank_UnderlinedY] DEFAULT ((0)),
[UnderlinedH] [float] NOT NULL CONSTRAINT [DF_t_Bank_UnderlinedH] DEFAULT ((175)),
[UnderlinedW] [float] NOT NULL CONSTRAINT [DF_t_Bank_UnderlinedW] DEFAULT ((400)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_DescriptionIs] DEFAULT (''),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_Bank_StatusIs] DEFAULT ((0)),
[WhyThisStatus] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_WhyThisStatus] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Bank_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Bank_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Bank_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Bank_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Company].[tr_Bank] ON [Company].[t_Bank]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Company.t_Bank
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Bank.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'bank'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'bank'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Bank, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCompany, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [PK_t_Bank] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tbl_BankName] ON [Company].[t_Bank] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [BuildingKeyBank] FOREIGN KEY ([BuildingID]) REFERENCES [Location].[t_Building] ([ID])
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [FloorKeyBank] FOREIGN KEY ([FloorID]) REFERENCES [Location].[t_Floor] ([ID])
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [PostalCodeKeyBank] FOREIGN KEY ([PostalCodeID]) REFERENCES [Location].[t_PostalCode] ([ID])
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [RegionkeyBank] FOREIGN KEY ([RegionID]) REFERENCES [Location].[t_Region] ([ID])
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [StatesKeyBank] FOREIGN KEY ([StatesID]) REFERENCES [Location].[t_States] ([ID])
GO
ALTER TABLE [Company].[t_Bank] ADD CONSTRAINT [StreetKeyBank] FOREIGN KEY ([StreetID]) REFERENCES [Location].[t_Street] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active = 0
Inactive = 1
Blocked = 2', 'SCHEMA', N'Company', 'TABLE', N't_Bank', 'COLUMN', N'StatusIs'
GO
