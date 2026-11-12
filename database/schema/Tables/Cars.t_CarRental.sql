CREATE TABLE [Cars].[t_CarRental]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRental_ID] DEFAULT (newsequentialid()),
[Ref] [bigint] NOT NULL CONSTRAINT [DF_t_CarRental_Ref] DEFAULT ((0)),
[RefF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_RefF] DEFAULT ('0'),
[PaperRef] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_PaperRef] DEFAULT (''),
[AccountID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRental_AccountID] DEFAULT ([Company].[f_AccountCustomerGetFirstID]()),
[Account] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_Account] DEFAULT ([Company].[f_AccountCustomerGetFirstName]()),
[AccountNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_AccountNumberF] DEFAULT ([Company].[f_AccountCustomerGetFirstNumberF]()),
[AccountBoxID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRental_AccountBoxID] DEFAULT ([Company].[f_AccountBoxGetFirstID]()),
[AccountBox] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_AccountBox] DEFAULT ([Company].[f_AccountBoxGetFirstName]()),
[AccountBoxNumberF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_AccountBoxNumberF] DEFAULT ([Company].[f_AccountBoxGetFirstNumberF]()),
[CarID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRental_CarID] DEFAULT ([Cars].[f_CarGetFirstID]()),
[Car] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_Car] DEFAULT ([Cars].[f_CarGetFirstName]()),
[AgreementDate] [date] NOT NULL CONSTRAINT [DF_t_CarRental_AgreementDate] DEFAULT (getdate()),
[FromDate] [date] NOT NULL CONSTRAINT [DF_t_CarRental_FromDate] DEFAULT (getdate()),
[ToDate] [date] NOT NULL CONSTRAINT [DF_t_CarRental_ToDate] DEFAULT (getdate()),
[CurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRental_CurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstID]()),
[Currency] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_Currency] DEFAULT ([Currencys].[f_CurrencyGetFirstName]()),
[ExchangeRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarRental_ExchangeRate] DEFAULT ([Currencys].[f_CurrencyGetFirstExchangeRate]()),
[ExchangeRateLL] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarRental_ExchangeRateLL] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateLL]()),
[ExchangeRateEuro] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_CarRental_ExchangeRateEuro] DEFAULT ([Currencys].[f_CurrencyGetExchangeRateEuro]()),
[DayPrice] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayPrice] DEFAULT ((0)),
[DayPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_DayPriceF] DEFAULT ('0'),
[DayPriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayPriceD] DEFAULT ((0)),
[DayPriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayPriceLL] DEFAULT ((0)),
[DayPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayPriceEuro] DEFAULT ((0)),
[DayQty] [int] NOT NULL CONSTRAINT [DF_t_CarRental_DayQty] DEFAULT ((0)),
[DayTotalPrice] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayTotalPrice] DEFAULT ((0)),
[DayTotalPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_DayTotalPriceF] DEFAULT ('0'),
[DayTotalPriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayTotalPriceD] DEFAULT ((0)),
[DayTotalPriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayTotalPriceLL] DEFAULT ((0)),
[DayTotalPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DayTotalPriceEuro] DEFAULT ((0)),
[WeekPrice] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekPrice] DEFAULT ((0)),
[WeekPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_WeekPriceF] DEFAULT ('0'),
[WeekPriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekPriceD] DEFAULT ((0)),
[WeekPriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekPriceLL] DEFAULT ((0)),
[WeekPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekPriceEuro] DEFAULT ((0)),
[WeekQty] [int] NOT NULL CONSTRAINT [DF_t_CarRental_WeekQty] DEFAULT ((0)),
[WeekTotalPrice] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekTotalPrice] DEFAULT ((0)),
[WeekTotalPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_WeekTotalPriceF] DEFAULT ('0'),
[WeekTotalPriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekTotalPriceD] DEFAULT ((0)),
[WeekTotalPriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekTotalPriceLL] DEFAULT ((0)),
[WeekTotalPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_WeekTotalPriceEuro] DEFAULT ((0)),
[MonthPrice] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthPrice] DEFAULT ((0)),
[MonthPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_MonthPriceF] DEFAULT ('0'),
[MonthPriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthPriceD] DEFAULT ((0)),
[MonthPriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthPriceLL] DEFAULT ((0)),
[MonthPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthPriceEuro] DEFAULT ((0)),
[MonthQty] [int] NOT NULL CONSTRAINT [DF_t_CarRental_MonthQty] DEFAULT ((0)),
[MonthTotalPrice] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthTotalPrice] DEFAULT ((0)),
[MonthTotalPriceF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_MonthTotalPriceF] DEFAULT ('0'),
[MonthTotalPriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthTotalPriceD] DEFAULT ((0)),
[MonthTotalPriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthTotalPriceLL] DEFAULT ((0)),
[MonthTotalPriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_MonthTotalPriceEuro] DEFAULT ((0)),
[Subtotal] [float] NOT NULL CONSTRAINT [DF_t_CarRental_Subtotal] DEFAULT ((0)),
[SubtotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_SubtotalF] DEFAULT ('0'),
[SubtotalD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_SubtotalD] DEFAULT ((0)),
[SubtotalLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_SubtotalLL] DEFAULT ((0)),
[SubtotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_SubtotalEuro] DEFAULT ((0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_t_CarRental_Discount] DEFAULT ((0)),
[DiscountF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_DiscountF] DEFAULT ('0'),
[DiscountD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DiscountD] DEFAULT ((0)),
[DiscountLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DiscountLL] DEFAULT ((0)),
[DiscountEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_DiscountEuro] DEFAULT ((0)),
[Total] [float] NOT NULL CONSTRAINT [DF_t_CarRental_Total] DEFAULT ((0)),
[TotalF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_TotalF] DEFAULT ('0'),
[TotalD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalD] DEFAULT ((0)),
[TotalLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalLL] DEFAULT ((0)),
[TotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalEuro] DEFAULT ((0)),
[PaymentMethod] [tinyint] NOT NULL CONSTRAINT [DF_t_CarRental_PaymentMethod] DEFAULT ((0)),
[FirstPayment] [float] NOT NULL CONSTRAINT [DF_t_CarRental_FirstPayment] DEFAULT ((0)),
[FirstPaymentF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_FirstPaymentF] DEFAULT ('0'),
[FirstPaymentD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_FirstPaymentD] DEFAULT ((0)),
[FirstPaymentLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_FirstPaymentLL] DEFAULT ((0)),
[FirstPaymentEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_FirstPaymentEuro] DEFAULT ((0)),
[PaidUp] [float] NOT NULL CONSTRAINT [DF_t_CarRental_PaidUp] DEFAULT ((0)),
[PaidUpF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_PaidUpF] DEFAULT ('0'),
[PaidUpD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_PaidUpD] DEFAULT ((0)),
[PaidUpLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_PaidUpLL] DEFAULT ((0)),
[PaidUpEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_PaidUpEuro] DEFAULT ((0)),
[Rest] [float] NOT NULL CONSTRAINT [DF_t_CarRental_Rest] DEFAULT ((0)),
[RestF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_RestF] DEFAULT ('0'),
[RestD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_RestD] DEFAULT ((0)),
[RestLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_RestLL] DEFAULT ((0)),
[RestEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_RestEuro] DEFAULT ((0)),
[Paid] [tinyint] NOT NULL CONSTRAINT [DF_t_CarRental_Paid] DEFAULT ((0)),
[OfficeRatio] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_CarRental_OfficeRatio] DEFAULT ((0)),
[OfficeValue] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValue] DEFAULT ((0)),
[OfficeValueF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueF] DEFAULT ('0'),
[OfficeValueD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueD] DEFAULT ((0)),
[OfficeValueLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueLL] DEFAULT ((0)),
[OfficeValueEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueEuro] DEFAULT ((0)),
[DailyTax] [float] NOT NULL,
[DailyTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL,
[DailyTaxD] [float] NOT NULL,
[DailyTaxLL] [float] NOT NULL,
[DailyTaxEuro] [float] NOT NULL,
[TotalTax] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalTax] DEFAULT ((0)),
[TotalTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_TotalTaxF] DEFAULT ('0'),
[TotalTaxD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalTaxD] DEFAULT ((0)),
[TotalTaxLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalTaxLL] DEFAULT ((0)),
[TotalTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_TotalTaxEuro] DEFAULT ((0)),
[TaxRate] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_t_CarRental_TaxRate] DEFAULT ((0)),
[PaidTax] [bit] NOT NULL CONSTRAINT [DF_t_CarRental_PaidTax] DEFAULT ((0)),
[OfficeValueAfterTax] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueAfterTax] DEFAULT ((0)),
[OfficeValueAfterTaxF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueAfterTaxF] DEFAULT ('0'),
[OfficeValueAfterTaxD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueAfterTaxD] DEFAULT ((0)),
[OfficeValueAfterTaxLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueAfterTaxLL] DEFAULT ((0)),
[OfficeValueAfterTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_OfficeValueAfterTaxEuro] DEFAULT ((0)),
[Profit] [float] NOT NULL CONSTRAINT [DF_t_CarRental_Profit] DEFAULT ((0)),
[ProfitF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_ProfitF] DEFAULT ('0'),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarRental_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarRental_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRental_ProfitEuro] DEFAULT ((0)),
[CheckOutDate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRental_CheckOutDate] DEFAULT (datefromparts((2000),(1),(1))),
[CheckOutFuel] [int] NOT NULL CONSTRAINT [DF_t_CarRental_CheckOutFuel] DEFAULT ((0)),
[CheckOutOdometer] [int] NOT NULL CONSTRAINT [DF_t_CarRental_CheckOutOdometer] DEFAULT ((0)),
[CheckInDate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRental_CheckInDate] DEFAULT (datefromparts((2000),(1),(1))),
[CheckInFuel] [int] NOT NULL CONSTRAINT [DF_t_CarRental_CheckInFuel] DEFAULT ((0)),
[CheckInOdometer] [int] NOT NULL CONSTRAINT [DF_t_CarRental_CheckInOdometer] DEFAULT ((0)),
[DurationInMinutes] [bigint] NOT NULL CONSTRAINT [DF_t_CarRental_DurationInMinutes] DEFAULT ((0)),
[DurationF] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_DurationF] DEFAULT (''),
[OdometerConsumed] [int] NOT NULL CONSTRAINT [DF_t_CarRental_OdometerConsumed] DEFAULT ((0)),
[StatusIs] [tinyint] NOT NULL CONSTRAINT [DF_t_CarRental_StatusIs] DEFAULT ((0)),
[DescriptionIs] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_DescriptionIs] DEFAULT (''),
[Notes] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_Notes] DEFAULT (''),
[SearchText] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_CarRental_SearchText] DEFAULT (''),
[DateCreate] [datetime] NOT NULL CONSTRAINT [DF_t_CarRental_DateCreate] DEFAULT (getdate()),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarRental_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarRental_WorkStationID] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarRental] ON [Cars].[t_CarRental]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarRental
    SET     IsSync = 0 ,
            SearchText = Cars.f_CarRentalSearchTextGet(ID)
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarRental.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carRental'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carRental'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarRental, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarRental] ADD CONSTRAINT [PK_t_CarRental] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_t_CarRental_Ref] ON [Cars].[t_CarRental] ([Ref]) ON [PRIMARY]
GO
ALTER TABLE [Cars].[t_CarRental] ADD CONSTRAINT [AccountBoxKeyCarRental] FOREIGN KEY ([AccountBoxID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Cars].[t_CarRental] ADD CONSTRAINT [AccountKeyCarRental] FOREIGN KEY ([AccountID]) REFERENCES [Company].[t_Account] ([ID])
GO
ALTER TABLE [Cars].[t_CarRental] ADD CONSTRAINT [CarKeyCarRental] FOREIGN KEY ([CarID]) REFERENCES [Cars].[t_Car] ([ID])
GO
ALTER TABLE [Cars].[t_CarRental] ADD CONSTRAINT [CurrencyKeyCarRental] FOREIGN KEY ([CurrencyID]) REFERENCES [Currencys].[t_Currency] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'No = 0
Part = 1
Yes = 2', 'SCHEMA', N'Cars', 'TABLE', N't_CarRental', 'COLUMN', N'Paid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cash = 0
OnAccount = 1', 'SCHEMA', N'Cars', 'TABLE', N't_CarRental', 'COLUMN', N'PaymentMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reserved = 0
Checked Out = 1
Checked In = 2
Canceled = 3', 'SCHEMA', N'Cars', 'TABLE', N't_CarRental', 'COLUMN', N'StatusIs'
GO
