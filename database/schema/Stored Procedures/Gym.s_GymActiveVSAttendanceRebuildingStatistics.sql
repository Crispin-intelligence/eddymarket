SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Gym].[s_GymActiveVSAttendanceRebuildingStatistics]
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @DateList AS TABLE
        (
          DateIs DATE ,
          CountIs BIGINT
        );

      DECLARE @FromDate DATE ,
        @ToDate DATE ,
        @Days BIGINT ,
        @Index BIGINT ,
        @Return INT;

    END;

    BEGIN --Set info
	  
      SELECT  @FromDate = MIN(o.DateIs) ,
              @ToDate = MAX(o.ToDate)
      FROM    ( SELECT DISTINCT
                        s.DateIs ,
                        s.ToDate
                FROM    Gym.t_GymSubscription AS s
                UNION ALL
                SELECT DISTINCT
                        s.DateIs ,
                        s.ToDate
                FROM    Gym.t_GymSubscriptionHistory AS s
              ) AS o;
    
      SET @Days = DATEDIFF(DAY, @FromDate, @ToDate);

      SET @Index = 0;

      WHILE ( @Index <= @Days )
      BEGIN
		    
        INSERT  INTO @DateList
                ( DateIs )
        VALUES  ( DATEADD(DAY, @Index, @FromDate) );

        SET @Index += 1;

      END;
	 
    END;
	 
    BEGIN --Delete t_GymActiveVSAttendance

      SET @Return = 0;

      TRUNCATE TABLE Gym.t_GymActiveVSAttendance;
	  
    END;
   
    BEGIN --Insert t_GymActiveVSAttendance from t_GymSubscription

      INSERT  INTO Gym.t_GymActiveVSAttendance
              ( DateIs ,
                DateMonthly ,
                DateYearly ,
                ActiveNumber 
	          )
      SELECT  t.DateIs ,
              DATEFROMPARTS(YEAR(t.DateIs), MONTH(t.DateIs), 1) ,
              DATEFROMPARTS(YEAR(t.DateIs), 1, 1) ,
              ( SELECT  COUNT_BIG(*)
                FROM    Gym.t_GymSubscription AS s
                WHERE   s.DateIs <= t.DateIs
                        AND s.ToDate >= t.DateIs
              ) + ( SELECT  COUNT_BIG(*)
                    FROM    Gym.t_GymSubscriptionHistory AS s
                    WHERE   s.DateIs <= t.DateIs
                            AND s.ToDate >= t.DateIs
                  )
      FROM    @DateList AS t;
             
    END;
	   
    BEGIN --Insert t_GymActiveVSAttendance from t_GymMemberAttendance
	
      DELETE  FROM @DateList;

      INSERT  INTO @DateList
              ( DateIs ,
                CountIs
              )
      SELECT  s.DateOnly ,
              COUNT_BIG(*)
      FROM    Gym.t_GymMemberAttendance AS s
      GROUP BY s.DateOnly;

      MERGE Gym.t_GymActiveVSAttendance AS t
      USING @DateList AS s
      ON s.DateIs = t.DateIs
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ( DateIs ,
                 DateMonthly ,
                 DateYearly ,
                 AttendanceNumber
               )
        VALUES ( s.DateIs ,
                 DATEFROMPARTS(YEAR(s.DateIs), MONTH(s.DateIs), 1) ,
                 DATEFROMPARTS(YEAR(s.DateIs), 1, 1) ,
                 s.CountIs
               )
      WHEN MATCHED THEN
        UPDATE SET
               t.AttendanceNumber += s.CountIs;
             
    END;

    BEGIN --Delete empty row

      DELETE  FROM Gym.t_GymActiveVSAttendance
      WHERE   ActiveNumber <= 0
              AND AttendanceNumber <= 0;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      INSERT  INTO Gym.t_GymSubscriptionMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                '00000000-0000-0000-0000-000000000000' ,
                @Event ,
                6 ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

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
