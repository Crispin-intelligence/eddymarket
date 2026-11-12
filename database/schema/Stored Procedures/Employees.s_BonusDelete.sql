SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Employees].[s_BonusDelete]
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

        BEGIN --Insert History

            INSERT INTO Employees.t_BonusHistory
            (
                ID,
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
                ValueIs,
                ValueIsF,
                ValueIsD,
                ValueIsLL,
                ValueIsEuro,
                ValueIsAR,
                ValueIsEN,
                Why,
                StatusIs,
                DateCreate,
                WorkStationID
            )
            SELECT ID,
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
                   ValueIs,
                   ValueIsF,
                   ValueIsD,
                   ValueIsLL,
                   ValueIsEuro,
                   ValueIsAR,
                   ValueIsEN,
                   Why,
                   @StatusIs,
                   DateCreate,
                   WorkStationID
            FROM Employees.t_Bonus
            WHERE ID = @ID;

        END;

        BEGIN --Delete

            DELETE FROM Employees.t_Bonus
            WHERE ID = @ID;

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
            VALUES
            (@UserID, @ID, @Event, 2, @ComputerIP, @Computer, @ComputerAccount);

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
