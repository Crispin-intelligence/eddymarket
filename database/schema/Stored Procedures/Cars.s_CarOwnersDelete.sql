SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Cars].[s_CarOwnersDelete]
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
        @OwnerProfileID UNIQUEIDENTIFIER ,
        @Return INT;

    END;

    BEGIN --Set info
	    
      SELECT TOP ( 1 )
              @CarID = s.CarID ,
              @OwnerProfileID = s.OwnerProfileID
      FROM    Cars.t_CarOwners AS s
      WHERE   s.ID = @ID;

    END;

    BEGIN --Insert

      DELETE  FROM Cars.t_CarOwners
      WHERE   ID = @ID;
	  
    END;

    BEGIN --Fix t_Car

      UPDATE  Cars.t_CarOwnersProfile
      SET     CarsCount = ( SELECT  COUNT(s.ID)
                            FROM    Cars.t_CarOwners AS s
                            WHERE   s.OwnerProfileID = t_CarOwnersProfile.ID
                          )
      WHERE   ID = @OwnerProfileID;

      UPDATE  Cars.t_Car
      SET     CarOwnersCount = ( SELECT COUNT(s.ID)
                                 FROM   Cars.t_CarOwners AS s
                                 WHERE  s.CarID = t_Car.ID
                               ) ,
              CarOwners = Alls.f_FixXML(( SELECT DISTINCT
                                                  ', ' + s1.Name AS [text()]
                                          FROM    Cars.t_CarOwners AS s
                                          INNER JOIN Cars.t_CarOwnersProfile AS s1 ON s1.ID = s.OwnerProfileID
                                          WHERE   s.CarID = t_Car.ID
                                        FOR
                                          XML PATH('')
                                        ))
      WHERE   ID = @CarID;

    END;

    BEGIN --Insert t_CarMoving

      SET @Return = -1;

      INSERT  INTO Cars.t_CarMoving
              ( UserID ,
                SectionID ,
                EventIs ,
                EventType ,
                ComputerIP ,
                Computer ,
                ComputerAccount
              )
      VALUES  ( @UserID ,
                @CarID ,
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

    RETURN  @Return;

  END CATCH;

END;







GO
