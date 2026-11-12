SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [Company].[v_CloseBoxDetailListShort]
AS
SELECT t.ID,
       t.CloseBoxID,
       t.Price,
       t.PriceF,
       t.PriceD,
       t.Qty,
	   t.Total,
	   t.TotalF,
	   t.DescriptionIs,
       t.DateCreate
FROM Company.t_CloseBoxDetail AS t;







GO
