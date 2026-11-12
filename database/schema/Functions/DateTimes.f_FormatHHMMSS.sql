SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [DateTimes].[f_FormatHHMMSS]
(
    @ValueIs FLOAT,
    @UnitIs NVARCHAR(MAX)
)
RETURNS VARCHAR(20)
AS
BEGIN

    BEGIN

        IF @ValueIs = 0
        BEGIN

            RETURN '';

        END;

    END;

    BEGIN --DECLARE

        DECLARE @SecondIs INT,
                @MinuteIs INT,
                @HourIs INT;

    END;

    BEGIN --Convert seconds

        IF (@UnitIs = 'h')
        BEGIN

            SET @SecondIs = @ValueIs * 60 * 60;

        END;
        ELSE IF (@UnitIs = 'm')
        BEGIN

            SET @SecondIs = @ValueIs * 60;

        END;
        ELSE IF (@UnitIs = 's')
        BEGIN

            SET @SecondIs = @ValueIs;

        END;
        ELSE
        BEGIN

            SET @SecondIs = 0;

        END;

    END;

    BEGIN --Calculation

        SET @HourIs = @SecondIs / 60 / 60;

        SET @MinuteIs = (@SecondIs / 60) - (@HourIs * 60);

        SET @SecondIs = @SecondIs % 60;

    END;

    RETURN FORMAT(@HourIs, '00:') + FORMAT(@MinuteIs, '00:') + FORMAT(@SecondIs, '00.##');

END;
GO
