SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Alls].[v_MovingToday]
AS
SELECT  t.ID ,
        148 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Alls.t_LanguageCodeMoving AS t
LEFT OUTER JOIN Alls.t_LanguageCode AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        110 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Alls.t_NotificationMoving AS t
LEFT OUTER JOIN Alls.t_Notification AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        178 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Cars.t_CarClassMoving AS t
LEFT OUTER JOIN Cars.t_CarClass AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        184 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Cars.t_CarDriverMoving AS t
LEFT OUTER JOIN Cars.t_CarDriver AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        182 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Cars.t_CarExpenseMoving AS t
LEFT OUTER JOIN Cars.t_CarExpense AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        188 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Cars.t_CarMakeMoving AS t
LEFT OUTER JOIN Cars.t_CarMake AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        189 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Cars.t_CarModelMoving AS t
LEFT OUTER JOIN Cars.t_CarModel AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        177 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.VehicleIdentificationNumber AS Name
FROM    Cars.t_CarMoving AS t
LEFT OUTER JOIN Cars.t_Car AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        179 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Cars.t_CarOwnersProfileMoving AS t
LEFT OUTER JOIN Cars.t_CarOwnersProfile AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        185 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Cars.t_CarRentalMoving AS t
LEFT OUTER JOIN Cars.t_CarRental AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        181 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        '' AS Name
FROM    Cars.t_CarRentalStatisticsMoving AS t
LEFT OUTER JOIN Cars.t_CarRentalStatistics AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        159 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_AccountGroupMoving AS t
LEFT OUTER JOIN Company.t_AccountGroup AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        37 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_AccountMoving AS t
LEFT OUTER JOIN Company.t_Account AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        38 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_BankMoving AS t
LEFT OUTER JOIN Company.t_Bank AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        112 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Company.t_BondMoving AS t
LEFT OUTER JOIN Company.t_Bond AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        81 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Company.t_ChequeMoving AS t
LEFT OUTER JOIN Company.t_Cheque AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        160 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Company.t_CloseBoxMoving AS t
LEFT OUTER JOIN Company.t_CloseBox AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        153 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_ContactMoving AS t
LEFT OUTER JOIN Company.t_Contact AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        163 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_DoctorMoving AS t
LEFT OUTER JOIN Company.t_Doctor AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        8 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Company.t_ExpenseMoving AS t
LEFT OUTER JOIN Company.t_Expense AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        72 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_FileStorageMoving AS t
LEFT OUTER JOIN Company.t_FileStorage AS t1 ON t.SectionID = t1.ID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        71 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_FileStorageTypeMoving AS t
LEFT OUTER JOIN Company.t_FileStorageType AS t1 ON t.SectionID = t1.ID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        9 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Company.t_OpenBoxMoving AS t
LEFT OUTER JOIN Company.t_OpenBox AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        11 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Company.t_PaySalaryMoving AS t
LEFT OUTER JOIN Company.t_PaySalary AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        40 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_PlaceMoving AS t
LEFT OUTER JOIN Company.t_Place AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        167 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        N'' AS Name
FROM    Company.t_SMSServiceMoving AS t
LEFT OUTER JOIN Company.t_SMSService AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        151 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_SocialMediaTypeMoving AS t
LEFT OUTER JOIN Company.t_SocialMediaType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        42 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Company.t_WarehouseMoving AS t
LEFT OUTER JOIN Company.t_WareHouse AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        43 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Currencys.t_CurrencyMoving AS t
LEFT OUTER JOIN Currencys.t_Currency AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        164 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Customers.t_AgeRangeMoving AS t
LEFT OUTER JOIN Customers.t_AgeRange AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        45 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Customers.t_ClassificationMoving AS t
LEFT OUTER JOIN Customers.t_Classification AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        165 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Customers.t_CustomerGroupMoving AS t
LEFT OUTER JOIN Customers.t_CustomerGroup AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        15 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Customers.t_CustomerMoving AS t
LEFT OUTER JOIN Customers.t_Customer AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        169 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Customers.t_FrameJobOrderMoving AS t
LEFT OUTER JOIN Customers.t_FrameJobOrder AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        17 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Customers.t_InternetPackageMoving AS t
LEFT OUTER JOIN Customers.t_InternetPackage AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        166 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Customers.t_PrescriptionMoving AS t
LEFT OUTER JOIN Customers.t_Prescription AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        46 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Customers.t_TitleMoving AS t
LEFT OUTER JOIN Customers.t_Title AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        146 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Employees.t_BonusMoving AS t
LEFT OUTER JOIN Employees.t_Bonus AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        145 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_BonusTypeMoving AS t
LEFT OUTER JOIN Employees.t_BonusType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        95 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Employees.t_DiscountMoving AS t
LEFT OUTER JOIN Employees.t_Discount AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        94 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_DiscountTypeMoving AS t
LEFT OUTER JOIN Employees.t_DiscountType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        33 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_EmployeeMoving AS t
LEFT OUTER JOIN Employees.t_Employee AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        34 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_EmployeeTypeMoving AS t
LEFT OUTER JOIN Employees.t_EmployeeType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        47 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_NationalityMoving AS t
LEFT OUTER JOIN Employees.t_Nationality AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        149 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_SalesPersonMoving AS t
LEFT OUTER JOIN Employees.t_SalesPerson AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        134 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Employees.t_ShiftMoving AS t
LEFT OUTER JOIN Employees.t_Shift AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        91 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Employees.t_VacationMoving AS t
LEFT OUTER JOIN Employees.t_Vacation AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        90 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Employees.t_VacationTypeMoving AS t
LEFT OUTER JOIN Employees.t_VacationType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        173 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Gym.t_GymClassMoving AS t
LEFT OUTER JOIN Gym.t_GymClass AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        175 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Account AS Name
FROM    Gym.t_GymMemberAttendanceMoving AS t
LEFT OUTER JOIN Gym.t_GymMemberAttendance AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        174 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Gym.t_GymSubscriptionMoving AS t
LEFT OUTER JOIN Gym.t_GymSubscription AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        172 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Gym.t_PersonalTrainerMoving AS t
LEFT OUTER JOIN Gym.t_PersonalTrainer AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        171 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Gym.t_SubscriptionTypeMoving AS t
LEFT OUTER JOIN Gym.t_SubscriptionType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        162 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_DeliveryServiceMoving AS t
LEFT OUTER JOIN Invoices.t_DeliveryService AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        18 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_InternetSubscriptionMoving AS t
LEFT OUTER JOIN Invoices.t_InternetSubscription AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        19 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Invoices.t_InvoiceTitleMoving AS t
LEFT OUTER JOIN Invoices.t_InvoiceTitle AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        0 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_PurchasingMoving AS t
LEFT OUTER JOIN Invoices.t_Purchasing AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        1 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_PurchasingReturnMoving AS t
LEFT OUTER JOIN Invoices.t_PurchasingReturn AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        2 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_SoldMoving AS t
LEFT OUTER JOIN Invoices.t_Sold AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        3 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_SoldReturnMoving AS t
LEFT OUTER JOIN Invoices.t_SoldReturn AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        50 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Invoices.t_TransferMoving AS t
LEFT OUTER JOIN Invoices.t_TransferAwaited AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        158 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Items.t_BeginningInventoryQuantityMoving AS t
LEFT OUTER JOIN Items.t_BeginningInventoryQuantity AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        51 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_BrandMoving AS t
LEFT OUTER JOIN Items.t_Brand AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        168 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Items.t_ItemExpirationDateMoving AS t
LEFT OUTER JOIN Items.t_ItemExpirationDate AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        155 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Items.t_ItemProductionMoving AS t
LEFT OUTER JOIN Items.t_ItemProduction AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        10 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_ItemSharedMoving AS t
LEFT OUTER JOIN Items.t_ItemShared AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        52 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_MainCategoryMoving AS t
LEFT OUTER JOIN Items.t_MainCategory AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        192 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_ProfitPartnerMoving AS t
LEFT OUTER JOIN Items.t_ProfitPartner AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        6 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_ReasonStockAdjustmentMoving AS t
LEFT OUTER JOIN Items.t_ReasonStockAdjustment AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        7 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Items.t_StockAdjustmentMoving AS t
LEFT OUTER JOIN Items.t_StockAdjustment AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        101 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Items.t_StockTakeMoving AS t
LEFT OUTER JOIN Items.t_StockTake AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        53 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_SubCategoryMoving AS t
LEFT OUTER JOIN Items.t_SubCategory AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        54 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Items.t_UnityMoving AS t
LEFT OUTER JOIN Items.t_Unity AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        59 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Location.t_BuildingMoving AS t
LEFT OUTER JOIN Location.t_Building AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        58 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Location.t_FloorMoving AS t
LEFT OUTER JOIN Location.t_Floor AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        150 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Location.t_PostalCodeMoving AS t
LEFT OUTER JOIN Location.t_PostalCode AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        56 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Location.t_RegionMoving AS t
LEFT OUTER JOIN Location.t_Region AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        55 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Location.t_StatesMoving AS t
LEFT OUTER JOIN Location.t_States AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        57 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Location.t_StreetMoving AS t
LEFT OUTER JOIN Location.t_Street AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        70 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Options.t_ReportHeaderFooterMoving AS t
LEFT OUTER JOIN Options.t_ReportHeaderFooter AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        123 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        '' AS Name
FROM    Options.t_WorldFoodProgrammeMoving AS t
LEFT OUTER JOIN Options.t_WorldFoodProgramme AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        4 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Quotations.t_QuotationMoving AS t
LEFT OUTER JOIN Quotations.t_Quotation AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        61 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Quotations.t_QuotationNoteMoving AS t
LEFT OUTER JOIN Quotations.t_QuotationNote AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        147 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Quotations.t_QuotationTypeMoving AS t
LEFT OUTER JOIN Quotations.t_QuotationType AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        63 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Quotations.t_QuotationWarrantyMoving AS t
LEFT OUTER JOIN Quotations.t_QuotationWarranty AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        65 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.RefF AS Name
FROM    Transactions.t_TransactionMoving AS t
LEFT OUTER JOIN Transactions.t_Transaction AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        161 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Transactions.t_TransactionQuickStatementMoving AS t
LEFT OUTER JOIN Transactions.t_TransactionQuickStatement AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t.UserID = t2.ID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        66 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Users.t_PermissionMoving AS t
LEFT OUTER JOIN Users.t_Permission AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        14 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Users.t_UserMoving AS t
INNER JOIN Users.t_User AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE())
UNION ALL
SELECT  t.ID ,
        67 AS SectionTypeID ,
        t.UserID ,
        t2.Name AS UserIs ,
        t.SectionID ,
        t.DateIs ,
        t.EventIs ,
        t.EventType ,
        t.ComputerIP ,
        t.Computer ,
        t.ComputerAccount ,
        t1.Name
FROM    Vendors.t_VendorMoving AS t
LEFT OUTER JOIN Vendors.t_Vendor AS t1 ON t1.ID = t.SectionID
INNER JOIN Users.t_User AS t2 ON t2.ID = t.UserID
WHERE   t.DateOnly = CONVERT(DATE, GETDATE());









GO
