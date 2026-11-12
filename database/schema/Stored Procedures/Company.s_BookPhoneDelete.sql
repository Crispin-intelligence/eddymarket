SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_BookPhoneDelete]
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

    BEGIN --DECLARE

      DECLARE @OwnerID UNIQUEIDENTIFIER ,
        @SectionID INT ,
        @Return INT;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @OwnerID = s.OwnerID ,
              @SectionID = s.SectionID
      FROM    Company.t_BookPhone AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update

      SET @Return = -2;

      DELETE  FROM Company.t_BookPhone
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

      IF @SectionID = 15
      BEGIN

        INSERT  INTO Customers.t_CustomerMoving
                ( UserID ,
                  SectionID ,
                  EventIs ,
                  EventType ,
                  ComputerIP ,
                  Computer ,
                  ComputerAccount
                )
        VALUES  ( @UserID ,
                  @OwnerID ,
                  @Event ,
                  @EventType ,
                  @ComputerIP ,
                  @Computer ,
                  @ComputerAccount
                );

      END;
      ELSE
        IF @SectionID = 33
        BEGIN

          INSERT  INTO Employees.t_EmployeeMoving
                  ( UserID ,
                    SectionID ,
                    EventIs ,
                    EventType ,
                    ComputerIP ,
                    Computer ,
                    ComputerAccount
                  )
          VALUES  ( @UserID ,
                    @OwnerID ,
                    @Event ,
                    @EventType ,
                    @ComputerIP ,
                    @Computer ,
                    @ComputerAccount
                  );

        END;
        ELSE
          IF @SectionID = 38
          BEGIN

            INSERT  INTO Company.t_BankMoving
                    ( UserID ,
                      SectionID ,
                      EventIs ,
                      EventType ,
                      ComputerIP ,
                      Computer ,
                      ComputerAccount
                    )
            VALUES  ( @UserID ,
                      @OwnerID ,
                      @Event ,
                      @EventType ,
                      @ComputerIP ,
                      @Computer ,
                      @ComputerAccount
                    );

          END;
          ELSE
            IF @SectionID = 42
            BEGIN

              INSERT  INTO Company.t_WarehouseMoving
                      ( UserID ,
                        SectionID ,
                        EventIs ,
                        EventType ,
                        ComputerIP ,
                        Computer ,
                        ComputerAccount
                      )
              VALUES  ( @UserID ,
                        @OwnerID ,
                        @Event ,
                        @EventType ,
                        @ComputerIP ,
                        @Computer ,
                        @ComputerAccount
                      );

            END;
            ELSE
              IF @SectionID = 67
              BEGIN

                INSERT  INTO Vendors.t_VendorMoving
                        ( UserID ,
                          SectionID ,
                          EventIs ,
                          EventType ,
                          ComputerIP ,
                          Computer ,
                          ComputerAccount
                        )
                VALUES  ( @UserID ,
                          @OwnerID ,
                          @Event ,
                          @EventType ,
                          @ComputerIP ,
                          @Computer ,
                          @ComputerAccount
                        );

              END;
              ELSE
                IF @SectionID = 149
                BEGIN

                  INSERT  INTO Employees.t_SalesPersonMoving
                          ( UserID ,
                            SectionID ,
                            EventIs ,
                            EventType ,
                            ComputerIP ,
                            Computer ,
                            ComputerAccount
                          )
                  VALUES  ( @UserID ,
                            @OwnerID ,
                            @Event ,
                            @EventType ,
                            @ComputerIP ,
                            @Computer ,
                            @ComputerAccount
                          );

                END;
                ELSE
                  IF @SectionID = 153
                  BEGIN

                    INSERT  INTO Company.t_ContactMoving
                            ( UserID ,
                              SectionID ,
                              EventIs ,
                              EventType ,
                              ComputerIP ,
                              Computer ,
                              ComputerAccount
                            )
                    VALUES  ( @UserID ,
                              @OwnerID ,
                              @Event ,
                              @EventType ,
                              @ComputerIP ,
                              @Computer ,
                              @ComputerAccount
                            );

                  END;
                  ELSE
                    IF @SectionID = 163
                    BEGIN

                      INSERT  INTO Company.t_DoctorMoving
                              ( UserID ,
                                SectionID ,
                                EventIs ,
                                EventType ,
                                ComputerIP ,
                                Computer ,
                                ComputerAccount
                              )
                      VALUES  ( @UserID ,
                                @OwnerID ,
                                @Event ,
                                @EventType ,
                                @ComputerIP ,
                                @Computer ,
                                @ComputerAccount
                              );

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
