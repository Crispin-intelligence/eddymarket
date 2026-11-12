SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_DiscountTypeRebuildingStatistics]
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

            UPDATE Employees.t_DiscountType
            SET DiscountTotalD =
                (
                    SELECT COALESCE(SUM(t.ValueIsD), 0)
                    FROM Employees.t_Discount AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ) +
                (
                    SELECT COALESCE(SUM(t.ValueIsD), 0)
                    FROM Employees.t_DiscountHistory AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ),
                DiscountTotalLL =
                (
                    SELECT COALESCE(SUM(t.ValueIsLL), 0)
                    FROM Employees.t_Discount AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ) +
                (
                    SELECT COALESCE(SUM(t.ValueIsLL), 0)
                    FROM Employees.t_DiscountHistory AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ),
                DiscountTotalEuro =
                (
                    SELECT COALESCE(SUM(t.ValueIsEuro), 0)
                    FROM Employees.t_Discount AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ) +
                (
                    SELECT COALESCE(SUM(t.ValueIsEuro), 0)
                    FROM Employees.t_DiscountHistory AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ),
                DiscountC =
                (
                    SELECT COUNT_BIG(*)
                    FROM Employees.t_Discount AS t
                    WHERE t.TypeID = t_DiscountType.ID
                ) +
                (
                    SELECT COUNT_BIG(*)
                    FROM Employees.t_DiscountHistory AS t
                    WHERE t.TypeID = t_DiscountType.ID
                );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Employees.t_DiscountTypeMoving
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
