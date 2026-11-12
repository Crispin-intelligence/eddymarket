SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_ShiftDownloadData]
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

            DECLARE @Shift TABLE
            (
                ID UNIQUEIDENTIFIER NOT NULL,
                RefF NVARCHAR(MAX) NOT NULL
            );

            DECLARE @IDsFingerPrint TABLE
            (
                ID INT NOT NULL
            );

            DECLARE @ID UNIQUEIDENTIFIER,
                    @IDFingerPrint INT,
                    @HoursLateX DECIMAL(4, 2),
                    @HoursOverX DECIMAL(4, 2),
                    @CalculationEarly BIT,
                    @CalculationOverTime BIT,
                    @ShiftFrom TIME,
                    @ShiftTo TIME,
                    @return INT,
                    @Ref BIGINT;

        END;

        --BEGIN --Download data from finger print

        --    SET @return = 0;

        --    DECLARE c CURSOR FORWARD_ONLY FOR
        --    SELECT t.ID
        --    FROM Employees.t_Employee AS t
        --    WHERE t.IDFingerPrint <> 0;

        --    OPEN c;
        --    FETCH NEXT FROM c
        --    INTO @ID;

        --    WHILE @@FETCH_STATUS = 0
        --    BEGIN -- Insert data

        --        BEGIN --Set info

        --            SELECT @Ref = COALESCE(MAX(o.Ref), 0)
        --            FROM
        --            (
        --                SELECT COALESCE(MAX(s.Ref), 0) AS Ref
        --                FROM Employees.t_Shift AS s
        --                UNION ALL
        --                SELECT COALESCE(MAX(s.Ref), 0) AS Ref
        --                FROM Employees.t_ShiftHistory AS s
        --            ) AS o;

        --            SELECT TOP (1)
        --                   @IDFingerPrint = IDFingerPrint,
        --                   @HoursLateX = HoursLateX,
        --                   @HoursOverX = HoursOverX,
        --                   @CalculationEarly = CalculationEarly,
        --                   @CalculationOverTime = CalculationOverTime,
        --                   @ShiftFrom = ShiftFrom,
        --                   @ShiftTo = ShiftTo
        --            FROM Employees.t_Employee
        --            WHERE ID = @ID
        --            ORDER BY ID;

        --        END;

        --        INSERT INTO @IDsFingerPrint
        --        (
        --            ID
        --        )
        --        VALUES
        --        (@IDFingerPrint);

        --        INSERT INTO Employees.t_Shift
        --        (
        --            Ref,
        --            RefF,
        --            EmployeeID,
        --            Employee,
        --            FromIsMust,
        --            FromIs,
        --            CalculationEarly,
        --            LateX,
        --            ToIsMust,
        --            ToIs,
        --            CalculationOverTime,
        --            OverTimeX
        --        )
        --        OUTPUT Inserted.ID,
        --               Inserted.RefF
        --        INTO @Shift
        --        (
        --            ID,
        --            RefF
        --        )
        --        SELECT @Ref + ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        --               FORMAT(@Ref + ROW_NUMBER() OVER (ORDER BY (SELECT 1)), 'n0'),
        --               @ID,
        --               Employees.f_EmployeeGetName(@ID),
        --               CASE
        --                   WHEN o.FromIs IS NOT NULL THEN
        --                       DATETIMEFROMPARTS(
        --                                            YEAR(o.FromIs),
        --                                            MONTH(o.FromIs),
        --                                            DAY(o.FromIs),
        --                                            DATEPART(HOUR, @ShiftFrom),
        --                                            DATEPART(MINUTE, @ShiftFrom),
        --                                            DATEPART(SECOND, @ShiftFrom),
        --                                            DATEPART(MILLISECOND, @ShiftFrom)
        --                                        )
        --                   ELSE
        --                       DATETIMEFROMPARTS(
        --                                            YEAR(o.ToIs),
        --                                            MONTH(o.ToIs),
        --                                            DAY(o.ToIs),
        --                                            DATEPART(HOUR, @ShiftFrom),
        --                                            DATEPART(MINUTE, @ShiftFrom),
        --                                            DATEPART(SECOND, @ShiftFrom),
        --                                            DATEPART(MILLISECOND, @ShiftFrom)
        --                                        )
        --               END,
        --               o.FromIs,
        --               @CalculationEarly,
        --               @HoursLateX,
        --               CASE
        --                   WHEN o.ToIs IS NULL THEN
        --                       DATETIMEFROMPARTS(
        --                                            YEAR(o.FromIs),
        --                                            MONTH(o.FromIs),
        --                                            DAY(o.FromIs),
        --                                            DATEPART(HOUR, @ShiftTo),
        --                                            DATEPART(MINUTE, @ShiftTo),
        --                                            DATEPART(SECOND, @ShiftTo),
        --                                            DATEPART(MILLISECOND, @ShiftTo)
        --                                        )
        --                   ELSE
        --                       DATETIMEFROMPARTS(
        --                                            YEAR(o.ToIs),
        --                                            MONTH(o.ToIs),
        --                                            DAY(o.ToIs),
        --                                            DATEPART(HOUR, @ShiftTo),
        --                                            DATEPART(MINUTE, @ShiftTo),
        --                                            DATEPART(SECOND, @ShiftTo),
        --                                            DATEPART(MILLISECOND, @ShiftTo)
        --                                        )
        --               END,
        --               o.ToIs,
        --               @CalculationOverTime,
        --               @HoursOverX
        --        FROM
        --        (
        --            SELECT CHECKTYPE,
        --                   CASE
        --                       WHEN LAG(CHECKTYPE, 1, '') OVER (ORDER BY USERID, CHECKTIME) = 'O'
        --                            AND CHECKTYPE = 'O' THEN
        --                           NULL
        --                       ELSE
        --                           CHECKTIME
        --                   END AS FromIs,
        --                   CASE
        --                       WHEN LAG(CHECKTYPE, 1, '') OVER (ORDER BY USERID, CHECKTIME) LIKE N'O'
        --                            AND CHECKTYPE = 'O' THEN
        --                           CHECKTIME
        --                       WHEN LEAD(CHECKTYPE, 1, '') OVER (ORDER BY USERID, CHECKTIME) LIKE N'O' THEN
        --                           LEAD(CHECKTIME, 1, '') OVER (ORDER BY USERID, CHECKTIME)
        --                       WHEN CHECKTYPE = 'O' THEN
        --                           CHECKTIME
        --                       ELSE
        --                           NULL
        --                   END AS ToIs
        --            FROM FingerPrint.dbo.CHECKINOUT
        --            WHERE IsDownloaded = 0
        --                  AND USERID = @IDFingerPrint
        --        ) AS o
        --        WHERE CASE
        --                  WHEN o.CHECKTYPE = 'O' THEN
        --                      CASE
        --                          WHEN o.FromIs IS NULL
        --                               OR o.ToIs IS NULL THEN
        --                              1
        --                          ELSE
        --                              0
        --                      END
        --                  ELSE
        --                      1
        --              END = 1;

        --        FETCH NEXT FROM c
        --        INTO @ID;

        --    END;

        --    CLOSE c;

        --    DEALLOCATE c;

        --END;

        --BEGIN --i downloaded

        --    UPDATE FingerPrint.dbo.CHECKINOUT
        --    SET IsDownloaded = 1
        --    WHERE EXISTS
        --    (
        --        SELECT TOP (1)
        --               s.ID
        --        FROM @IDsFingerPrint AS s
        --        WHERE s.ID = CHECKINOUT.USERID
        --    );

        --END;

        --BEGIN --Rebuilding Statistics

        --    UPDATE Employees.t_Employee
        --    SET InWorkNow = Employees.f_EmployeeGetInWorkNow(ID)
        --    WHERE IDFingerPrint <> 0;
			
        --    DECLARE @IDs_ Alls.tt_Guid;

        --    INSERT INTO @IDs_
        --    (
        --        ID
        --    )
        --    SELECT s.ID
        --    FROM @Shift AS s;

        --    EXECUTE Employees.s_ShiftFormats @IDs_;

        --END;

        --BEGIN --Insert event

        --    SET @return = -1;

        --    INSERT INTO Employees.t_ShiftMoving
        --    (
        --        UserID,
        --        SectionID,
        --        EventIs,
        --        EventType,
        --        ComputerIP,
        --        Computer,
        --        ComputerAccount
        --    )
        --    SELECT @UserID,
        --           s.ID,
        --           @EventBase + s.RefF,
        --           0,
        --           @ComputerIP,
        --           @Computer,
        --           @ComputerAccount
        --    FROM @Shift AS s;

        --END;

        COMMIT TRANSACTION;

        RETURN 1;

    END TRY
    BEGIN CATCH

        ROLLBACK;

        RETURN @return;

    END CATCH;

END;

GO
