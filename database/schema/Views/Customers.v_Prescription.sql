SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Customers].[v_Prescription]
AS
SELECT  t.ID ,
        t.Ref ,
        t.RefF ,
        t.RefPaper ,
        t.DateIs ,
        t.CustomerID ,
        t.Customer ,
        t.DoctorID ,
        t.Doctor ,
        t.BrandID ,
        t.Brand ,
        t.TypeIs ,
        t.Focal ,
        t.WithRight ,
        t.WithLeft ,
        t.SphereRight ,
        t.SphereLeft ,
        t.CylinderRight ,
        t.CylinderLeft ,
        t.AxisRight ,
        t.AxisLeft ,
        t.PrismRight ,
        t.PrismLeft ,
        t.BaseRight ,
        t.BaseLeft ,
        t.Addition ,
        t.HeightRight ,
        t.HeightLeft ,
        t.PDRight ,
        t.PDLeft ,
        t.PD ,
        t.DescriptionIs ,
        t.DateCreate ,
        t.IsSync
FROM    Customers.t_Prescription AS t;



GO
