SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [Company].[v_AccountListNotBlocked]
AS
SELECT t.ID ,
    t.SectionID ,
    t.LinkWithID ,
    t.LinkWith ,
    t.NumberF ,
    t.NumberIs ,
    t.NumberNet ,
    t.Name ,
    t.Balance ,
    t.BalanceF ,
    t.BalanceD ,
    t.BalanceLL ,
    t.BalanceEuro ,
    t.LimitF ,
    t.LimitD ,
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
    t.GymSubscriptionC ,
    t.GymSubscriptionTotal ,
    t.GymSubscriptionTotalF ,
    t.GymSubscriptionProfit ,
    t.GymSubscriptionProfitF ,
    t.GymSubscriptionLast ,
    t.GymSubscriptionActiveTo ,
    t.GymSubscriptionIsActive ,
    t.GymMemberAttendanceC ,
    t.GymMemberAttendanceLast ,
    t.DateCreate ,
    t.IsSync
  FROM Company.t_Account AS t
  WHERE t.StatusIs <> 2;









GO
