SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [Cars].[v_CarChoose]
AS
SELECT  t.ID ,
        t.FullName ,
        t.VehicleIdentificationNumber ,
        t.RegistrationNumber ,
        t.Make ,
        t.Model ,
        t.YearIs ,
        t.ClassName ,
        t.DayPriceF ,
        t.WeekPriceF ,
        t.MonthPriceF ,
        t.StatusIs ,
        t.DateCreate
FROM    Cars.t_Car AS t;









GO
