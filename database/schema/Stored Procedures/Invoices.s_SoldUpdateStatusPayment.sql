SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Invoices].[s_SoldUpdateStatusPayment]
    @StatusPayment TINYINT,
    @UserID UNIQUEIDENTIFIER,
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
    @IDAndEvent Alls.tt_IDAndEvent READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @Return INT;

        END;

        BEGIN --Update 

            SET @Return = 0;

            UPDATE Invoices.t_Sold
            SET StatusPayment = @StatusPayment,
                CommissionAvailableValue = IIF(SalespersonTakeCommission = 1,
                                               0,
                                               IIF(CommissionRateType = 0,
                                                   CommissionValue,
                                                   IIF(@StatusPayment = 0, 0, CommissionValue))),
                CommissionAvailableValueD = IIF(SalespersonTakeCommission = 1,
                                                0,
                                                IIF(CommissionRateType = 0,
                                                    CommissionValueD,
                                                    IIF(@StatusPayment = 0, 0, CommissionValueD))),
                CommissionAvailableValueLL = IIF(SalespersonTakeCommission = 1,
                                                 0,
                                                 IIF(CommissionRateType = 0,
                                                     CommissionValueLL,
                                                     IIF(@StatusPayment = 0, 0, CommissionValueLL))),
                CommissionAvailableValueEuro = IIF(SalespersonTakeCommission = 1,
                                                   0,
                                                   IIF(CommissionRateType = 0,
                                                       CommissionValueEuro,
                                                       IIF(@StatusPayment = 0, 0, CommissionValueEuro)))
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_Sold.ID
            );

            UPDATE Invoices.t_Sold
            SET CommissionAvailableValueF = Currencys.f_Format(CurrencyID, CommissionAvailableValue)
            WHERE EXISTS
            (
                SELECT TOP (1) s.ID FROM @IDAndEvent AS s WHERE s.ID = t_Sold.ID
            );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Invoices.t_SoldMoving
            (
                UserID,
                SectionID,
                EventIs,
                EventType,
                ComputerIP,
                Computer,
                ComputerAccount
            )
            SELECT @UserID,
                   s.ID,
                   s.EventIs,
                   1,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDAndEvent AS s;

        END;

        COMMIT TRANSACTION;

        SELECT 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        SELECT @Return;

    END CATCH;

END;









GO
