CREATE TABLE [Currencys].[t_Currency]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_Currency_ID] DEFAULT (newsequentialid()),
[TypeIs] [int] NOT NULL CONSTRAINT [DF_t_Currency_TypeIs] DEFAULT ((0)),
[Name] [nvarchar] (450) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_Name] DEFAULT ('$'),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Currency_ExchangeRate] DEFAULT ((1)),
[ExchangeRateTax] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_Currency_ExchangeRateTax] DEFAULT ((1)),
[DecimalNumber] [tinyint] NOT NULL CONSTRAINT [DF_t_Currency_DecimalNumber] DEFAULT ((2)),
[PositivePattern] [tinyint] NOT NULL CONSTRAINT [DF_t_Currency_PositivePattern] DEFAULT ((3)),
[DisplayFormat] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DisplayFormat] DEFAULT ('{0:#,##0.## }$'),
[DisplayFormat1] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DisplayFormat1] DEFAULT ('#,##0.## $'),
[DisplayFormat2] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DisplayFormat2] DEFAULT ('#,##0.## '),
[DescriptionAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DescriptionAR] DEFAULT ('دولار أمريكي'),
[DescriptionEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DescriptionEN] DEFAULT ('Dollar'),
[DescriptionDecimalAR] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DescriptionDecimalAR] DEFAULT ('سنتات'),
[DescriptionDecimalEN] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_Currency_DescriptionDecimalEN] DEFAULT ('cents'),
[RewardPointsInsteadOf] [float] NOT NULL CONSTRAINT [DF_t_Currency_RewardPointsInsteadOf] DEFAULT ((0)),
[MinimumUnit] [float] NOT NULL CONSTRAINT [DF_t_Currency_MinimumUnit] DEFAULT ((0)),
[RoundingAfter] [float] NOT NULL CONSTRAINT [DF_t_Currency_RoundingAfter] DEFAULT ((0)),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_Currency_DateCreate] DEFAULT (getdate()),
[AccountC] [int] NOT NULL CONSTRAINT [DF_t_Currency_AccountC] DEFAULT ((0)),
[EmployeeC] [int] NOT NULL CONSTRAINT [DF_t_Currency_EmployeeC] DEFAULT ((0)),
[EmployeeDiscountC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_EmployeeDiscountC] DEFAULT ((0)),
[ItemC] [int] NOT NULL CONSTRAINT [DF_t_Currency_ItemC] DEFAULT ((0)),
[ItemCompilationC] [int] NOT NULL CONSTRAINT [DF_t_Currency_ItemCompilationC] DEFAULT ((0)),
[PurchaseC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_PurchaseC] DEFAULT ((0)),
[PurchaseReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_PurchaseReturnC] DEFAULT ((0)),
[SellC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_SellC] DEFAULT ((0)),
[SellReturnC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_SellReturnC] DEFAULT ((0)),
[InventoryAdjustmentC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_InventoryAdjustmentC] DEFAULT ((0)),
[QuotationC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_QuotationC] DEFAULT ((0)),
[QuotationTemplateC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_QuotationTemplateC] DEFAULT ((0)),
[ChequeC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_ChequeC] DEFAULT ((0)),
[VoucherC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_VoucherC] DEFAULT ((0)),
[TransactionC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_TransactionC] DEFAULT ((0)),
[TrialBalanceTemplateC] [bigint] NOT NULL CONSTRAINT [DF_t_Currency_TrialBalanceTemplateC] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_Currency_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_Currency_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Currencys].[tr_Currency] ON [Currencys].[t_Currency]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Currencys.t_Currency
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Currency.ID );

  END;

  BEGIN --Format

    UPDATE  Currencys.t_Currency
    SET     DisplayFormat = CASE DecimalNumber
                              WHEN 0 THEN '{0:#,##0}'
                              WHEN 1 THEN '{0:#,##0.#}'
                              WHEN 2 THEN '{0:#,##0.##}'
                              WHEN 3 THEN '{0:#,##0.###}'
                              WHEN 4 THEN '{0:#,##0.####}'
                              WHEN 5 THEN '{0:#,##0.#####}'
                              WHEN 6 THEN '{0:#,##0.######}'
                              ELSE '{0:#,##0.##}'
                            END ,
            DisplayFormat1 = CASE DecimalNumber
                               WHEN 0 THEN '#,##0'
                               WHEN 1 THEN '#,##0.#'
                               WHEN 2 THEN '#,##0.##'
                               WHEN 3 THEN '#,##0.###'
                               WHEN 4 THEN '#,##0.####'
                               WHEN 5 THEN '#,##0.#####'
                               WHEN 6 THEN '#,##0.######'
                               ELSE '#,##0.##'
                             END ,
            DisplayFormat2 = CASE DecimalNumber
                               WHEN 0 THEN '#,##0'
                               WHEN 1 THEN '#,##0.#'
                               WHEN 2 THEN '#,##0.##'
                               WHEN 3 THEN '#,##0.###'
                               WHEN 4 THEN '#,##0.####'
                               WHEN 5 THEN '#,##0.#####'
                               WHEN 6 THEN '#,##0.#####'
                               ELSE '#,##0.##'
                             END
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Currency.ID );

    UPDATE  Currencys.t_Currency
    SET     DisplayFormat = CASE PositivePattern
                              WHEN 0 THEN Name + DisplayFormat
                              WHEN 1 THEN DisplayFormat + Name
                              WHEN 2 THEN Name + ' ' + DisplayFormat
                              WHEN 3 THEN DisplayFormat + ' ' + Name
                              ELSE DisplayFormat + ' ' + Name
                            END ,
            DisplayFormat1 = CASE PositivePattern
                               WHEN 0 THEN Name + DisplayFormat1
                               WHEN 1 THEN DisplayFormat1 + Name
                               WHEN 2 THEN Name + ' ' + DisplayFormat1
                               WHEN 3 THEN DisplayFormat1 + ' ' + Name
                               ELSE DisplayFormat1 + ' ' + Name
                             END
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_Currency.ID );


  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'currency'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'currency'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, Currency, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCurrency, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Currencys].[t_Currency] ADD CONSTRAINT [PK_t_Currency] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_t_CurrencyName] ON [Currencys].[t_Currency] ([Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'$ = 0
L.L. = 1
Euro = 2', 'SCHEMA', N'Currencys', 'TABLE', N't_Currency', 'COLUMN', N'TypeIs'
GO
