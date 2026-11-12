SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_FileStorageLinkedInsert]
    @OwnerID UNIQUEIDENTIFIER,
    @SectionID INT,
    @FileStorageID UNIQUEIDENTIFIER,
    @UserID UNIQUEIDENTIFIER,
    @Event NVARCHAR(MAX),
    @ComputerIP NVARCHAR(MAX),
    @Computer NVARCHAR(MAX),
    @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        BEGIN --DECLARE

            DECLARE @Return INT;

        END;

        BEGIN --Insert

            SET @Return = -6;

            INSERT INTO Company.t_FileStorageLinked
            (
                OwnerID,
                SectionID,
                FileStorageID,
                FileStorage
            )
            VALUES
            (@OwnerID, @SectionID, @FileStorageID, Company.f_FileStorageGetName(@FileStorageID));

        END;

        BEGIN --Insert event

            SET @Return = -1;

            IF @SectionID = 33
            BEGIN

                UPDATE Company.t_FileStorage
                SET LinkEmployeeC += 1
                WHERE ID = @FileStorageID;

                UPDATE Employees.t_Employee
                SET FileStorageC += 1
                WHERE ID = @OwnerID;

                INSERT INTO Employees.t_EmployeeMoving
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
                (@UserID, @OwnerID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

            END;
            ELSE IF @SectionID = 149
            BEGIN

                UPDATE Company.t_FileStorage
                SET LinkSalesPersonC += 1
                WHERE ID = @FileStorageID;

                UPDATE Employees.t_SalesPerson
                SET FileStorageC += 1
                WHERE ID = @OwnerID;

                INSERT INTO Employees.t_SalesPersonMoving
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
                (@UserID, @OwnerID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

            END;
            ELSE IF @SectionID = 15
            BEGIN

                UPDATE Company.t_FileStorage
                SET LinkCustomerC += 1
                WHERE ID = @FileStorageID;

                UPDATE Customers.t_Customer
                SET FileStorageC += 1
                WHERE ID = @OwnerID;

                INSERT INTO Customers.t_CustomerMoving
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
                (@UserID, @OwnerID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

            END;
            ELSE IF @SectionID = 10
            BEGIN

                UPDATE Company.t_FileStorage
                SET LinkItemC += 1
                WHERE ID = @FileStorageID;

                UPDATE Items.t_ItemShared
                SET FileStorageC += 1
                WHERE ID = @OwnerID;

                INSERT INTO Items.t_ItemSharedMoving
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
                (@UserID, @OwnerID, @Event, 1, @ComputerIP, @Computer, @ComputerAccount);

            END;

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
