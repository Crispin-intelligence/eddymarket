SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Customers].[v_CustomerPrescription]
AS
SELECT  t.ID ,
        t.Name ,
        t.PrescriptionDoctorID ,
        t.PrescriptionDoctor ,
        t.PrescriptionBrandID ,
        t.PrescriptionBrand ,
        t.PrescriptionTypeIs ,
        t.PrescriptionFocal ,
        t.PrescriptionWithRight ,
        t.PrescriptionWithLeft ,
        t.PrescriptionSphereRight ,
        t.PrescriptionSphereLeft ,
        t.PrescriptionCylinderRight ,
        t.PrescriptionCylinderLeft ,
        t.PrescriptionAxisRight ,
        t.PrescriptionAxisLeft ,
        t.PrescriptionPrismRight ,
        t.PrescriptionPrismLeft ,
        t.PrescriptionBaseRight ,
        t.PrescriptionBaseLeft ,
        t.PrescriptionAddition ,
        t.PrescriptionHeightRight ,
        t.PrescriptionHeightLeft ,
        t.PrescriptionPDRight ,
        t.PrescriptionPDLeft ,
        t.PrescriptionPD ,
        t.PrescriptionDescriptionIs ,
        t.DateCreate
FROM    Customers.t_Customer AS t;
















GO
