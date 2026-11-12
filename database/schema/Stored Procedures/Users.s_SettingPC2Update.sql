SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Users].[s_SettingPC2Update]
  @Computer NVARCHAR(450) ,
  @SoldProfitPartnerA4PrintSettingUILanguage NVARCHAR(MAX) ,
  @SoldProfitPartnerA4PrintSettingUINumberOfCopies SMALLINT ,
  @SoldProfitPartnerA4PrintSettingUIPrinter NVARCHAR(MAX) ,
  @SoldProfitPartnerA4PrintSettingUIReportLogoID UNIQUEIDENTIFIER ,
  @CustomerListUISelectedTabPageIndex INT ,
  @CustomerListUISubCollapsed BIT ,
  @CustomerListUISubSplitterPositon INT ,
  @ItemReportsPrintSettingLanguage NVARCHAR(MAX) ,
  @ItemReportsPrintSettingNumberOfCopies SMALLINT ,
  @ItemReportsPrintSettingPrinter NVARCHAR(MAX) ,
  @ItemReportsPrintSettingReportLogoID UNIQUEIDENTIFIER ,
  @ItemReportsPrintSettingTopRow INT ,
  @ItemReportsPrintSettingBestSellingItemsOrderBy TINYINT ,
  @ItemReportsPrintSettingOrderType TINYINT ,
  @ItemReportsPrintSettingCurrencyID UNIQUEIDENTIFIER ,
  @SoldTouchNewUIMainCategoryWidth INT ,
  @SoldTouchNewUIMainCategoryHeight INT ,
  @SoldTouchNewUIItemWidth INT ,
  @SoldTouchNewUIItemHeight INT ,
  @CarRentalPrintSettingA4UITemplate INT
AS
BEGIN
  BEGIN TRY

    SET ANSI_WARNINGS OFF;

    BEGIN TRANSACTION;

    BEGIN --Merge

      UPDATE  Users.t_SettingPC2
      SET     SoldProfitPartnerA4PrintSettingUILanguage = @SoldProfitPartnerA4PrintSettingUILanguage ,
              SoldProfitPartnerA4PrintSettingUINumberOfCopies = @SoldProfitPartnerA4PrintSettingUINumberOfCopies ,
              SoldProfitPartnerA4PrintSettingUIPrinter = @SoldProfitPartnerA4PrintSettingUIPrinter ,
              SoldProfitPartnerA4PrintSettingUIReportLogoID = @SoldProfitPartnerA4PrintSettingUIReportLogoID ,
              CustomerListUISelectedTabPageIndex = @CustomerListUISelectedTabPageIndex ,
              CustomerListUISubCollapsed = @CustomerListUISubCollapsed ,
              CustomerListUISubSplitterPositon = @CustomerListUISubSplitterPositon ,
              ItemReportsPrintSettingLanguage = @ItemReportsPrintSettingLanguage ,
              ItemReportsPrintSettingNumberOfCopies = @ItemReportsPrintSettingNumberOfCopies ,
              ItemReportsPrintSettingPrinter = @ItemReportsPrintSettingPrinter ,
              ItemReportsPrintSettingReportLogoID = @ItemReportsPrintSettingReportLogoID ,
              ItemReportsPrintSettingTopRow = @ItemReportsPrintSettingTopRow ,
              ItemReportsPrintSettingBestSellingItemsOrderBy = @ItemReportsPrintSettingBestSellingItemsOrderBy ,
              ItemReportsPrintSettingOrderType = @ItemReportsPrintSettingOrderType ,
              ItemReportsPrintSettingCurrencyID = @ItemReportsPrintSettingCurrencyID ,
              SoldTouchNewUIMainCategoryWidth = @SoldTouchNewUIMainCategoryWidth ,
              SoldTouchNewUIMainCategoryHeight = @SoldTouchNewUIMainCategoryHeight ,
              SoldTouchNewUIItemWidth = @SoldTouchNewUIItemWidth ,
              SoldTouchNewUIItemHeight = @SoldTouchNewUIItemHeight ,
              CarRentalPrintSettingA4UITemplate = @CarRentalPrintSettingA4UITemplate
      WHERE   Computer = @Computer;

    END;

    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  0;

  END CATCH;

END;

	



GO
