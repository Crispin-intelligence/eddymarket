SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_DiscountUpdate]
    @EmployeeID UNIQUEIDENTIFIER,
    @TypeID UNIQUEIDENTIFIER,
    @FromEmployeeID UNIQUEIDENTIFIER,
    @DateIs DATE,
    @ImplementationIn DATE,
    @ValueIs FLOAT,
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @Why NVARCHAR(MAX),
    @CancelIf NVARCHAR(MAX),
    @StatusIs TINYINT,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX),
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

            UPDATE Employees.t_Discount
            SET DateIs = @DateIs,
                EmployeeID = @EmployeeID,
                Employee = Employees.f_EmployeeGetName(@EmployeeID),
                TypeID = @TypeID,
                TypeIs = Employees.f_DiscountTypeGetName(@TypeID),
                FromEmployeeID = @FromEmployeeID,
                FromEmployee = Employees.f_EmployeeGetName(FromEmployeeID),
                ImplementationIn = @ImplementationIn,
                CurrencyID = @CurrencyID,
                Currency = Currencys.f_CurrencyGetName(@CurrencyID),
                ExchangeRate = @ExchangeRate,
                ValueIs = @ValueIs,
                ValueIsF = Currencys.f_Format(@CurrencyID, @ValueIs),
                ValueIsD = @ValueIs / @ExchangeRate,
                ValueIsLL = Currencys.f_ExchangeToLL(@CurrencyID, @ValueIs, @ValueIs / @ExchangeRate),
                ValueIsEuro = Currencys.f_ExchangeToEuro(@CurrencyID, @ValueIs, @ValueIs / @ExchangeRate),
                ValueIsAR = Currencys.f_ToWordAR(@ValueIs, @CurrencyID, 1),
                ValueIsEN = Currencys.f_ToWordEN(@ValueIs, @CurrencyID, 1),
                Why = @Why,
                CancelIf = @CancelIf,
                StatusIs = @StatusIs
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_DiscountMoving
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
            (@UserID, @ID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

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
