SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Company].[s_SocialMediaInsert]
  @OwnerID UNIQUEIDENTIFIER ,
  @AccountIs NVARCHAR(MAX) ,
  @SectionID INT ,
  @TypeID UNIQUEIDENTIFIER ,
  @DescriptionIs NVARCHAR(MAX) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @EventType TINYINT ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --DECLARE

      DECLARE @Return INT;

    END;

    BEGIN --Insert

      SET @Return = -2;

      INSERT  INTO Company.t_SocialMedia
              ( OwnerID ,
                AccountIs ,
                SectionID ,
                TypeID ,
                TypeIs ,
                DescriptionIs
              )
      VALUES  ( @OwnerID ,
                @AccountIs ,
                @SectionID ,
                @TypeID ,
                Company.f_SocialMediaTypeGetName(@TypeID) ,
                @DescriptionIs
              );

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
