SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Alls].[s_MovingTruncateTableAll]
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;
		
    TRUNCATE TABLE Company.t_AccountEmailMoving;
    TRUNCATE TABLE Company.t_AccountGroupMoving;
    TRUNCATE TABLE Company.t_AccountMoving;
    TRUNCATE TABLE Customers.t_AgeRangeMoving;
    TRUNCATE TABLE Company.t_BankMoving;
    TRUNCATE TABLE Items.t_BeginningInventoryQuantityMoving;
    TRUNCATE TABLE Company.t_BondMoving;
    TRUNCATE TABLE Employees.t_BonusMoving;
    TRUNCATE TABLE Employees.t_BonusTypeMoving;
    TRUNCATE TABLE Items.t_BrandMoving;
    TRUNCATE TABLE Location.t_BuildingMoving;
    TRUNCATE TABLE Company.t_ChequeMoving;
    TRUNCATE TABLE Customers.t_ClassificationMoving;
    TRUNCATE TABLE Company.t_CloseBoxMoving;
    TRUNCATE TABLE Company.t_ContactMoving;
    TRUNCATE TABLE Currencys.t_CurrencyMoving;
    TRUNCATE TABLE Customers.t_CustomerGroupMoving;
    TRUNCATE TABLE Customers.t_CustomerMoving;
    TRUNCATE TABLE Invoices.t_DeliveryServiceMoving;
    TRUNCATE TABLE Employees.t_DiscountMoving;
    TRUNCATE TABLE Employees.t_DiscountTypeMoving;
    TRUNCATE TABLE Company.t_DoctorMoving;
    TRUNCATE TABLE Employees.t_EmployeeMoving;
    TRUNCATE TABLE Employees.t_EmployeeTypeMoving;
    TRUNCATE TABLE Company.t_ExpenseMoving;
    TRUNCATE TABLE Company.t_FileStorageMoving;
    TRUNCATE TABLE Company.t_FileStorageTypeMoving;
    TRUNCATE TABLE Location.t_FloorMoving;
    TRUNCATE TABLE Customers.t_FrameJobOrderMoving;
    TRUNCATE TABLE Gym.t_GymClassMoving;
    TRUNCATE TABLE Gym.t_GymMemberAttendanceMoving;
    TRUNCATE TABLE Gym.t_GymSubscriptionMoving;
    TRUNCATE TABLE Customers.t_InternetPackageMoving;
    TRUNCATE TABLE Invoices.t_InternetSubscriptionMoving;
    TRUNCATE TABLE Invoices.t_InvoiceTitleMoving;
    TRUNCATE TABLE Items.t_ItemExpirationDateMoving;
    TRUNCATE TABLE Items.t_ItemProductionMoving;
    TRUNCATE TABLE Items.t_ItemSharedMoving;
    TRUNCATE TABLE Alls.t_LanguageCodeMoving;
    TRUNCATE TABLE Items.t_MainCategoryMoving;
    TRUNCATE TABLE Employees.t_NationalityMoving;
    TRUNCATE TABLE Alls.t_NotificationMoving;
    TRUNCATE TABLE Company.t_OpenBoxMoving;
    TRUNCATE TABLE Company.t_PaySalaryMoving;
    TRUNCATE TABLE Users.t_PermissionMoving;
    TRUNCATE TABLE Gym.t_PersonalTrainerMoving;
    TRUNCATE TABLE Company.t_PlaceMoving;
    TRUNCATE TABLE Location.t_PostalCodeMoving;
    TRUNCATE TABLE Customers.t_PrescriptionMoving;
    TRUNCATE TABLE Invoices.t_PurchasingMoving;
    TRUNCATE TABLE Invoices.t_PurchasingReturnMoving;
    TRUNCATE TABLE Quotations.t_QuotationMoving;
    TRUNCATE TABLE Quotations.t_QuotationNoteMoving;
    TRUNCATE TABLE Quotations.t_QuotationTypeMoving;
    TRUNCATE TABLE Quotations.t_QuotationWarrantyMoving;
    TRUNCATE TABLE Items.t_ReasonStockAdjustmentMoving;
    TRUNCATE TABLE Location.t_RegionMoving;
    TRUNCATE TABLE Options.t_ReportHeaderFooterMoving;
    TRUNCATE TABLE Employees.t_SalesPersonMoving;
    TRUNCATE TABLE Employees.t_ShiftMoving;
    TRUNCATE TABLE Company.t_SMSServiceMoving;
    TRUNCATE TABLE Company.t_SocialMediaTypeMoving;
    TRUNCATE TABLE Invoices.t_SoldMoving;
    TRUNCATE TABLE Invoices.t_SoldReturnMoving;
    TRUNCATE TABLE Location.t_StatesMoving;
    TRUNCATE TABLE Items.t_StockAdjustmentMoving;
    TRUNCATE TABLE Items.t_StockTakeMoving;
    TRUNCATE TABLE Location.t_StreetMoving;
    TRUNCATE TABLE Items.t_SubCategoryMoving;
    TRUNCATE TABLE Gym.t_SubscriptionTypeMoving;
    TRUNCATE TABLE Employees.t_TeamsMoving;
    TRUNCATE TABLE Customers.t_TitleMoving;
    TRUNCATE TABLE Transactions.t_TransactionMoving;
    TRUNCATE TABLE Transactions.t_TransactionQuickStatementMoving;
    TRUNCATE TABLE Invoices.t_TransferMoving;
    TRUNCATE TABLE Items.t_UnityMoving;
    TRUNCATE TABLE Users.t_UserMoving;
    TRUNCATE TABLE Employees.t_VacationMoving;
    TRUNCATE TABLE Employees.t_VacationTypeMoving;
    TRUNCATE TABLE Vendors.t_VendorMoving;
    TRUNCATE TABLE Company.t_WarehouseMoving;
    TRUNCATE TABLE Options.t_WorldFoodProgrammeMoving;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY

  BEGIN CATCH

    ROLLBACK;

    RETURN 0;

  END CATCH;

END;









GO
