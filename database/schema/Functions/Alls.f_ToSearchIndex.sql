SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [Alls].[f_ToSearchIndex]
  (
    @NamesMain Alls.td_String READONLY
  )
RETURNS NVARCHAR(MAX)
BEGIN

  DECLARE @Names Alls.td_String;
  DECLARE @NamesNet Alls.td_String;

  INSERT INTO @Names
      ( Name )
    SELECT Name
      FROM @NamesMain;

  DECLARE @SearchIndex AS NVARCHAR(MAX) = N'' ,
    @WordCount INT = 0 ,
    @WordCount2 INT = 0 ,
    @Word AS NVARCHAR(MAX) = N'';
	
  SELECT @WordCount = COUNT(*)
    FROM @NamesMain AS s;
	
  IF @WordCount <= 0
  BEGIN
	                                                     
    RETURN '';

  END;

  WHILE ( @WordCount > 0 )
  BEGIN
    SET @WordCount -= 1;
	   	         
    SELECT @Word = LOWER(s.Name)
      FROM @NamesMain AS s
      ORDER BY s.Name
        OFFSET @WordCount ROWS FETCH NEXT 1 ROW ONLY;
		      
    INSERT INTO @Names
        ( Name
        )
      SELECT s.Item
        FROM Alls.f_SplitString(@Word, ' ') AS s;

  END;
  
  SELECT @WordCount = COUNT(*)
    FROM @Names AS s;

  WHILE ( @WordCount > 0 )
  BEGIN
    SET @WordCount -= 1;
	         
    SELECT @Word = LOWER(s.Name)
      FROM @Names AS s
      ORDER BY s.Name
        OFFSET @WordCount ROWS FETCH NEXT 1 ROW ONLY;

    BEGIN --For ii As Integer = 1 To i.Length
   	
      SELECT @WordCount2 = LEN(@Word);
      WHILE ( @WordCount2 > 0 )
      BEGIN
	         
        INSERT INTO @NamesNet
            ( Name )
          VALUES ( SUBSTRING(@Word, 1, @WordCount2) );
     
        SET @WordCount2 -= 1;

      END;

    END;	

  END;

  DELETE FROM @Names;
  INSERT INTO @Names
      ( Name
      )
    SELECT DISTINCT s.Name
      FROM @NamesNet AS s;

  RETURN  Alls.f_CastListToString(@Names);

END;



GO
