CREATE TABLE [Invoices].[t_ProfitDaily]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ID] DEFAULT (newsequentialid()),
[DateIs] [date] NOT NULL CONSTRAINT [DF_t_ProfitDaily_DateIs] DEFAULT (getdate()),
[DateMonthly] [date] NOT NULL CONSTRAINT [DF_t_ProfitDaily_DateMonthly] DEFAULT (getdate()),
[DateYearly] [date] NOT NULL CONSTRAINT [DF_t_ProfitDaily_DateYearly] DEFAULT (getdate()),
[SalesQtys] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesQtys] DEFAULT ((0)),
[SalesD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesD] DEFAULT ((0)),
[SalesLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesLL] DEFAULT ((0)),
[SalesEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesEuro] DEFAULT ((0)),
[GymSubscriptionD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_GymSubscriptionD] DEFAULT ((0)),
[GymSubscriptionLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_GymSubscriptionLL] DEFAULT ((0)),
[GymSubscriptionEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_GymSubscriptionEuro] DEFAULT ((0)),
[CarRentalD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_CarRentalD] DEFAULT ((0)),
[CarRentalLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_CarRentalLL] DEFAULT ((0)),
[CarRentalEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_CarRentalEuro] DEFAULT ((0)),
[CostD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_CostD] DEFAULT ((0)),
[CostLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_CostLL] DEFAULT ((0)),
[CostEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_CostEuro] DEFAULT ((0)),
[SalesCommissionD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesCommissionD] DEFAULT ((0)),
[SalesCommissionLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesCommissionLL] DEFAULT ((0)),
[SalesCommissionEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesCommissionEuro] DEFAULT ((0)),
[ProfitGrossD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_GrossProfitD] DEFAULT ((0)),
[ProfitGrossLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_GrossProfitLL] DEFAULT ((0)),
[ProfitGrossEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_GrossProfitEuro] DEFAULT ((0)),
[ProfitGrossRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ProfitDaily_ProfitGrossRate] DEFAULT ((0)),
[ProfitSalesRefundD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesRefundD] DEFAULT ((0)),
[ProfitSalesRefundLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesRefundLL] DEFAULT ((0)),
[ProfitSalesRefundEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalesRefundEuro] DEFAULT ((0)),
[ExpensesD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ExpensesD] DEFAULT ((0)),
[ExpensesLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ExpensesLL] DEFAULT ((0)),
[ExpensesEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ExpensesEuro] DEFAULT ((0)),
[SalaryD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalaryD] DEFAULT ((0)),
[SalaryLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalaryLL] DEFAULT ((0)),
[SalaryEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_SalaryEuro] DEFAULT ((0)),
[ProfitNetD] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ProfitNetD] DEFAULT ((0)),
[ProfitNetLL] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ProfitNetLL] DEFAULT ((0)),
[ProfitNetEuro] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_ProfitNetEuro] DEFAULT ((0)),
[ProfitNetRate] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_t_ProfitDaily_ProfitNetRate] DEFAULT ((0)),
[WorkStationID] [float] NOT NULL CONSTRAINT [DF_t_ProfitDaily_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Invoices].[tr_ProfitDaily] ON [Invoices].[t_ProfitDaily]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  BEGIN --Declare

    DECLARE @IDs AS TABLE
      (
        ID UNIQUEIDENTIFIER NOT NULL
      );

  END;

  BEGIN --Set info

    INSERT  @IDs
            ( ID )
    SELECT  s.ID
    FROM    Inserted AS s;

  END;

  BEGIN --Format

    UPDATE  Invoices.t_ProfitDaily
    SET     DateMonthly = DATEFROMPARTS(YEAR(DateIs), MONTH(DateIs), 1) ,
            DateYearly = DATEFROMPARTS(YEAR(DateIs), 1, 1) ,
            ProfitNetD = ProfitGrossD - ProfitSalesRefundD - ExpensesD - SalaryD - SalesCommissionD ,
            ProfitNetLL = ProfitGrossLL - ProfitSalesRefundLL - ExpensesLL - SalaryLL - SalesCommissionLL ,
            ProfitNetEuro = ProfitGrossEuro - ProfitSalesRefundEuro - ExpensesEuro - SalaryEuro - SalesCommissionEuro ,
            ProfitGrossRate = 0 ,
            ProfitNetRate = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   @IDs AS s
                     WHERE  s.ID = t_ProfitDaily.ID );

    UPDATE  Invoices.t_ProfitDaily
    SET     ProfitGrossRate = ( ProfitGrossLL / ( SalesLL + GymSubscriptionLL + CarRentalLL ) ) * 100.0 ,
            ProfitNetRate = ( ProfitNetLL / ( SalesLL + GymSubscriptionLL + CarRentalLL ) ) * 100.0
    WHERE   ( SalesLL + GymSubscriptionLL + CarRentalLL ) > 0
            AND EXISTS ( SELECT TOP ( 1 )
                                s.ID
                         FROM   @IDs AS s
                         WHERE  s.ID = t_ProfitDaily.ID );

  END;

  BEGIN --Delete

    DELETE  FROM Invoices.t_ProfitDaily
    WHERE   SalesQtys = 0
            AND SalesD = 0
            AND GymSubscriptionD = 0
            AND CarRentalD = 0
            AND CostD = 0
            AND SalesCommissionD = 0
            AND ProfitSalesRefundD = 0
            AND ExpensesD = 0
            AND SalaryD = 0;

  END;

END;
GO
ALTER TABLE [Invoices].[t_ProfitDaily] ADD CONSTRAINT [PK_t_ProfitDaily] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
