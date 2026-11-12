SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Alls].[s_InsertDefaultData]
AS
BEGIN

  BEGIN -- Alls

    EXECUTE Alls.s_CompanyInfoInsertDefaultData;

    EXECUTE Alls.s_LanguageCodeInsertDefaultData;

    EXECUTE [Alls].[s_LiveVersionInsertDefaultData];

    EXECUTE [Alls].[s_SectionInsertDefaultData];

  END;

  BEGIN -- Company

    EXECUTE Company.s_FileStorageTypeInsertDefaultData;

    EXECUTE Company.s_SocialMediaTypeInsertDefaultData;
			
  END;

  BEGIN -- Customer

    EXECUTE Customers.s_ClassificationInsertDefaultData;

    EXECUTE Customers.s_TitleInsertDefaultData;
	
    EXECUTE Customers.s_InternetPackageInsertDefaultData;
		
    EXECUTE Customers.s_AgeRangeInsertDefaultData;

  END;

  BEGIN -- Employee

    EXECUTE Employees.s_BonusTypeInsertDefaultData;

    EXECUTE Employees.s_DiscountTypeInsertDefaultData;

    EXECUTE Employees.s_EmployeeTypeInsertDefaultData;

    EXECUTE Employees.s_NationalityInsertDefaultData;

    EXECUTE Employees.s_VacationTypeInsertDefaultData;

  END;

  BEGIN -- Gym

    EXECUTE Gym.s_SubscriptionTypeInsertDefaultData;

  END;

  BEGIN -- Invoices

    EXECUTE Invoices.s_InvoiceTitleInsertDefaultData;

  END;

  BEGIN -- Location

    EXECUTE Location.s_BuildingInsertDefaultData;

    EXECUTE Location.s_FloorInsertDefaultData;

    EXECUTE Location.s_PostalCodeInsertDefaultData;

    EXECUTE Location.s_StreetInsertDefaultData;

  END;

  BEGIN -- Options

    EXECUTE Options.s_ReportHeaderFooterInsertDefaultData;

    EXECUTE Options.s_WorldFoodProgrammeInsertDefaultData;

  END;

  BEGIN -- Items 

    EXECUTE Items.s_BrandInsertDefaultData;

    EXECUTE Items.s_SubCategoryInsertDefaultData;

    EXECUTE Items.s_ItemSharedOptionInsertDefaultData;

    EXECUTE Items.s_UnityInsertDefaultData;

    EXECUTE Items.s_ReasonStockAdjustmentInsertDefaultData;

    EXECUTE Items.s_ProfitPartnerInsertDefaultData;

  END;

  BEGIN -- Quotations 

    EXECUTE Quotations.s_QuotationTypeInsertDefaultData;

    EXECUTE Quotations.s_QuotationWarrantyInsertDefaultData;

  END;
  
  BEGIN -- Cars

    EXECUTE Cars.s_CarClassInsertDefaultData;
    EXECUTE Cars.s_CarMakeInsertDefaultData;
    EXECUTE Cars.s_CarRentalStatisticsInsertDefaultData;

  END;

  EXECUTE Company.s_DoctorInsertDefaultData;

  EXECUTE Users.s_UserInsertDefaultData;

  EXECUTE Company.s_WareHouseInsertDefaultData;

  EXECUTE Company.s_BankInsertDefaultData;

  EXECUTE Currencys.s_CurrencyInsertDefaultData;

  EXECUTE Vendors.s_VendorInsertDefaultData;
	     
  EXECUTE Employees.s_SalesPersonInsertDefaultData;

  EXECUTE Employees.s_EmployeeInsertDefaultData;

  EXECUTE Customers.s_CustomerInsertDefaultData;

  EXECUTE Company.s_AccountInsertDefaultData;
	
END;




GO
