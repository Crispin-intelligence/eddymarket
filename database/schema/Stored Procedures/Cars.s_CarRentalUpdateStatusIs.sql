SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarRentalUpdateStatusIs]
  @CheckOutDate DATETIME ,
  @CheckOutFuel INT ,
  @CheckOutOdometer INT ,
  @CheckInDate DATETIME ,
  @CheckInFuel INT ,
  @CheckInOdometer INT ,
  @StatusIs TINYINT ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY

    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @CarID UNIQUEIDENTIFIER ,
        @OdometerConsumed INT = @CheckInOdometer - @CheckOutOdometer ,
        @DurationInMinutes BIGINT = DATEDIFF(MINUTE, @CheckOutDate, @CheckInDate) ,
        @DurationF NVARCHAR(MAX) = DateTimes.f_DateTimeDiff(@CheckOutDate, @CheckInDate, 'd', 1, '', 'NA') ,
        @return INT = 0;

    END;

    BEGIN --Set info
	  
      SELECT TOP ( 1 )
              @CarID = s.CarID
      FROM    Cars.t_CarRental AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Insert

      UPDATE  Cars.t_CarRental
      SET     CheckOutDate = @CheckOutDate ,
              CheckOutFuel = @CheckOutFuel ,
              CheckOutOdometer = @CheckOutOdometer ,
              CheckInDate = @CheckInDate ,
              CheckInFuel = @CheckInFuel ,
              CheckInOdometer = @CheckInOdometer ,
              DurationInMinutes = @DurationInMinutes ,
              DurationF = @DurationF ,
              OdometerConsumed = @OdometerConsumed ,
              StatusIs = @StatusIs
      WHERE   ID = @ID;

    END;
	
    BEGIN --Update t_Car
	
      UPDATE  Cars.t_Car
      SET     AvailabilityIs = Cars.f_CarGetAvailabilityIsNow(ID) ,
              Odometer = IIF(@StatusIs = 2 AND @CheckInOdometer > 0, @CheckInOdometer, Odometer)
      WHERE   ID = @CarID;

    END;

    BEGIN --Update t_CarRentalStatistics

      UPDATE  Cars.t_CarRentalStatistics SET     
	  CarsAvailabilityAvailable = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.AvailabilityIs = 0),
	  CarsAvailabilityUnavailable = (SELECT COUNT(*) FROM Cars.t_Car AS s WHERE s.AvailabilityIs = 1);
  
    END;
	
    BEGIN --Insert t_CarRentalMoving

      SET @return = -1;

      INSERT  INTO Cars.t_CarRentalMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @ID ,
                @Event ,
                @EventType ,
                @ComputerIP ,
                @Computer ,
                @ComputerAccount
              );

    END;
 	
    COMMIT TRANSACTION;

    RETURN  1;

  END TRY
  BEGIN CATCH

    ROLLBACK;

    RETURN  @return;

  END CATCH;

END;




GO
