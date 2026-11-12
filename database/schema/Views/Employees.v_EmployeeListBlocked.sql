SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Employees].[v_EmployeeListBlocked]
AS
SELECT t.ID,
       t.Name,
       t1.Name AS Account,
       t1.NumberF,
       t1.BalanceF,
       t.Phones,
       t.SocialMedia,
       t.TypeIs,
       t.Gender,
       t.Nationality,
       t.AgeIs,
       t.AddressIs,
       t.DateWork,
       t.DescriptionIs,
       t.IDFingerPrint,
       t.WhyThisStatus,
       t.DateCreate
FROM Employees.t_Employee AS t
    LEFT OUTER JOIN Company.t_Account AS t1
        ON t.ID = t1.LinkWithID
           AND t1.SectionID = 33
           AND t1.NumberIs
           BETWEEN 4210100000 AND 4219999999
WHERE t.StatusIs = 2;



GO
