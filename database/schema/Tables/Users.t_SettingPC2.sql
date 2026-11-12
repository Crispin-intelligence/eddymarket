CREATE TABLE [Users].[t_SettingPC2]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SettingPC2_ID] DEFAULT (newsequentialid()),
[Computer] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SettingPC2_Computer] DEFAULT (''),
[SoldProfitPartnerA4PrintSettingUILanguage] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldProfitPartnerA4PrintSettingUILanguage] DEFAULT ('en-US'),
[SoldProfitPartnerA4PrintSettingUINumberOfCopies] [smallint] NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldProfitPartnerA4PrintSettingUINumberOfCopies] DEFAULT ((1)),
[SoldProfitPartnerA4PrintSettingUIPrinter] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldProfitPartnerA4PrintSettingUIPrinter] DEFAULT (''),
[SoldProfitPartnerA4PrintSettingUIReportLogoID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldProfitPartnerA4PrintSettingUIReportLogoID] DEFAULT ([Options].[f_ReportHeaderFooterGetFirstID]()),
[CustomerListUISelectedTabPageIndex] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_CustomerListUISelectedTabPageIndex] DEFAULT ((0)),
[CustomerListUISubCollapsed] [bit] NOT NULL CONSTRAINT [DF_t_SettingPC2_CustomerListUISubCollapsed] DEFAULT ((0)),
[CustomerListUISubSplitterPositon] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_CustomerListUISubSplitterPositon] DEFAULT ((190)),
[ItemReportsPrintSettingLanguage] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingLanguage] DEFAULT ('en-US'),
[ItemReportsPrintSettingNumberOfCopies] [smallint] NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingNumberOfCopies] DEFAULT ((1)),
[ItemReportsPrintSettingPrinter] [nvarchar] (max) COLLATE Arabic_CI_AS NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingPrinter] DEFAULT (''),
[ItemReportsPrintSettingReportLogoID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingReportLogoID] DEFAULT ([Options].[f_ReportHeaderFooterGetFirstID]()),
[ItemReportsPrintSettingTopRow] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingTopRow] DEFAULT ((0)),
[ItemReportsPrintSettingBestSellingItemsOrderBy] [tinyint] NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingBestSellingItemsOrderBy] DEFAULT ((2)),
[ItemReportsPrintSettingOrderType] [tinyint] NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingOrderType] DEFAULT ((1)),
[ItemReportsPrintSettingCurrencyID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_SettingPC2_ItemReportsPrintSettingCurrencyID] DEFAULT ([Currencys].[f_CurrencyGetFirstIDLL]()),
[SoldTouchNewUIMainCategoryWidth] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldTouchNewUIMainCategoryWidth] DEFAULT ((100)),
[SoldTouchNewUIMainCategoryHeight] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldTouchNewUIMainCategoryHeight] DEFAULT ((60)),
[SoldTouchNewUIItemWidth] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldTouchNewUIItemWidth] DEFAULT ((100)),
[SoldTouchNewUIItemHeight] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_SoldTouchNewUIItemHeight] DEFAULT ((80)),
[CarRentalPrintSettingA4UITemplate] [int] NOT NULL CONSTRAINT [DF_t_SettingPC2_CarRentalPrintSettingA4UITemplate] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Users].[t_SettingPC2] ADD CONSTRAINT [PK_t_SettingPC2] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name = 0
Barcode = 1
Qty = 2
Total = 3', 'SCHEMA', N'Users', 'TABLE', N't_SettingPC2', 'COLUMN', N'ItemReportsPrintSettingBestSellingItemsOrderBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'None = 0
Ascending = 1
Descending = 2', 'SCHEMA', N'Users', 'TABLE', N't_SettingPC2', 'COLUMN', N'ItemReportsPrintSettingOrderType'
GO
