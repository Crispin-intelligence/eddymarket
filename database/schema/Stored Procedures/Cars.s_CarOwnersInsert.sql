SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Cars].[s_CarOwnersInsert]
  @CarID UNIQUEIDENTIFIER ,
  @OwnerProfileID UNIQUEIDENTIFIER ,
  @ProfitRatio DECIMAL(5, 2) ,
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
	
      DECLARE @Return INT;

    END;
	
    BEGIN --Insert

      INSERT  INTO Cars.t_CarOwners
              ( ID ,
                CarID ,
                Car ,
                OwnerProfileID ,
                OwnerProfile ,
                ProfitRatio 
	          )
      VALUES  ( @ID ,
                @CarID ,
                Cars.f_CarGetName(@CarID) ,
                @OwnerProfileID ,
                Cars.f_CarOwnersProfileGetName(@OwnerProfileID) ,
                @ProfitRatio
              );

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
