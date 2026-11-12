SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Vendors].[v_VendorWithoutImage]
AS
SELECT  t.ID ,
        t.Name ,
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
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.TitleID ,
        t.Title ,
        t.ClassificationID ,
        t.Classification ,
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
        t.Payment ,
        t.PaymentF ,
        t.PaymentD ,
        t.PaymentEvery ,
        t.PaymentEveryType ,
        t.DescriptionIs ,
        t.ImagePath ,
        t.CallC ,
        t.FileStorageC ,
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
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage
FROM    Vendors.t_Vendor AS t
INNER  JOIN Company.t_Account AS t1 ON t1.SectionID = 67
                                       AND t1.IsMasterLink = 1
                                       AND t1.LinkWithID = t.ID;
		   



GO
