SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Gym].[s_GymActiveVSAttendanceMerge] @FromDate DATE ,
  @ToDate DATE ,
  @ActiveOrAttendance BIT ,
  @Addition BIT
AS
BEGIN
  
  BEGIN --Declare
	
    DECLARE @DateList AS TABLE ( DateIs DATE );
    DECLARE @Days BIGINT ,
      @Index BIGINT ,
      @NumberIs INT;
	  	
  END;

  BEGIN --Set info
	    
    SET @Days = DATEDIFF(DAY, @FromDate, @ToDate);

    SET @Index = 0;

    WHILE ( @Index <= @Days )
    BEGIN
		    
      INSERT INTO @DateList
          ( DateIs )
        VALUES ( DATEADD(DAY, @Index, @FromDate) );

      SET @Index += 1;

    END;
	 
    SET @NumberIs = IIF(@Addition = 1, 1, -1);

  END;
	
  BEGIN --Insert
	
    MERGE Gym.t_GymActiveVSAttendance AS t
    USING @DateList AS s
    ON s.DateIs = t.DateIs
    WHEN NOT MATCHED BY TARGET THEN
      INSERT ( DateIs ,
               DateMonthly ,
               DateYearly ,
               ActiveNumber ,
               AttendanceNumber
             )
      VALUES ( s.DateIs ,
               DATEFROMPARTS(YEAR(s.DateIs), MONTH(s.DateIs), 1) ,
               DATEFROMPARTS(YEAR(s.DateIs), 1, 1) ,
               IIF(@ActiveOrAttendance = 1, @NumberIs, 0) ,
               IIF(@ActiveOrAttendance = 1, 0, @NumberIs)
             )
    WHEN MATCHED THEN
      UPDATE SET t.ActiveNumber += IIF(@ActiveOrAttendance = 1, @NumberIs, 0) ,
                  t.AttendanceNumber += IIF(@ActiveOrAttendance = 1, 0, @NumberIs);

  END;

  BEGIN --Delete empty row

    DELETE FROM Gym.t_GymActiveVSAttendance
      WHERE ActiveNumber <= 0 AND AttendanceNumber <= 0;

  END;
 
  RETURN 1;

END;


GO
