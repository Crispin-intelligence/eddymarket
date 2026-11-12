SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Users].[v_SettingPC2]
AS
SELECT  t.ID ,
        t.Computer ,
        t.SoldProfitPartnerA4PrintSettingUILanguage ,
        t.SoldProfitPartnerA4PrintSettingUINumberOfCopies ,
        t.SoldProfitPartnerA4PrintSettingUIPrinter ,
        t.SoldProfitPartnerA4PrintSettingUIReportLogoID ,
        t.CustomerListUISelectedTabPageIndex ,
        t.CustomerListUISubCollapsed ,
        t.CustomerListUISubSplitterPositon ,
        t.ItemReportsPrintSettingLanguage ,
        t.ItemReportsPrintSettingNumberOfCopies ,
        t.ItemReportsPrintSettingPrinter ,
        t.ItemReportsPrintSettingReportLogoID ,
        t.ItemReportsPrintSettingTopRow ,
        t.ItemReportsPrintSettingBestSellingItemsOrderBy ,
        t.ItemReportsPrintSettingOrderType ,
        t.ItemReportsPrintSettingCurrencyID ,
        t.SoldTouchNewUIMainCategoryWidth ,
        t.SoldTouchNewUIMainCategoryHeight ,
        t.SoldTouchNewUIItemWidth ,
        t.SoldTouchNewUIItemHeight ,
        t.CarRentalPrintSettingA4UITemplate
FROM    Users.t_SettingPC2 AS t;


GO
