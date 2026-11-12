SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Company].[v_ChequeBase]
AS
SELECT t.ID,
       t.Ref,
       t.RefF,
	   t.NumberIs,
	   t.BankID,
	   t.DateCreate
FROM Company.t_Cheque AS t;



GO
