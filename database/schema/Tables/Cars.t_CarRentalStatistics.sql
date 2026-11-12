CREATE TABLE [Cars].[t_CarRentalStatistics]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ID] DEFAULT (newsequentialid()),
[Cars] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Cars] DEFAULT ((0)),
[CarsTransmissionUnknown] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTransmissionUnknown] DEFAULT ((0)),
[CarsTransmissionManual] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTransmissionManual] DEFAULT ((0)),
[CarsTransmissionAutomatic] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTransmissionAutomatic] DEFAULT ((0)),
[CarsTransmissionContinuouslyVariable] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTransmissionContinuouslyVariable] DEFAULT ((0)),
[CarsTransmissionSemiAutomatic] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTransmissionSemiAutomatic] DEFAULT ((0)),
[CarsTransmissionDualClutch] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTransmissionDualClutch] DEFAULT ((0)),
[CarsFuelTypeUnknown] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypeUnknown] DEFAULT ((0)),
[CarsFuelTypeGasoline] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypeGasoline] DEFAULT ((0)),
[CarsFuelTypeDiesel] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypeDiesel] DEFAULT ((0)),
[CarsFuelTypeGas] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypeGas] DEFAULT ((0)),
[CarsFuelTypeElectric] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypeElectric] DEFAULT ((0)),
[CarsFuelTypeHybrid] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypeHybrid] DEFAULT ((0)),
[CarsFuelTypePetrol] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypePetrol] DEFAULT ((0)),
[CarsFuelTypePetrolGas] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsFuelTypePetrolGas] DEFAULT ((0)),
[CarsAvailabilityAvailable] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsAvailabilityAvailable] DEFAULT ((0)),
[CarsAvailabilityUnavailable] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsAvailabilityUnavailable] DEFAULT ((0)),
[CarsTotalPurchasePriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTotalPurchasePriceD] DEFAULT ((0)),
[CarsTotalPurchasePriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTotalPurchasePriceLL] DEFAULT ((0)),
[CarsTotalPurchasePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTotalPurchasePriceEuro] DEFAULT ((0)),
[CarsTotalSalePriceD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTotalSalePriceD] DEFAULT ((0)),
[CarsTotalSalePriceLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTotalSalePriceLL] DEFAULT ((0)),
[CarsTotalSalePriceEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsTotalSalePriceEuro] DEFAULT ((0)),
[CarsCarForRent] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsCarForRent] DEFAULT ((0)),
[CarsCarForSale] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsCarForSale] DEFAULT ((0)),
[CarsCarForExchange] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsCarForExchange] DEFAULT ((0)),
[CarsInsuranceIsActiveTrue] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsInsuranceIsActiveTrue] DEFAULT ((0)),
[CarsInsuranceIsActiveFalse] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsInsuranceIsActiveFalse] DEFAULT ((0)),
[CarsStatusIsActive] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsStatusIsActive] DEFAULT ((0)),
[CarsStatusIsInactive] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsStatusIsInactive] DEFAULT ((0)),
[CarsStatusIsBlocked] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_CarsStatusIsBlocked] DEFAULT ((0)),
[Classes] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Classes] DEFAULT ((0)),
[Owners] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Owners] DEFAULT ((0)),
[Expenses] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Expenses] DEFAULT ((0)),
[ExpensesSubTotalD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesSubTotalD] DEFAULT ((0)),
[ExpensesSubTotalLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesSubTotalLL] DEFAULT ((0)),
[ExpensesSubTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesSubTotalEuro] DEFAULT ((0)),
[ExpensesTaxValueD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesTaxValueD] DEFAULT ((0)),
[ExpensesTaxValueLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesTaxValueLL] DEFAULT ((0)),
[ExpensesTaxValueEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesTaxValueEuro] DEFAULT ((0)),
[ExpensesTotalD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesTotalD] DEFAULT ((0)),
[ExpensesTotalLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesTotalLL] DEFAULT ((0)),
[ExpensesTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ExpensesTotalEuro] DEFAULT ((0)),
[Drivers] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Drivers] DEFAULT ((0)),
[DriversGenderMale] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversGenderMale] DEFAULT ((0)),
[DriversGenderFemale] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversGenderFemale] DEFAULT ((0)),
[DriversGenderUnknown] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversGenderUnknown] DEFAULT ((0)),
[DriversBloodTypeUnknown] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeUnknown] DEFAULT ((0)),
[DriversBloodTypeA_Plus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeA_Plus] DEFAULT ((0)),
[DriversBloodTypeA_Minus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeA_Minus] DEFAULT ((0)),
[DriversBloodTypeB_Plus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeB_Plus] DEFAULT ((0)),
[DriversBloodTypeB_Minus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeB_Minus] DEFAULT ((0)),
[DriversBloodTypeO_Plus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeO_Plus] DEFAULT ((0)),
[DriversBloodTypeO_Minus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeO_Minus] DEFAULT ((0)),
[DriversBloodTypeAB_Plus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeAB_Plus] DEFAULT ((0)),
[DriversBloodTypeAB_Minus] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_DriversBloodTypeAB_Minus] DEFAULT ((0)),
[Makers] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Makers] DEFAULT ((0)),
[Models] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Models] DEFAULT ((0)),
[Rentals] [bigint] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_Rentals] DEFAULT ((0)),
[RentalsSubtotalD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsSubtotalD] DEFAULT ((0)),
[RentalsSubtotalLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsSubtotalLL] DEFAULT ((0)),
[RentalsSubtotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsSubtotalEuro] DEFAULT ((0)),
[RentalsDiscountD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsDiscountD] DEFAULT ((0)),
[RentalsDiscountLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsDiscountLL] DEFAULT ((0)),
[RentalsDiscountEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsDiscountEuro] DEFAULT ((0)),
[RentalsTotalD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsTotalD] DEFAULT ((0)),
[RentalsTotalLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsTotalLL] DEFAULT ((0)),
[RentalsTotalEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsTotalEuro] DEFAULT ((0)),
[RentalsTotalTaxD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsTotalTaxD] DEFAULT ((0)),
[RentalsTotalTaxLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsTotalTaxLL] DEFAULT ((0)),
[RentalsTotalTaxEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsTotalTaxEuro] DEFAULT ((0)),
[RentalsProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsProfitD] DEFAULT ((0)),
[RentalsProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsProfitLL] DEFAULT ((0)),
[RentalsProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_RentalsProfitEuro] DEFAULT ((0)),
[ProfitD] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ProfitD] DEFAULT ((0)),
[ProfitLL] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ProfitLL] DEFAULT ((0)),
[ProfitEuro] [float] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_ProfitEuro] DEFAULT ((0)),
[IsSync] [bit] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_IsSync] DEFAULT ((0)),
[WorkStationID] [int] NOT NULL CONSTRAINT [DF_t_CarRentalStatistics_WorkStationID] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Cars].[tr_CarRentalStatistics] ON [Cars].[t_CarRentalStatistics]
  AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  IF NOT UPDATE(IsSync)
  BEGIN 

    UPDATE  Cars.t_CarRentalStatistics
    SET     IsSync = 0
    WHERE   EXISTS ( SELECT TOP ( 1 )
                            s.ID
                     FROM   Inserted AS s
                     WHERE  s.ID = t_CarRentalStatistics.ID );

  END;

  BEGIN --For delete

    INSERT  INTO Alls.t_FireStoreRowsForDelete
            ( DocumentID ,
              HasImage ,
              TableName
            )
    SELECT  s.ID ,
            0 ,
            'carRentalStatistics'
    FROM    Deleted AS s
    EXCEPT
    SELECT  s.ID ,
            0 ,
            'carRentalStatistics'
    FROM    Inserted AS s;

  END;

  BEGIN --Live

    UPDATE  Alls.t_LiveVersion
    SET     VersionLive = STUFF(VersionLive, CarRentalStatistics, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')) ,
            SchemasIs = STUFF(SchemasIs, SchemaCars, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

  END;

END;
GO
ALTER TABLE [Cars].[t_CarRentalStatistics] ADD CONSTRAINT [PK_t_CarRentalStatistics] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
