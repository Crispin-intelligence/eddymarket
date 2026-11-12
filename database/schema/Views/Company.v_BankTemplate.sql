SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_BankTemplate]
AS
SELECT t.ID,
       t.CurrencyX,
       t.CurrencyY,
       t.PriceX,
       t.PriceY,
       t.NoteX,
       t.NoteY,
       t.BeneficiaryX,
       t.BeneficiaryY,
       t.PriceWordX,
       t.PriceWordY,
       t.AddressX,
       t.AddressY,
       t.DateX,
       t.DateY,
       t.UnderlinedX,
       t.UnderlinedY,
       t.UnderlinedH,
       t.UnderlinedW
FROM Company.t_Bank AS t;


GO
