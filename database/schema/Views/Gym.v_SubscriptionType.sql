SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Gym].[v_SubscriptionType]
AS
SELECT  t.ID ,
        t.Name ,
        t.NameF ,
        t.TypeIs ,
        t.NumberIs ,
        t.TimePeriodDays ,
        t.TimePeriodARF ,
        t.TimePeriodENF ,
        t.CurrencyID ,
        t.Currency ,
        t.Price ,
        t.PriceF ,
        t.PriceD ,
        t.PriceLL ,
        t.PriceEuro ,
        t.DescriptionIs ,
        t.IsEnabled ,
        t.DateCreate ,
        t.NumberOfSubscriptions ,
        t.IsSync
FROM    Gym.t_SubscriptionType AS t;




GO
