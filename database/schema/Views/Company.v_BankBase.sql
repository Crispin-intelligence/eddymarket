SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Company].[v_BankBase]
AS
SELECT ID,
       Name
FROM Company.t_Bank;




GO
