SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_FileStorageRebuildingStatistics]
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

            UPDATE Company.t_FileStorage
            SET LinkC = COALESCE(
                        (
                            SELECT COUNT_BIG(*)
                            FROM Company.t_FileStorageLinked AS t
                            WHERE t.FileStorageID = t_FileStorage.ID
                        ),
                        0
                                ),
                LinkItemC = COALESCE(
                            (
                                SELECT COUNT_BIG(*)
                                FROM Company.t_FileStorageLinked AS t
                                WHERE t.SectionID = 10
                                      AND t.FileStorageID = t_FileStorage.ID
                            ),
                            0
                                    ),
                LinkCustomerC = COALESCE(
                                (
                                    SELECT COUNT_BIG(*)
                                    FROM Company.t_FileStorageLinked AS t
                                    WHERE t.SectionID = 15
                                          AND t.FileStorageID = t_FileStorage.ID
                                ),
                                0
                                        ),
                LinkEmployeeC = COALESCE(
                                (
                                    SELECT COUNT_BIG(*)
                                    FROM Company.t_FileStorageLinked AS t
                                    WHERE t.SectionID = 33
                                          AND t.FileStorageID = t_FileStorage.ID
                                ),
                                0
                                        ),
                LinkVendorC = COALESCE(
                              (
                                  SELECT COUNT_BIG(*)
                                  FROM Company.t_FileStorageLinked AS t
                                  WHERE t.SectionID = 67
                                        AND t.FileStorageID = t_FileStorage.ID
                              ),
                              0
                                      ),
                LinkSalesPersonC = COALESCE(
                                   (
                                       SELECT COUNT_BIG(*)
                                       FROM Company.t_FileStorageLinked AS t
                                       WHERE t.SectionID = 149
                                             AND t.FileStorageID = t_FileStorage.ID
                                   ),
                                   0
                                           );

        END;

        BEGIN --Insert event

            SET @Return = -1;

            INSERT INTO Company.t_FileStorageMoving
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
