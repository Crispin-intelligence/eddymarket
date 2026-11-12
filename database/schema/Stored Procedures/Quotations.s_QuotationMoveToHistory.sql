SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Quotations].[s_QuotationMoveToHistory]
  @StatusIs TINYINT ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = 0;

      INSERT  INTO Quotations.t_QuotationHistory
              ( ID ,
                Ref ,
                RefF ,
                RefPaper ,
                SaveFrom ,
                SoldID ,
                SoldRefF ,
                DateIs ,
                DateOnly ,
                DateMonthly ,
                DateYearly ,
                AccountID ,
                Account ,
                AccountNumberF ,
                SalespersonID ,
                Salesperson ,
                CommissionRate ,
                CommissionRateF ,
                CommissionRateType ,
                CommissionValue ,
                CommissionValueF ,
                CommissionValueD ,
                CommissionValueLL ,
                CommissionValueEuro ,
                AttentionTo ,
                SubjectIs ,
                WarrantyID ,
                Warranty ,
                TypeID ,
                TypeIs ,
                CurrencyID ,
                Currency ,
                ExchangeRate ,
                ExchangeRateLL ,
                ExchangeRateEuro ,
                Total ,
                TotalF ,
                TotalD ,
                TotalLL ,
                TotalEuro ,
                DiscountIs ,
                DiscountIsF ,
                DiscountIsD ,
                DiscountIsLL ,
                DiscountIsEuro ,
                TaxRate ,
                TaxRateF ,
                TaxValue ,
                TaxValueF ,
                TaxValueD ,
                TaxValueLL ,
                TaxValueEuro ,
                NetIs ,
                NetIsF ,
                NetIsD ,
                NetIsLL ,
                NetIsEuro ,
                NetIsAR ,
                NetIsEN ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                Cost ,
                CostF ,
                CostD ,
                CostLL ,
                CostEuro ,
                Qtys ,
                StatusIs ,
                WhyThisStatus ,
                IsConfirm ,
                NotificationAfterDays ,
                NotificationDate ,
                NotificationStop ,
                NotificationTextAR ,
                NotificationTextEN ,
                DescriptionIs ,
                ItemsNames ,
                ItemHaveDiscount ,
                DateCreate ,
                WorkStationID
              )
      SELECT  s.ID ,
              s.Ref ,
              s.RefF ,
              s.RefPaper ,
              s.SaveFrom ,
              s.SoldID ,
              s.SoldRefF ,
              s.DateIs ,
              s.DateOnly ,
              s.DateMonthly ,
              s.DateYearly ,
              s.AccountID ,
              s.Account ,
              s.AccountNumberF ,
              s.SalespersonID ,
              s.Salesperson ,
              s.CommissionRate ,
              s.CommissionRateF ,
              s.CommissionRateType ,
              s.CommissionValue ,
              s.CommissionValueF ,
              s.CommissionValueD ,
              s.CommissionValueLL ,
              s.CommissionValueEuro ,
              s.AttentionTo ,
              s.SubjectIs ,
              s.WarrantyID ,
              s.Warranty ,
              s.TypeID ,
              s.TypeIs ,
              s.CurrencyID ,
              s.Currency ,
              s.ExchangeRate ,
              s.ExchangeRateLL ,
              s.ExchangeRateEuro ,
              s.Total ,
              s.TotalF ,
              s.TotalD ,
              s.TotalLL ,
              s.TotalEuro ,
              s.DiscountIs ,
              s.DiscountIsF ,
              s.DiscountIsD ,
              s.DiscountIsLL ,
              s.DiscountIsEuro ,
              s.TaxRate ,
              s.TaxRateF ,
              s.TaxValue ,
              s.TaxValueF ,
              s.TaxValueD ,
              s.TaxValueLL ,
              s.TaxValueEuro ,
              s.NetIs ,
              s.NetIsF ,
              s.NetIsD ,
              s.NetIsLL ,
              s.NetIsEuro ,
              s.NetIsAR ,
              s.NetIsEN ,
              s.Profit ,
              s.ProfitF ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro ,
              s.Cost ,
              s.CostF ,
              s.CostD ,
              s.CostLL ,
              s.CostEuro ,
              s.Qtys ,
              @StatusIs ,
              s.WhyThisStatus ,
              s.IsConfirm ,
              s.NotificationAfterDays ,
              s.NotificationDate ,
              s.NotificationStop ,
              s.NotificationTextAR ,
              s.NotificationTextEN ,
              s.DescriptionIs ,
              s.ItemsNames ,
              s.ItemHaveDiscount ,
              s.DateCreate ,
              s.WorkStationID
      FROM    Quotations.t_Quotation AS s
      WHERE   s.ID = @ID;

      INSERT  INTO Quotations.t_QuotationHistoryDetail
              ( ID ,
                QuotationHistoryID ,
                ItemSharedID ,
                ItemUnityID ,
                Qty ,
                QtyWithUnity ,
                Qtys ,
                Price ,
                PriceF ,
                PriceD ,
                PriceLL ,
                PriceEuro ,
                DiscountIs ,
                DiscountIsF ,
                DiscountIsValue ,
                DiscountIsValueF ,
                DiscountIsValueD ,
                DiscountIsValueLL ,
                DiscountIsValueEuro ,
                SubTotal ,
                SubTotalF ,
                SubTotalD ,
                SubTotalLL ,
                SubTotalEuro ,
                DiscountQuotation ,
                DiscountQuotationF ,
                DiscountQuotationD ,
                DiscountQuotationLL ,
                DiscountQuotationEuro ,
                TaxRate ,
                TaxRateF ,
                TaxValue ,
                TaxValueF ,
                TaxValueD ,
                TaxValueLL ,
                TaxValueEuro ,
                Total ,
                TotalF ,
                TotalD ,
                TotalLL ,
                TotalEuro ,
                Cost ,
                CostF ,
                CostD ,
                CostLL ,
                CostEuro ,
                Profit ,
                ProfitF ,
                ProfitD ,
                ProfitLL ,
                ProfitEuro ,
                ProfitTotal ,
                ProfitTotalF ,
                ProfitTotalD ,
                ProfitTotalLL ,
                ProfitTotalEuro ,
                DescriptionIs ,
                SortAt ,
                DateCreate ,
                WorkStationID
              )
      SELECT  s.ID ,
              s.QuotationID ,
              s.ItemSharedID ,
              s.ItemUnityID ,
              s.Qty ,
              s.QtyWithUnity ,
              s.Qtys ,
              s.Price ,
              s.PriceF ,
              s.PriceD ,
              s.PriceLL ,
              s.PriceEuro ,
              s.DiscountIs ,
              s.DiscountIsF ,
              s.DiscountIsValue ,
              s.DiscountIsValueF ,
              s.DiscountIsValueD ,
              s.DiscountIsValueLL ,
              s.DiscountIsValueEuro ,
              s.SubTotal ,
              s.SubTotalF ,
              s.SubTotalD ,
              s.SubTotalLL ,
              s.SubTotalEuro ,
              s.DiscountQuotation ,
              s.DiscountQuotationF ,
              s.DiscountQuotationD ,
              s.DiscountQuotationLL ,
              s.DiscountQuotationEuro ,
              s.TaxRate ,
              s.TaxRateF ,
              s.TaxValue ,
              s.TaxValueF ,
              s.TaxValueD ,
              s.TaxValueLL ,
              s.TaxValueEuro ,
              s.Total ,
              s.TotalF ,
              s.TotalD ,
              s.TotalLL ,
              s.TotalEuro ,
              s.Cost ,
              s.CostF ,
              s.CostD ,
              s.CostLL ,
              s.CostEuro ,
              s.Profit ,
              s.ProfitF ,
              s.ProfitD ,
              s.ProfitLL ,
              s.ProfitEuro ,
              s.ProfitTotal ,
              s.ProfitTotalF ,
              s.ProfitTotalD ,
              s.ProfitTotalLL ,
              s.ProfitTotalEuro ,
              s.DescriptionIs ,
              s.SortAt ,
              s.DateCreate ,
              s.WorkStationID
      FROM    Quotations.t_QuotationDetail AS s
      WHERE   s.QuotationID = @ID;

      INSERT  INTO Quotations.t_QuotationNoteLinkHistory
              ( ID ,
                QuotationHistoryID ,
                NoteID ,
                SortAt ,
                DateCreate ,
                WorkStationID
              )
      SELECT  s.ID ,
              s.QuotationID ,
              s.NoteID ,
              s.SortAt ,
              s.DateCreate ,
              s.WorkStationID
      FROM    Quotations.t_QuotationNoteLink AS s
      WHERE   s.QuotationID = @ID;

    END;

    BEGIN --Delete

      DELETE  FROM Quotations.t_QuotationNoteLink
      WHERE   QuotationID = @ID;

      DELETE  FROM Quotations.t_QuotationDetail
      WHERE   QuotationID = @ID;

      DELETE  FROM Quotations.t_Quotation
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Quotations.t_QuotationMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                1 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;

    COMMIT TRANSACTION;

    RETURN 1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN @Return;

  END CATCH;

END;













GO
