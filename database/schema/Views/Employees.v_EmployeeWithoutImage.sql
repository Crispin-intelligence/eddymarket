SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [Employees].[v_EmployeeWithoutImage]
AS
SELECT t.ID ,
    t.Name ,
    t1.ID AS AccountID ,
    t1.Name AS Account ,
    t1.NumberF ,
    t1.Balance ,
    t1.BalanceF ,
    t1.ShowInGymClass ,
    t1.ShowInPersonalTrainer ,
    t.Phones ,
    t.PhonesC ,
    t.SocialMedia ,
    t.SocialMediaC ,
    t.TypeID ,
    t.TypeIs ,
    t.Gender ,
    t.NationalityID ,
    t.Nationality ,
    t.Birthday ,
    t.AgeIs ,
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
    t.DateWork ,
    t.DescriptionIs ,
    t.IDFingerPrint ,
    t.CurrencyID ,
    t.Currency ,
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
    t.DateCreate
  FROM Employees.t_Employee AS t
  LEFT OUTER JOIN Company.t_Account AS t1 ON t.ID = t1.LinkWithID AND t1.SectionID = 33 AND t1.NumberIs BETWEEN 4210100000 AND 4219999999;
		   




GO
