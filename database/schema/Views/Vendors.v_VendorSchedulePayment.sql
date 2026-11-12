SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Vendors].[v_VendorSchedulePayment]
AS
SELECT t.ID,
       t.PurchasingID,
       t.VendorID,
       t.Vendor,
       t.DateIs,
       t.Payment,
       t.PaymentF,
       t.PaymentD,
       t.PaymentLL,
       t.PaymentEuro,
       t.DescriptionIs,
       t.IsPayment,
       t.DateCreate
FROM Vendors.t_VendorSchedulePayment AS t;




GO
