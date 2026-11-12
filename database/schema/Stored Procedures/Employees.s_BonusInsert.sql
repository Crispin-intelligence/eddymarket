SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Employees].[s_BonusInsert]
    @EmployeeIDs NVARCHAR(MAX),
    @TypeID UNIQUEIDENTIFIER,
    @FromEmployeeID UNIQUEIDENTIFIER,
    @DateIs DATE,
    @ImplementationIn DATE,
    @ValueIs FLOAT,
    @CurrencyID UNIQUEIDENTIFIER,
    @ExchangeRate DECIMAL(18, 2),
    @Why NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER,
    @EventBase NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --Declare

            DECLARE @IDs TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                RefF NVARCHAR(MAX) NOT NULL
            );

            DECLARE @Return INT,
                    @Ref BIGINT;

        END;

        BEGIN --Set info

            SELECT @Ref = ISNULL(MAX(o.Ref), 0)
            FROM
            (
                SELECT MAX(s.Ref) AS Ref
                FROM Employees.t_Bonus AS s
                UNION ALL
                SELECT MAX(s.Ref) AS Ref
                FROM Employees.t_BonusHistory AS s
            ) AS o;

        END;

        BEGIN --Insert

            SET @Return = 0;

            INSERT INTO Employees.t_Bonus
            (
                Ref,
                RefF,
                DateIs,
                EmployeeID,
                Employee,
                TypeID,
                TypeIs,
                FromEmployeeID,
                FromEmployee,
                ImplementationIn,
                CurrencyID,
                Currency,
				ExchangeRate,
                ValueIs,
                ValueIsF,
                ValueIsD,
                ValueIsLL,
                ValueIsEuro,
                ValueIsAR,
                ValueIsEN,
                Why
            )
            OUTPUT Inserted.ID,
                   Inserted.RefF
            INTO @IDs
            (
                ID,
                RefF
            )
            SELECT @Ref + ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
                   FORMAT(@Ref + ROW_NUMBER() OVER (ORDER BY (SELECT 1)), 'n0'),
                   @DateIs,
                   s.ID,
                   Employees.f_EmployeeGetName(s.ID),
                   @TypeID,
                   Employees.f_BonusTypeGetName(@TypeID),
                   @FromEmployeeID,
                   Employees.f_EmployeeGetName(@FromEmployeeID),
                   @ImplementationIn,
                   @CurrencyID,
                   Currencys.f_CurrencyGetName(@CurrencyID),
				   @ExchangeRate,
                   @ValueIs,
                   Currencys.f_Format(@CurrencyID, @ValueIs),
                   @ValueIs / @ExchangeRate,
                   Currencys.f_ExchangeToLL(@CurrencyID, @ValueIs, @ValueIs / @ExchangeRate),
                   Currencys.f_ExchangeToEuro(@CurrencyID, @ValueIs, @ValueIs / @ExchangeRate),
                   Currencys.f_ToWordAR(@ValueIs, @CurrencyID, 1),
                   Currencys.f_ToWordEN(@ValueIs, @CurrencyID, 1),
                   @Why
            FROM Alls.CastArrayToListGuid(@EmployeeIDs) AS s;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_BonusMoving
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
                   @EventBase + s.RefF,
                   0,
                   @ComputerIP,
                   @Computer,
                   @ComputerAccount
            FROM @IDs AS s;

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
