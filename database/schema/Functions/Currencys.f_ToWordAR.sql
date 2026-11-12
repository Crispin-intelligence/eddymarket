SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Currencys].[f_ToWordAR]
(
    @FullNumber NUMERIC(38, 2),
    @ID UNIQUEIDENTIFIER,
    @WithDemail BIT
)
RETURNS VARCHAR(8000)
AS
BEGIN

    DECLARE @Number NUMERIC(38, 0) = ABS(PARSENAME(@FullNumber, 2));

    DECLARE @Description NVARCHAR(MAX) = N'';
    SELECT @Description = DescriptionAR
    FROM Currencys.t_Currency
    WHERE ID = @ID;


    DECLARE @NumberAfterReplicate NVARCHAR(15);

    SET @NumberAfterReplicate = RIGHT(REPLICATE('0', 15) + CAST(FLOOR(@Number) AS NVARCHAR(15)), 15);
    DECLARE @outputString NVARCHAR(1000),
            @NumberWithDecimal AS NVARCHAR(400),
            @ThreeWords AS INT;

    SET @ThreeWords = 0;
    SET @outputString = N'';
    DECLARE @Tafket TABLE
    (
        num INT,
        NoName NVARCHAR(100)
    );
    INSERT INTO @Tafket
    VALUES
    (0, N'');
    INSERT INTO @Tafket
    VALUES
    (1, N'واحد');
    INSERT INTO @Tafket
    VALUES
    (2, N'اثنان');
    INSERT INTO @Tafket
    VALUES
    (3, N'ثلاثة');
    INSERT INTO @Tafket
    VALUES
    (4, N'اربعة');
    INSERT INTO @Tafket
    VALUES
    (5, N'خمسة');
    INSERT INTO @Tafket
    VALUES
    (6, N'ستة');
    INSERT INTO @Tafket
    VALUES
    (7, N'سبعة');
    INSERT INTO @Tafket
    VALUES
    (8, N'ثمانية');
    INSERT INTO @Tafket
    VALUES
    (9, N'تسعة');
    INSERT INTO @Tafket
    VALUES
    (10, N'عشرة');
    INSERT INTO @Tafket
    VALUES
    (11, N'احدى عشر');
    INSERT INTO @Tafket
    VALUES
    (12, N'اثنى عشر');
    INSERT INTO @Tafket
    VALUES
    (13, N'ثلاثة عشر');
    INSERT INTO @Tafket
    VALUES
    (14, N'اربعة عشر');
    INSERT INTO @Tafket
    VALUES
    (15, N'خمسة عشر');
    INSERT INTO @Tafket
    VALUES
    (16, N'ستة عشر');

    INSERT INTO @Tafket
    VALUES
    (17, N'سبعة عشر');
    INSERT INTO @Tafket
    VALUES
    (18, N'ثمانية عشر');
    INSERT INTO @Tafket
    VALUES
    (19, N'تسعة عشر');
    INSERT INTO @Tafket
    VALUES
    (20, N'عشرون');
    INSERT INTO @Tafket
    VALUES
    (30, N'ثلاثون');
    INSERT INTO @Tafket
    VALUES
    (40, N'اربعون');
    INSERT INTO @Tafket
    VALUES
    (50, N'خمسون');
    INSERT INTO @Tafket
    VALUES
    (60, N'ستون');
    INSERT INTO @Tafket
    VALUES
    (70, N'سبعون');
    INSERT INTO @Tafket
    VALUES
    (80, N'ثمانون');
    INSERT INTO @Tafket
    VALUES
    (90, N'تسعون');
    INSERT INTO @Tafket
    VALUES
    (100, N'مائة');
    INSERT INTO @Tafket
    VALUES
    (200, N'مائتان');
    INSERT INTO @Tafket
    VALUES
    (300, N'ثلاثمائة');
    INSERT INTO @Tafket
    VALUES
    (400, N'أربعمائة');
    INSERT INTO @Tafket
    VALUES
    (500, N'خمسمائة');
    INSERT INTO @Tafket
    VALUES
    (600, N'ستمائة');
    INSERT INTO @Tafket
    VALUES
    (700, N'سبعمائة');

    INSERT INTO @Tafket
    VALUES
    (800, N'ثمانمائة');

    INSERT INTO @Tafket
    VALUES
    (900, N'تسعمائة');
    INSERT INTO @Tafket
    SELECT FirstN.num + LasteN.num,
           LasteN.NoName + N' و ' + FirstN.NoName
    FROM
    (SELECT * FROM @Tafket WHERE num >= 20 AND num <= 90) FirstN
        CROSS JOIN
        (SELECT * FROM @Tafket WHERE num >= 1 AND num <= 9) LasteN;

    INSERT INTO @Tafket
    SELECT FirstN.num + LasteN.num,
           FirstN.NoName + N' و ' + LasteN.NoName
    FROM
    (SELECT * FROM @Tafket WHERE num >= 100 AND num <= 900) FirstN
        CROSS JOIN
        (SELECT * FROM @Tafket WHERE num >= 1 AND num <= 99) LasteN;


    IF LEFT(@NumberAfterReplicate, 3) > 0
        SET @outputString
            = @outputString + ISNULL(
                              (
                                  SELECT NoName FROM @Tafket WHERE num = LEFT(@NumberAfterReplicate, 3)
                              ),
                              ''
                                    ) + N' ترليون';
    IF LEFT(RIGHT(@NumberAfterReplicate, 12), 3) > 0
       AND LEFT(@NumberAfterReplicate, 3) > 0
        SET @outputString = @outputString + N' و ';
    IF LEFT(RIGHT(@NumberAfterReplicate, 12), 3) > 0
        SET @outputString
            = @outputString + ISNULL(
                              (
                                  SELECT NoName
                                  FROM @Tafket
                                  WHERE num = LEFT(RIGHT(@NumberAfterReplicate, 12), 3)
                              ),
                              ''
                                    ) + N' بليون';
    IF LEFT(RIGHT(@NumberAfterReplicate, 9), 3) > 0
    BEGIN
        SET @outputString = @outputString + CASE
                                                WHEN @Number > 999000000 THEN
                                                    N' و'
                                                ELSE
                                                    ''
                                            END;
        SET @ThreeWords = LEFT(RIGHT(@NumberAfterReplicate, 9), 3);
        SET @outputString
            = @outputString + ISNULL(
                              (
                                  SELECT CASE
                                             WHEN @ThreeWords > 2 THEN
                                                 NoName
                                         END
                                  FROM @Tafket
                                  WHERE num = LEFT(RIGHT(@NumberAfterReplicate, 9), 3)
                              ),
                              ''
                                    ) + CASE
                                            WHEN @ThreeWords = 2 THEN
                                                N' مليونان'
                                            WHEN @ThreeWords
                                                 BETWEEN 3 AND 10 THEN
                                                N' ملايين'
                                            ELSE
                                                N' مليون'
                                        END;
    END;

    IF LEFT(RIGHT(@NumberAfterReplicate, 6), 3) > 0
    BEGIN
        SET @outputString = @outputString + CASE
                                                WHEN @Number > 999000 THEN
                                                    N' و'
                                                ELSE
                                                    ''
                                            END;
        SET @ThreeWords = LEFT(RIGHT(@NumberAfterReplicate, 6), 3);
        SET @outputString
            = @outputString + ISNULL(
                              (
                                  SELECT CASE
                                             WHEN @ThreeWords > 2 THEN
                                                 NoName
                                         END
                                  FROM @Tafket
                                  WHERE num = LEFT(RIGHT(@NumberAfterReplicate, 6), 3)
                              ),
                              ''
                                    ) + CASE
                                            WHEN @ThreeWords = 2 THEN
                                                N' الفان'
                                            WHEN @ThreeWords
                                                 BETWEEN 3 AND 10 THEN
                                                N' الاف'
                                            ELSE
                                                N' الف'
                                        END;
    END;

    IF RIGHT(@NumberAfterReplicate, 3) > 0
    BEGIN

        IF @Number > 999
        BEGIN
            SET @outputString = @outputString + N' و';
        END;

        IF RIGHT(@NumberAfterReplicate, 2) = '01'
           OR RIGHT(@NumberAfterReplicate, 2) = '02'
        BEGIN
            --set @outputString=@outputString + case  when @Number>1000  then ' و'  else '' end 
            --set @ThreeWords=left(right(@NumberAfterReplicate,6),3)
            SET @outputString
                = @outputString + ' '
                  + ISNULL(
                    (
                        SELECT NoName FROM @Tafket WHERE num = RIGHT(@NumberAfterReplicate, 3)
                    ),
                    ''
                          );
        END;

        SET @ThreeWords = RIGHT(@NumberAfterReplicate, 2);

        IF @ThreeWords = 0
        BEGIN
            --   set @outputString=@outputString + ' و' 
            SET @outputString = @outputString + ISNULL(
                                                (
                                                    SELECT NoName
                                                    FROM @Tafket
                                                    WHERE @ThreeWords = 0
                                                          AND num = RIGHT(@NumberAfterReplicate, 3)
                                                ),
                                                ''
                                                      );
        END;

    END;

    SET @ThreeWords = RIGHT(@NumberAfterReplicate, 2);
    SET @outputString = @outputString + ISNULL(
                                        (
                                            SELECT NoName
                                            FROM @Tafket
                                            WHERE @ThreeWords > 2
                                                  AND num = RIGHT(@NumberAfterReplicate, 3)
                                        ),
                                        ''
                                              );
    SET @outputString = @outputString + ' ' + CASE
                                                  WHEN @ThreeWords = 2 THEN
                                                      ' ' + @Description
                                                  WHEN @ThreeWords
                                                       BETWEEN 3 AND 10 THEN
                                                      ''
                                                  ELSE
                                                      ''
                                              END;
    IF RIGHT(RTRIM(@outputString), 1) = ','
        SET @outputString = SUBSTRING(@outputString, 1, LEN(@outputString) - 1);

    --if  right(@Number,len(@Number)-charindex('.',@Number)) >0 and charindex('.',@Number)<>0 
    --    begin 
    --        set @ThreeWords=left(right(round(@Number,3),3),3) 
    --        SELECT @NumberWithDecimal=  N' و' + ISNULL((SELECT NoName from @Tafket where num=left(right(round(@Number,3),3),3)  AND @ThreeWords >3),'') 
    --        set @NumberWithDecimal = @NumberWithDecimal+  case when  @ThreeWords=2 then N' فلسان' when @ThreeWords between 3 and 10 then N' فلسات'  else N'  فلس' end 
    --set @outputString = @outputString + N' و '+ CONVERT(varchar(max),@ThreeWords)+ case when  @ThreeWords=2 then N' فلسان' when @ThreeWords between 3 and 10 then N' فلسات'  else N'  فلس' end --@NumberWithDecimal 
    --END 

    IF @WithDemail = 1
    BEGIN
        SET @outputString += N' ' + @Description + N' ' + Currencys.f_ToWordARDecimal(PARSENAME(@FullNumber, 1), @ID);
    END;
    ELSE
    BEGIN
        SET @outputString += N' ' + @Description;
    END;

    RETURN RTRIM(@outputString) + N' ' + N' فقط لا غير';
END;








GO
