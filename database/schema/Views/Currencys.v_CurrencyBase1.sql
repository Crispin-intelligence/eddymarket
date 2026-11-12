SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Currencys].[v_CurrencyBase1]
AS
SELECT t.ID,
       t.Name,
       t.ExchangeRate,
	   t.ExchangeRateTax
FROM Currencys.t_Currency AS t;




GO
