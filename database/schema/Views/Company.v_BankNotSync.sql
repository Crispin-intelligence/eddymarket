SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_BankNotSync]
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
        t.CurrencyX ,
        t.CurrencyY ,
        t.PriceX ,
        t.PriceY ,
        t.NoteX ,
        t.NoteY ,
        t.BeneficiaryX ,
        t.BeneficiaryY ,
        t.PriceWordX ,
        t.PriceWordY ,
        t.AddressX ,
        t.AddressY ,
        t.DateX ,
        t.DateY ,
        t.UnderlinedX ,
        t.UnderlinedY ,
        t.UnderlinedH ,
        t.UnderlinedW ,
        t.DescriptionIs ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_Bank AS t
INNER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                      AND t1.SectionID = 38
WHERE   t.IsSync = 0;


GO
