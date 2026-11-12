SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [Alls].[CastArrayToListString] ( @IDList NVARCHAR(MAX) )
RETURNS @IDs TABLE ( Name NVARCHAR(450) )
AS
    BEGIN

        DECLARE @LastCommaPosition INT ,
            @NextCommaPosition INT ,
            @EndOfStringPosition INT ,
            @StartOfStringPosition INT ,
            @LengthOfString INT ,
            @IDString NVARCHAR(450) ,
            @IDValue INT;
		
        SET @LastCommaPosition = 0;
        SET @NextCommaPosition = -1;

        IF LTRIM(RTRIM(@IDList)) <> ''
            BEGIN

                WHILE ( @NextCommaPosition <> 0 )
                    BEGIN

                        SET @NextCommaPosition = CHARINDEX(',', @IDList,
                                                           @LastCommaPosition
                                                           + 1);

                        IF @NextCommaPosition = 0
                            SET @EndOfStringPosition = LEN(@IDList);
                        ELSE
                            SET @EndOfStringPosition = @NextCommaPosition - 1;

                        SET @StartOfStringPosition = @LastCommaPosition + 1;
                        SET @LengthOfString = ( @EndOfStringPosition + 1 )
                            - @StartOfStringPosition;

                        SET @IDString = SUBSTRING(@IDList,
                                                  @StartOfStringPosition,
                                                  @LengthOfString);                  

                        IF @IDString <> ''
                            INSERT  @IDs
                            VALUES  ( RTRIM(LTRIM(@IDString)) );

                        SET @LastCommaPosition = @NextCommaPosition;

                    END; 

            END; 

        RETURN;

        ErrorBlock:

        RETURN;

    END; 



GO
