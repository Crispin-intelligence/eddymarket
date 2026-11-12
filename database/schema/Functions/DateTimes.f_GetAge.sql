SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [DateTimes].[f_GetAge]
(
    @DateBegin DATE
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    BEGIN --DECLARE

        DECLARE @DateIs DATETIME,
                @Year INT,
                @Month INT,
                @Day INT,
                @YearF NVARCHAR(MAX),
                @MonthF NVARCHAR(MAX),
                @DayF NVARCHAR(MAX),
                @OutPutF NVARCHAR(MAX);

    END;

    BEGIN --Set year

        SET @DateIs = @DateBegin;

        SET @Year = DATEDIFF(YEAR, @DateIs, GETDATE()) - CASE
                                                             WHEN (MONTH(@DateBegin) > MONTH(GETDATE()))
                                                                  OR
                                                                  (
                                                                      MONTH(@DateBegin) = MONTH(GETDATE())
                                                                      AND DAY(@DateBegin) > DAY(GETDATE())
                                                                  ) THEN
                                                                 1
                                                             ELSE
                                                                 0
                                                         END;

        SET @DateIs = DATEADD(YEAR, @Year, @DateIs);

    END;

    BEGIN --Set month

        SET @Month = DATEDIFF(MONTH, @DateIs, GETDATE()) - CASE
                                                               WHEN DAY(@DateBegin) > DAY(GETDATE()) THEN
                                                                   1
                                                               ELSE
                                                                   0
                                                           END;

        SET @DateIs = DATEADD(MONTH, @Month, @DateIs);

    END;

    BEGIN --Set day

        SET @Day = DATEDIFF(DAY, @DateIs, GETDATE());

    END;

    BEGIN --Format

        SET @YearF = CASE @Year
                         WHEN 0 THEN
                             ''
                         WHEN 1 THEN
                             FORMAT(@Year, '0') + ' Year'
                         ELSE
                             FORMAT(@Year, '0') + ' Years'
                     END;

        SET @MonthF = CASE @Month
                          WHEN 0 THEN
                              ''
                          WHEN 1 THEN
                              IIF(@Year = 0, '', ' \ ') + FORMAT(@Month, '0') + ' Month'
                          ELSE
                              IIF(@Year = 0, '', ' \ ') + FORMAT(@Month, '0') + ' Months'
                      END;

        SET @DayF = CASE @Day
                        WHEN 0 THEN
                            ''
                        WHEN 1 THEN
                            IIF(@Month = 0, '', ' \ ') + FORMAT(@Day, '0') + ' Day'
                        ELSE
                            IIF(@Month = 0, '', ' \ ') + FORMAT(@Day, '0') + ' Days'
                    END;

        SET @OutPutF = @YearF + @MonthF + @DayF;

    END;

    RETURN @OutPutF;

END;



GO
