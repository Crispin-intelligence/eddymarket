SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [Customers].[v_CustomerNotSync]
AS
SELECT  t.ID ,
        t.IDNumber ,
        t.IDDoor ,
        t.Name ,
        t.NameAR ,
        t1.ID AS AccountID ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.CurrencyID AS AccountCurrencyID ,
        t1.Currency AS AccountCurrency ,
        t1.Balance ,
        t1.BalanceD ,
        t1.BalanceF ,
        t1.LimitD ,
        t1.LimitF ,
        t1.DeliveryServicesC ,
        t1.DeliveryServicesTotal ,
        t1.DeliveryServicesTotalF ,
        t1.DeliveryServicesProfit ,
        t1.DeliveryServicesProfitF ,
        t1.DeliveryServicesLastDate ,
        t1.GymSubscriptionC ,
        t1.GymSubscriptionTotal ,
        t1.GymSubscriptionTotalF ,
        t1.GymSubscriptionProfit ,
        t1.GymSubscriptionProfitF ,
        t1.GymSubscriptionLast ,
        t1.GymSubscriptionActiveTo ,
        t1.GymSubscriptionIsActive ,
        t1.GymMemberAttendanceC ,
        t1.GymMemberAttendanceLast ,
        t.Reference ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.Gender ,
        t.Birthday ,
        t.AgeIs ,
        t.AgeRangeID ,
        t.AgeRange ,
        t.TitleID ,
        t.Title ,
        t.ClassificationID ,
        t.Classification ,
        t.SalesPersonID ,
        t.SalesPerson ,
        t.NationalityID ,
        t.Nationality ,
        t.StatesID ,
        t.StatesIs ,
        t.RegionID ,
        t.RegionIs ,
        t.StreetID ,
        t.Street ,
        t.BuildingID ,
        t.Building ,
        t.FloorID ,
        t.FloorIs ,
        t.PostalCodeID ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.AddressC ,
        t.NumberCurrency ,
        t.CallAfter ,
        t.CallAfterF ,
        t.DescriptionIs ,
        t.ImagePath ,
        t.ImageIDPath ,
        t.QuotationC ,
        t.RequestC ,
        t.FeedbackC ,
        t.CallC ,
        t.FileStorageC ,
        t.RatingFeedback ,
        t.AdditionalProperty1 ,
        t.AdditionalProperty2 ,
        t.AdditionalProperty3 ,
        t.AdditionalProperty4 ,
        t.AdditionalProperty5 ,
        t.AdditionalProperty6 ,
        t.AdditionalProperty7 ,
        t.AdditionalProperty8 ,
        t.AdditionalProperty9 ,
        t.AdditionalProperty10 ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.LicenseInternet ,
        t.EmployeeIDInternet ,
        t.EmployeeInternet ,
        t.InternetPackageID ,
        t.InternetPackage ,
        t.StartFromInternet ,
        t.ActiveToInternet ,
        t.ActiveToDayInternet ,
        t.NotificationBeforeDaysInternet ,
        t.NotificationDateInternet ,
        t.NotificationARInternet ,
        t.NotificationENInternet ,
        t.UserNameInternet ,
        t.PasswordInternet ,
        t.InternetSubscriptionC ,
        t.InternetSubscriptionTotal ,
        t.InternetSubscriptionTotalF ,
        t.InternetSubscriptionProfit ,
        t.InternetSubscriptionProfitF ,
        t.InternetSubscriptionLast ,
        t.PricingType ,
        t.PriceIncreaseRate ,
        t.PaymentMethod ,
        t.MaximumDebtInvoiceCurrencyID ,
        t.MaximumDebtInvoiceCurrency ,
        t.MaximumDebtInvoice ,
        t.MaximumDebtInvoiceF ,
        t.MaximumDebtInvoiceD ,
        t.FromWFP ,
        t.GroupNames ,
        t.GroupCounts ,
        t.PrescriptionDoctorID ,
        t.PrescriptionDoctor ,
        t.PrescriptionBrandID ,
        t.PrescriptionBrand ,
        t.PrescriptionTypeIs ,
        t.PrescriptionFocal ,
        t.PrescriptionWithRight ,
        t.PrescriptionWithLeft ,
        t.PrescriptionSphereRight ,
        t.PrescriptionSphereLeft ,
        t.PrescriptionCylinderRight ,
        t.PrescriptionCylinderLeft ,
        t.PrescriptionAxisRight ,
        t.PrescriptionAxisLeft ,
        t.PrescriptionPrismRight ,
        t.PrescriptionPrismLeft ,
        t.PrescriptionBaseRight ,
        t.PrescriptionBaseLeft ,
        t.PrescriptionAddition ,
        t.PrescriptionHeightRight ,
        t.PrescriptionHeightLeft ,
        t.PrescriptionPDRight ,
        t.PrescriptionPDLeft ,
        t.PrescriptionPD ,
        t.PrescriptionDescriptionIs ,
        t.PrescriptionLastDate ,
        t.PrescriptionC ,
        t.FrameJobOrderC ,
        t.FrameJobOrderTotal ,
        t.FrameJobOrderTotalF ,
        t.FrameJobOrderProfit ,
        t.FrameJobOrderProfitF ,
        t.FrameJobOrderLast ,
        t.SearchText ,
        t.DateCreate
FROM    Customers.t_Customer AS t
INNER  JOIN Company.t_Account AS t1 ON t1.LinkWithID = t.ID
                                       AND t1.IsMasterLink = 1
                                       AND t1.SectionID = 15
WHERE   t.IsSync = 0;

  
















GO
