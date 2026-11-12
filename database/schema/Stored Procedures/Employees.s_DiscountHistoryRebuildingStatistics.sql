SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [Employees].[s_DiscountHistoryRebuildingStatistics]
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

        BEGIN --Rebuild statistics

            SET @Return = 0;

            DISABLE TRIGGER Employees.tr_DiscountHistory ON Employees.t_DiscountHistory;

            UPDATE Employees.t_DiscountHistory
            SET Employee = Employees.f_EmployeeGetName(EmployeeID),
                TypeIs = Employees.f_DiscountTypeGetName(TypeID),
                FromEmployee = Employees.f_EmployeeGetName(FromEmployeeID),
                Currency = Currencys.f_CurrencyGetName(CurrencyID),
                ValueIsF = Currencys.f_Format(CurrencyID, ValueIs),
                ValueIsAR = Currencys.f_ToWordAR(ValueIs, CurrencyID, 1),
                ValueIsEN = Currencys.f_ToWordEN(ValueIs, CurrencyID, 1);

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
            (@UserID, '00000000-0000-0000-0000-000000000000', @Event, 6, @ComputerIP, @Computer, @ComputerAccount);

        END;

        BEGIN --Live

            UPDATE Alls.t_LiveVersion
            SET VersionLive = STUFF(VersionLive, Discount, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000')),
                SchemasIs = STUFF(SchemasIs, SchemaEmployee, 3, FORMAT(DATEPART(MILLISECOND, GETDATE()), '000'));

        END;

        ENABLE TRIGGER Employees.tr_DiscountHistory ON Employees.t_DiscountHistory;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @Return;

    END CATCH;

END;


GO
