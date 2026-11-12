SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Company].[v_AccountNotSync]
AS
SELECT  t.ID ,
        t.Level3ID ,
        t.Level3 ,
        t.SectionID ,
        t.LinkWithID ,
        t.LinkWith ,
        t.IsMasterLink ,
        t.NumberIs ,
        t.NumberF ,
        t.NumberNet ,
        t.Name ,
        t.Balance ,
        t.BalanceF ,
        t.BalanceD ,
        t.BalanceLL ,
        t.BalanceEuro ,
        t.CurrencyID ,
        t.Currency ,
        t.CurrencyTypeIs ,
        t.Limit ,
        t.LimitF ,
        t.LimitD ,
        t.IsStatic ,
        t.ShowInGymClass ,
        t.ShowInPersonalTrainer ,
        t.DescriptionIs ,
        t.UserBlockedC ,
        t.UsersNames ,
        t.AccountMergeC ,
        t.AccountMergeNames ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.LastAction ,
        t.MakeInactiveAfter ,
        t.MakeInactiveAfterType ,
        t.DeliveryServicesC ,
        t.DeliveryServicesTotal ,
        t.DeliveryServicesTotalF ,
        t.DeliveryServicesProfit ,
        t.DeliveryServicesProfitF ,
        t.DeliveryServicesLastDate ,
        t.PurchasingC ,
        t.PurchasingTotal ,
        t.PurchasingTotalF ,
        t.PurchasingProfit ,
        t.PurchasingProfitF ,
        t.PurchasingLast ,
        t.PurchasingReturnC ,
        t.PurchasingReturnTotal ,
        t.PurchasingReturnTotalF ,
        t.PurchasingReturnProfit ,
        t.PurchasingReturnProfitF ,
        t.PurchasingReturnLast ,
        t.SoldC ,
        t.SoldTotal ,
        t.SoldTotalF ,
        t.SoldProfit ,
        t.SoldProfitF ,
        t.SoldLast ,
        t.SoldReturnC ,
        t.SoldReturnTotal ,
        t.SoldReturnTotalF ,
        t.SoldReturnProfit ,
        t.SoldReturnProfitF ,
        t.SoldReturnLast ,
        t.QuotationC ,
        t.QuotationTotal ,
        t.QuotationTotalF ,
        t.QuotationProfit ,
        t.QuotationProfitF ,
        t.QuotationLast ,
        t.GymSubscriptionIsActive ,
        t.GymSubscriptionActiveTo ,
        t.GymSubscriptionC ,
        t.GymSubscriptionTotal ,
        t.GymSubscriptionTotalF ,
        t.GymSubscriptionProfit ,
        t.GymSubscriptionProfitF ,
        t.GymSubscriptionLast ,
        t.GymMemberAttendanceC ,
        t.GymMemberAttendanceLast ,
        t.SearchText ,
        t.DateCreate
FROM    Company.t_Account AS t
WHERE   t.IsSync = 0;








GO
