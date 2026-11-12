SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_VacationUpdate]
    @DateIs DATE,
    @EmployeeID UNIQUEIDENTIFIER,
    @TypeID UNIQUEIDENTIFIER,
    @DescriptionIs NVARCHAR(MAX),
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

            UPDATE Employees.t_Vacation
            SET DateIs = @DateIs,
                EmployeeID = @EmployeeID,
                Employee = Employees.f_EmployeeGetName(@EmployeeID),
                TypeID = @TypeID,
                TypeIs = Employees.f_VacationTypeGetName(@TypeID),
                DescriptionIs = @DescriptionIs
            WHERE ID = @ID;

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_VacationMoving
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
