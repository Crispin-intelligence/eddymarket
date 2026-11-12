SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Employees].[s_EmployeeUpdateSalaryAndShift]
  @DateWork DATE ,
  @IDFingerPrint INT ,
  @CurrencyID UNIQUEIDENTIFIER ,
  @SalaryIs FLOAT ,
  @SalaryDeliveryService FLOAT ,
  @DaysWork INT ,
  @DaysWorkHours INT ,
  @TotalHoursFree INT ,
  @VacationDay TINYINT ,
  @HoursLateX DECIMAL(4, 2) ,
  @HoursOverX DECIMAL(4, 2) ,
  @CalculationEarly BIT ,
  @CalculationOverTime BIT ,
  @ShiftFrom TIME(7) ,
  @ShiftTo TIME(7) ,
  @UserID UNIQUEIDENTIFIER ,
  @Event NVARCHAR(MAX) ,
  @ComputerIP NVARCHAR(MAX) ,
  @Computer NVARCHAR(MAX) ,
  @ComputerAccount NVARCHAR(MAX) ,
  @ID UNIQUEIDENTIFIER
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION;

    BEGIN --Declare

      DECLARE @Return INT ,
        @CurrencyIDOld UNIQUEIDENTIFIER;

    END;

    BEGIN --Set info

      SELECT TOP ( 1 )
              @CurrencyIDOld = s.CurrencyID
      FROM    Employees.t_Employee AS s
      WHERE   s.ID = @ID
      ORDER BY s.ID;

    END;

    BEGIN --Update 

      SET @Return = 0;

      UPDATE  Employees.t_Employee
      SET     DateWork = @DateWork ,
              IDFingerPrint = IDFingerPrint ,
              CurrencyID = @CurrencyID ,
              Currency = Currencys.f_CurrencyGetName(@CurrencyID) ,
              SalaryIs = @SalaryIs ,
              SalaryIsF = Currencys.f_Format(@CurrencyID, @SalaryIs) ,
              SalaryDeliveryService = @SalaryDeliveryService ,
              SalaryDeliveryServiceF = Currencys.f_Format(@CurrencyID, @SalaryDeliveryService) ,
              DaysWork = @DaysWork ,
              DaysWorkHours = @DaysWorkHours ,
              TotalHoursMustWork = ( @DaysWorkHours * @DaysWork ) - @TotalHoursFree ,
              TotalHoursFree = @TotalHoursFree ,
              VacationDay = @VacationDay ,
              HoursLateX = @HoursLateX ,
              HoursOverX = @HoursOverX ,
              CalculationEarly = @CalculationEarly ,
              CalculationOverTime = @CalculationOverTime ,
              ShiftFrom = @ShiftFrom ,
              ShiftTo = @ShiftTo
      WHERE   ID = @ID;

      UPDATE  Employees.t_Employee
      SET     SalaryHours = SalaryIs / TotalHoursMustWork ,
              SalaryHoursF = Currencys.f_Format(CurrencyID, SalaryIs / TotalHoursMustWork)
      WHERE   ID = @ID;

      UPDATE  Employees.t_Employee
      SET     SearchText = Employees.f_EmployeeSearchTextGet(ID)
      WHERE   ID = @ID;

    END;

    IF @CurrencyIDOld <> @CurrencyID
    BEGIN --Update DiscountAvailable and BonusAvailable

      UPDATE  Employees.t_Employee
      SET     DiscountAvailable = ( SELECT  COALESCE(SUM(CASE s1.TypeIs
                                                           WHEN 0 THEN s.ValueIsD
                                                           WHEN 1 THEN s.ValueIsLL
                                                           ELSE s.ValueIsEuro
                                                         END), 0) AS DiscountAvailable
                                    FROM    Employees.t_Discount AS s
                                    LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = t_Employee.CurrencyID
                                    WHERE   s.EmployeeID = t_Employee.ID
                                  ) ,
              BonusAvailable = ( SELECT COALESCE(SUM(CASE s1.TypeIs
                                                       WHEN 0 THEN s.ValueIsD
                                                       WHEN 1 THEN s.ValueIsLL
                                                       ELSE s.ValueIsEuro
                                                     END), 0) AS BonusAvailable
                                 FROM   Employees.t_Bonus AS s
                                 LEFT JOIN Currencys.t_Currency AS s1 ON s1.ID = t_Employee.CurrencyID
                                 WHERE  s.EmployeeID = t_Employee.ID
                               )
      WHERE   ID = @ID;

      UPDATE  Employees.t_Employee
      SET     DiscountAvailableF = Currencys.f_Format(CurrencyID, DiscountAvailable) ,
              BonusAvailableF = Currencys.f_Format(CurrencyID, BonusAvailable)
      WHERE   ID = @ID;

    END;

    BEGIN --Insert event

      SET @Return = -1;

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
                @ID ,
                @Event ,
                1 ,
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
