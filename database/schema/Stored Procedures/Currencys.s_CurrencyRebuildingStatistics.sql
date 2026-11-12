SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Currencys].[s_CurrencyRebuildingStatistics]
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Rebuilding statistics

            SET @Return = 0;

            UPDATE Currencys.t_Currency
            SET DisplayFormat = DisplayFormat,
                AccountC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_Account AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                EmployeeC =
                (
                    SELECT COUNT(*)
                    FROM Employees.t_Employee AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                EmployeeDiscountC =
                (
                    SELECT COUNT(*)
                    FROM Employees.t_Discount AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ) +
                (
                    SELECT COUNT(*)
                    FROM Employees.t_DiscountHistory AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                ItemC =
                (
                    SELECT COUNT(*)
                    FROM Items.t_ItemShared AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                PurchaseC =
                (
                    SELECT COUNT(*)
                    FROM Invoices.t_Purchasing AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                PurchaseReturnC =
                (
                    SELECT COUNT(*)
                    FROM Invoices.t_PurchasingReturn AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                SellC =
                (
                    SELECT COUNT(*)
                    FROM Invoices.t_Sold AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                SellReturnC =
                (
                    SELECT COUNT(*)
                    FROM Invoices.t_SoldReturn AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                InventoryAdjustmentC =
                (
                    SELECT COUNT(*)
                    FROM Items.t_StockTake AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                QuotationC =
                (
                    SELECT COUNT(*)
                    FROM Quotations.t_Quotation AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ) +
                (
                    SELECT COUNT(*)
                    FROM Quotations.t_QuotationHistory AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                ChequeC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_Cheque AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ) +
                (
                    SELECT COUNT(*)
                    FROM Company.t_ChequeHistory AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                VoucherC =
                (
                    SELECT COUNT(*)
                    FROM Company.t_Bond AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ) +
                (
                    SELECT COUNT(*)
                    FROM Company.t_BondHistory AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                ),
                TransactionC =
                (
                    SELECT COUNT(*)
                    FROM Transactions.t_TransactionDetail AS s
                    WHERE (s.CurrencyID = t_Currency.ID)
                );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Currencys.t_CurrencyMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            VALUES
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

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
