SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [Employees].[v_EmployeeListNotBlocked]
AS
SELECT  t.ID ,
        t.Name ,
        t1.ID AS AccountID ,
        t1.Name AS Account ,
        t1.NumberF ,
        t1.BalanceF ,
        t1.ShowInGymClass ,
        t1.ShowInPersonalTrainer ,
        t.Phones ,
        t.PhonesC ,
        t.SocialMedia ,
        t.SocialMediaC ,
        t.TypeIs ,
        t.Gender ,
        t.Nationality ,
        t.Birthday ,
        t.AgeIs ,
        t.StatesIs ,
        t.RegionIs ,
        t.Street ,
        t.Building ,
        t.FloorIs ,
        t.PostalCode ,
        t.AddressNote ,
        t.AddressIs ,
        t.DateWork ,
        t.DescriptionIs ,
        t.ImageIs ,
        t.ImageID ,
        t.IDFingerPrint ,
        t.SalaryIs ,
        t.SalaryIsF ,
        t.SalaryDeliveryService ,
        t.SalaryDeliveryServiceF ,
        t.DaysWork ,
        t.DaysWorkHours ,
        t.TotalHoursFree ,
        t.TotalHoursMustWork ,
        t.SalaryHours ,
        t.SalaryHoursF ,
        t.VacationDay ,
        t.HoursLateX ,
        t.HoursOverX ,
        t.CalculationEarly ,
        t.CalculationOverTime ,
        t.ShiftFrom ,
        t.ShiftTo ,
        t.InWorkNow ,
        t.VacationAvailableC ,
        t.TotalExitEntryPermission ,
        t.DiscountAvailableF ,
        t.BonusAvailable ,
        t.BonusAvailableF ,
        t.RequestC ,
        t.FileStorageC ,
        t.FeedbackC ,
        t.StatusIs ,
        t.WhyThisStatus ,
        t.DateCreate ,
        t.IsSync ,
        t.IsSyncImage ,
        t.IsSyncImageID
FROM    Employees.t_Employee AS t
INNER  JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID
                                       AND t1.SectionID = 33
                                       AND t1.NumberIs BETWEEN 4210100000 AND 4219999999
WHERE   t.StatusIs <> 2;




















GO
